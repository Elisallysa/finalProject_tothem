import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tothem/src/models/comment.dart';
import 'package:const_date_time/const_date_time.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool done;
  final DateTime createDate;
  final DateTime dueDate;
  final List<Comment> comments;
  final List<String> attachments;

  const Task(
      {this.id = '',
      this.title = '',
      this.description = '',
      this.done = false,
      this.createDate = const ConstDateTime(0),
      this.dueDate = const ConstDateTime(0),
      this.comments = const <Comment>[],
      this.attachments = const <String>[]});

  Task copyWith(
      {String? id,
      String? title,
      String? description,
      bool? done,
      DateTime? createDate,
      DateTime? dueDate,
      List<Comment>? comments,
      List<String>? attachments}) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        done: done ?? false,
        createDate: createDate ?? this.createDate,
        dueDate: dueDate ?? this.dueDate,
        comments: comments ?? <Comment>[],
        attachments: attachments ?? <String>[]);
  }

  Task.copy(Task other)
      : id = other.id,
        title = other.title,
        description = other.description,
        done = other.done,
        createDate = other.createDate,
        dueDate = other.dueDate,
        comments = other.comments,
        attachments = other.attachments;

  static fromArray(List<dynamic> arrayFR) {
    for (var tsk in arrayFR) {}
  }

  static Task fromMap(Map<String, dynamic> data) {
    Timestamp created = data['create_date'];
    Timestamp due = data['due_date'];
    List<String> attachments = List<String>.from(data['attachments'] ?? []);

    Task task = Task(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        done: data['done'],
        createDate: created.toDate(),
        dueDate: due.toDate(),
        comments: <Comment>[],
        attachments: attachments);

    return task;
  }

  static Task fromSnapshot(DocumentSnapshot snap) {
    Timestamp created = snap['create_date'];
    Timestamp due = snap['due_date'];

    List<Comment> comments = [];
    List<String> attachments = [];
    try {
      if (snap.exists &&
          snap.data() != null &&
          snap.get('attachments') != null) {
        attachments = List<String>.from(snap['attachments'] ?? []);
      }
    } catch (e) {
      if (e is StateError) {
        print("No hay atributo attachments: ${e.message}");
      } else {
        // Manejar otros tipos de excepciones si es necesario
        print("Ocurrió un error inesperado: $e");
      }
    }

/*
    if (snap['comments'] != null) {
      // Explicit conversion from dynamic to Comment
      comments = List<Comment>.from(
          snap['comments'].map((comment) => Comment.fromJson(comment)));
    }
*/

    Task task = Task(
        id: snap['id'],
        title: snap['title'],
        description: snap['description'],
        done: snap['done'],
        createDate: created.toDate(),
        dueDate: due.toDate(),
        comments: comments,
        attachments: attachments);

    return task;
  }
}

class Activity extends Task {
  final double hours;

  const Activity({this.hours = 0}) : super();

  Activity copyWith(
      {String? id,
      String? title,
      String? description,
      bool? done,
      DateTime? createDate,
      DateTime? dueDate,
      List<Comment>? comments,
      List<String>? attachments,
      double? hours}) {
    return Activity(
      hours: hours ?? this.hours,
    );
  }
}

class GroupDynamic extends Task {
  final int numberOfStudents;
  final List<String> instructions;

  const GroupDynamic(
      {this.numberOfStudents = 0, this.instructions = const <String>[]})
      : super();

  GroupDynamic copyWith(
      {String? id,
      String? title,
      String? description,
      bool? done,
      DateTime? createDate,
      DateTime? dueDate,
      List<Comment>? comments,
      List<String>? attachments,
      int? numberOfStudents,
      List<String>? instructions}) {
    return GroupDynamic(
        numberOfStudents: numberOfStudents ?? this.numberOfStudents,
        instructions: instructions ?? this.instructions);
  }
}
