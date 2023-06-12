import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tothem/src/models/task.dart';

class Content {
  final String id;
  final int index;
  final String title;
  final String description;
  final List<Task> tasks;
  final List<String> attachments;

  const Content(
      {this.id = '',
      this.index = 0,
      this.title = '',
      this.description = '',
      this.tasks = const <Task>[],
      this.attachments = const <String>[]});

  Content copyWith(
      {String? id,
      int? index,
      String? title,
      String? description,
      List<Task>? tasks,
      List<String>? attachments}) {
    return Content(
        id: id ?? this.id,
        index: index ?? this.index,
        title: title ?? this.title,
        description: description ?? this.description,
        tasks: tasks ?? this.tasks,
        attachments: attachments ?? this.attachments);
  }

  Content.copy(Content other)
      : id = other.id,
        index = other.index,
        title = other.title,
        description = other.description,
        tasks = other.tasks,
        attachments = other.attachments;

  static Content fromSnapshot(DocumentSnapshot snap) {
    List<Task> tasks = <Task>[];

    try {
      for (var tsk in snap['tasks']) {
        final task = Task(id: tsk);
        tasks.add(task);
      }
    } catch (e) {
      print(e);
    }

    Content content = Content(
      id: snap.id,
      title: snap['title'],
      description: snap['description'],
      tasks: tasks,
    );

    return content;
  }

  factory Content.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    List<Task> tasks = [];
    if (data?['tasks'] is Iterable) {
      tasks = (data?['tasks'] as Iterable).map((taskData) {
        return Task(id: taskData);
      }).toList();
    }

    return Content(
      id: snapshot.id,
      title: data?['title'],
      description: data?['description'],
      tasks: tasks,
      attachments: data?['attachments'] is Iterable
          ? List.from(data?['attachments'])
          : <String>[],
    );
  }
}
