import 'package:tothem/src/models/comment.dart';
import 'package:const_date_time/const_date_time.dart';

abstract class Task {
  final String id;
  final String title;
  final String description;
  final bool done;
  final DateTime createDate;
  final DateTime dueDate;
  final List<Comment> comments;

  const Task(
      {this.id = '',
      this.title = '',
      this.description = '',
      this.done = false,
      this.createDate = const ConstDateTime(0),
      this.dueDate = const ConstDateTime(0),
      this.comments = const <Comment>[]});
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
      int? numberOfStudents,
      List<String>? instructions}) {
    return GroupDynamic(
        numberOfStudents: numberOfStudents ?? this.numberOfStudents,
        instructions: instructions ?? this.instructions);
  }
}
