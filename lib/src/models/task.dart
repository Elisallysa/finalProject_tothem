import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tothem/src/models/comment.dart';
import 'package:const_date_time/const_date_time.dart';

class Task {
  final String id;
  final String courseRef;
  final String title;
  final String description;
  final bool done;
  final DateTime createDate;
  final DateTime postDate;
  final DateTime dueDate;
  final List<Comment> comments;
  final List<String> attachments;

  const Task(
      {this.id = '',
      this.courseRef = '',
      this.title = '',
      this.description = '',
      this.done = false,
      this.createDate = const ConstDateTime(0),
      this.postDate = const ConstDateTime(0),
      this.dueDate = const ConstDateTime(0),
      this.comments = const <Comment>[],
      this.attachments = const <String>[]});

  Task copyWith(
      {String? id,
      String? courseRef,
      String? title,
      String? description,
      bool? done,
      DateTime? createDate,
      DateTime? postDate,
      DateTime? dueDate,
      List<Comment>? comments,
      List<String>? attachments}) {
    return Task(
        id: id ?? this.id,
        courseRef: courseRef ?? this.courseRef,
        title: title ?? this.title,
        description: description ?? this.description,
        done: done ?? false,
        createDate: createDate ?? this.createDate,
        postDate: postDate ?? this.postDate,
        dueDate: dueDate ?? this.dueDate,
        comments: comments ?? <Comment>[],
        attachments: attachments ?? <String>[]);
  }

  Task.copy(Task other)
      : id = other.id,
        courseRef = other.courseRef,
        title = other.title,
        description = other.description,
        done = other.done,
        createDate = other.createDate,
        postDate = other.postDate,
        dueDate = other.dueDate,
        comments = other.comments,
        attachments = other.attachments;

  static fromArray(List<dynamic> arrayFR) {
    for (var tsk in arrayFR) {}
  }

  static Task fromMap(Map<String, dynamic> data) {
    Timestamp created = data['create_date'];
    Timestamp posted = data['publication_date'];
    Timestamp due = data['due_date'];
    List<String> attachments = List<String>.from(data['attachments'] ?? []);

    Task task = Task(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        done: data['done'],
        createDate: created.toDate(),
        postDate: posted.toDate(),
        dueDate: due.toDate(),
        comments: <Comment>[],
        attachments: attachments);

    return task;
  }

  static Task fromSimpleMap(Map<String, dynamic> data) {
    Task task = Task(
      id: data['id'],
      done: data['done'],
    );

    return task;
  }

  static Task fromSnapshot(DocumentSnapshot snap, String courseRef) {
    Timestamp created = snap['create_date'];
    Timestamp posted = snap['publication_date'];
    Timestamp due = snap['due_date'];

    List<Comment> comments = [];
    List<String> attachments = [];
    bool done = false;
    try {
      if (snap.exists &&
          snap.data() != null &&
          snap.get('attachments') != null) {
        attachments = List<String>.from(snap['attachments'] ?? []);
      }
    } catch (e) {
      if (e is StateError) {
        print("Mapeando Task. No hay atributo \"attachments\": ${e.message}");
      } else {
        // Manejar otros tipos de excepciones si es necesario
        print("Ocurrió un error inesperado: $e");
      }
    }
    try {
      if (snap.get('done') != null) {
        done = snap['done'];
      }
    } catch (e) {
      if (e is StateError) {
        print("Mapeando Task. No existe atributo \"done\". ${e.message}");
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
        courseRef: courseRef,
        done: done,
        createDate: created.toDate(),
        postDate: posted.toDate(),
        dueDate: due.toDate(),
        comments: comments,
        attachments: attachments);

    return task;
  }

  factory Task.fromSimpleJson(Map<String, dynamic> json) =>
      Task(id: json['id'], done: json['done']);
}

class Activity extends Task {
  final double hours;

  const Activity({this.hours = 0}) : super();

  Activity copyWith(
      {String? id,
      String? courseRef,
      String? title,
      String? description,
      bool? done,
      DateTime? createDate,
      DateTime? postDate,
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
      String? courseRef,
      String? title,
      String? description,
      bool? done,
      DateTime? createDate,
      DateTime? postDate,
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
