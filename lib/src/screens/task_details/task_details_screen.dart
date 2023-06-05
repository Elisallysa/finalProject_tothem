import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:path_provider/path_provider.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:tothem/src/common/widgets/tothem_common_widgets.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';
import 'package:tothem/src/repository/bloc/task/task_event.dart';
import 'package:tothem/src/repository/bloc/task/task_state.dart';
import 'package:tothem/src/screens/screens.dart';
import 'package:tothem/src/screens/task_details/widgets/task_details_widgets.dart';

import '../../repository/bloc/task/task_bloc.dart';

class TaskDetailsScreen extends StatefulWidget {
  Course _course;
  Task _task;
  auth.User? _currentUser;

  TaskDetailsScreen({Key? key, Course? course, Task? task, auth.User? user})
      : _course = course ?? const Course(id: 'aerodriguez420230520TRANTI'),
        _task = task ?? const Task(id: 'c1t1'),
        _currentUser = user ?? auth.FirebaseAuth.instance.currentUser,
        super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  void initState() {
    super.initState();

// Debería ser el uid del profesor que ha creado el curso.
    auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TaskBloc>(context)
          .add(TaskLoading(widget._course, widget._task, currentUser!.uid));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build task details screen with task details
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._course.title),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
          if (state is TaskLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      leading: Image.asset(
                        'assets/images/task.png',
                        height: 50.h,
                        width: 50.w,
                        fit: BoxFit.scaleDown,
                      ),
                      title:
                          Text(state.task.title, style: TothemTheme.tileTitle),
                      subtitle: Text(widget._course.teacher)),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: TothemTheme.lightGrey,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: 170.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: TothemTheme.darkGreen, width: 0.8),
                                  color: state.task.done
                                      ? TothemTheme.lightGreen
                                      : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        state.task.done
                                            ? Tothem.check
                                            : Icons.clear_rounded,
                                        color: state.task.done
                                            ? TothemTheme.rybGreen
                                            : Colors.red),
                                    Text(state.task.done
                                        ? 'Completada'
                                        : 'No completada')
                                  ],
                                )),
                            const Divider(),
                            buildTaskDate(
                                context, 'Apertura: ', state.task.createDate),
                            buildTaskDate(
                                context, 'Cierre: ', state.task.createDate),
                            Visibility(
                                visible: state.task.description.isNotEmpty,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    Text(
                                      'Instrucciones',
                                      style: TothemTheme.descriptionTitle,
                                    ),
                                    Text(state.task.description)
                                  ],
                                )),
                            Visibility(
                                visible: state.attachments.isNotEmpty,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    Text('Archivos:',
                                        style: TothemTheme.descriptionTitle),
                                  ],
                                )),
                            Visibility(
                              visible: state.attachments.isNotEmpty,
                              child: Column(
                                children: state.attachments.map((attachment) {
                                  return ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(attachment.name),
                                      leading: Icon(
                                        _getFileIcon(attachment.name),
                                        color: TothemTheme.rybGreen,
                                      ),
                                      trailing: IconButton(
                                          icon: const Icon(
                                            Tothem.download,
                                            color: TothemTheme.brinkPink,
                                          ),
                                          onPressed: () async {
                                            String url = await attachment
                                                .getDownloadURL();
                                            String token = await widget
                                                ._currentUser!
                                                .getIdToken();

                                            // _downloadFile(url, token);

                                            _donwloadToPhone(attachment);
                                          })); // Crea un widget de texto para cada elemento de la lista
                                }).toList(),
                              ),
                            )
                          ]),
                    ),
                  ),
                  Center(
                    child: Visibility(
                        visible: !state.task.done,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: FilledButton(
                            onPressed: () {
                              context.read<TaskBloc>().add(TaskDone(
                                  state.course,
                                  state.task,
                                  state.course.teacher));
                            },
                            child: const Text('Marcar como completada'),
                          ),
                        )),
                  )
                ],
              ),
            );
          } else if (state is TaskError) {
            // Construir la pantalla de error
            return whiteBackgroundContainer(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 250.w,
                      child: Image.asset('assets/images/confused.png')),
                  Text('No se ha podido encontrar la tarea seleccionada.',
                      style: TothemTheme.bodyText, textAlign: TextAlign.center),
                ],
              ),
            );
          } else {
            // Otro estado, mostrar una pantalla de carga o cualquier otra lógica
            return Scaffold(
              appBar: AppBar(
                title: const Text('Cargando...'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }));
  }

  Future<void> _donwloadToPhone(storage.Reference fileRef) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${fileRef.name}');
      await fileRef.writeToFile(file);

      _showFileIsDownloaded(fileRef);
    } catch (e) {
      print(e);
    }
  }

  _showFileIsDownloaded(storage.Reference fileRef) {
    final snackBar =
        SnackBar(content: Text('Archivo ${fileRef.name} descargado.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Future<void> _downloadFile(String fileUrl, String token) async {
  try {
    final Uri downloadUrl = Uri.parse(fileUrl);
    final http.Client client = http.Client();

    final http.Request request = http.Request('GET', downloadUrl);
    request.headers['Authorization'] = 'Bearer $token';

    final http.StreamedResponse response = await client.send(request);

    final String fileName = fileUrl.split('/').last; // Nombre del archivo

    final storage.Reference storageRef =
        storage.FirebaseStorage.instance.ref(fileName);

    final http.ByteStream byteStream =
        http.ByteStream(response.stream); // Convertir a ByteStream

    final Uint8List bytes =
        await byteStream.toBytes(); // Convertir ByteStream a Uint8List

    await storageRef.putData(bytes); // Utilizar putData con Uint8List

    final String downloadLink = await storageRef.getDownloadURL();

    final downloadResponse = await http.get(Uri.parse(downloadLink));
    final downloadBytes = downloadResponse.bodyBytes;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(downloadBytes);
  } catch (error) {
    // Manejo de errores
  }
}

IconData _getFileIcon(String fileName) {
  List<String> images = ['.jpg', '.jpeg', '.png', '.gif', 'bmp'];
  List<String> docs = ['.docx', '.doc', '.txt'];
  List<String> video = ['avi', 'mp4', 'mpeg', 'mwv'];
  List<String> audio = ['mp3', 'wav', 'wma'];
  List<String> readable = ['epub', 'azw', 'ibook'];
  List<String> system = ['zip', 'rar', 'tar'];
  List<String> zip = ['mp3', 'wav', 'wma'];

  if (images.any(fileName.endsWith)) {
    return Tothem.fileImage;
  } else if (fileName.endsWith('pdf')) {
    return Tothem.filePdf;
  } else if (docs.any(fileName.endsWith)) {
    return Tothem.doc;
  } else if (video.any(fileName.endsWith)) {
    return Tothem.fileVideo;
  } else if (audio.any(fileName.endsWith)) {
    return Tothem.fileAudio;
  } else if (readable.any(fileName.endsWith)) {
    return Tothem.docText;
  } else if (system.any(fileName.endsWith)) {
    return Icons.settings_applications_sharp;
  } else if (zip.any(fileName.endsWith)) {
    return Tothem.fileArchive;
  } else {
    return Tothem.doc;
  }
}
