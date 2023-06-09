import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/models/user.dart';
import 'package:tothem/src/repository/course_repository/base_course_repository.dart';
import '../../models/course.dart';

class CourseRepository extends BaseCourseRepository {
  final FirebaseFirestore _firebaseFirestore;

  CourseRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Course>> getAllCourses() {
    return _firebaseFirestore.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<List<Course>> getRegCourses(String studentUid) async {
    final querySnapshot = await _firebaseFirestore
        .collection('registered_courses')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: studentUid)
        .get();

    final List<Course> courses = [];
    courses.clear();
    for (var doc in querySnapshot.docs) {
      if (courses.isEmpty) {
        int courseNumber = 1;
        while (doc.data().containsKey('course$courseNumber')) {
          final course = Course.fromJson(doc.data()['course$courseNumber']);
          courses.add(course);
          courseNumber++;
        }
      }
    }
    return courses;
  }

  @override
  Stream<List<Course>> getTeacherCourses(String mail) {
    String userMail = mail.substring(0, mail.indexOf('@'));

    return _firebaseFirestore
        .collection('courses')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: userMail)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList());
  }

  @override
  Stream<List<Course>> getRegisteredCourses(String userId) {
    return _firebaseFirestore
        .collection('users')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList());
  }

  @override
  Future<Course?> getCourse(String documentId) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(documentId)
          .get();

      if (snapshot.exists) {
        final Map<String, dynamic>? data =
            snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          final Course course = Course.fromJson(data);
          return course;
        }
      }
    } catch (e) {
      print('Error fetching course from Firestore: $e');
    }
    return null;
  }

  @override
  Future<List<User>> getStudents(String courseId) async {
    final QuerySnapshot<Map<String, dynamic>> tasksQuery =
        await _firebaseFirestore.collection('courses/$courseId/students').get();

    final courseStudents =
        tasksQuery.docs.map((user) => User.fromSnapshot(user)).toList();

    return courseStudents;
  }

  @override
  Future<void> createCourse(Course course, auth.User user) async {
/*
Map<String, String> categoryCodes = <String, String>{};
    Stream<List<CourseCategory>> categories =
        CategoryRepository().getAllCategories();
    await for (var categoryList in categories) {
      // iterar sobre la lista
      for (var category in categoryList) {
        categoryCodes[category.id] = category.title;
      }
    }

    await for (var categoryList in CategoryRepository().getAllCategories()) {
      // iterar sobre la lista
      for (var category in categoryList) {
        categoryCodes[category.id] = category.title;
      }
    }

    String key = categoryCodes.keys.firstWhere(
        (k) => categoryCodes[k] == course.category,
        orElse: () => 'NC');
*/
    try {
      String idSuffix = _getCourseCodeSuffix(course.title, course.category);

      final today = DateTime.now();

      String month =
          today.month < 10 ? '0${today.month}' : today.month.toString();
      String day = today.day < 10 ? '0${today.day}' : today.day.toString();

      String strDate = today.year.toString() + month + day;

      // Generate course code and checks if code exists in DB
      String courseCode;
      do {
        courseCode = generateRandomCourseCode();
      } while (await courseCodeExists(courseCode));

      String courseId = user.email!.substring(0, user.email!.indexOf('@')) +
          strDate +
          idSuffix;

      Course newCourse = course.copyWith(
          createDate: today,
          teacher: user.uid,
          id: courseId,
          code: courseCode,
          teacherName: user.displayName ??
              user.email!.substring(0, user.email!.indexOf('@')),
          teacherPhoto: user.photoURL ?? '');

      await _firebaseFirestore
          .collection("courses")
          .doc(courseId)
          .set(newCourse.toJson())
          .onError((e, _) => print(
              "Error writing new course to document in \"courses\" collection: $e"));

      Map<String, dynamic> courseCodeJson = {'course_id': courseId};

      await _firebaseFirestore
          .collection('course_codes')
          .doc(courseCode)
          .set(courseCodeJson)
          .onError((error, stackTrace) => print(
              "Error writing new course code to document in \"course_codes\" collection: $e"));
    } on Exception catch (e) {
      print('Something happened during creation of course. $e');
    }
  }

  String _getCourseCodeSuffix(String courseTitle, String courseCategory) {
    final regex = RegExp(r'[^a-zA-Z0-9_]');
    List<String> wordsInTitle = courseTitle.split(regex);
    String courseSuffix = _getCourseSuffix(wordsInTitle);

    return courseCategory + courseSuffix;
  }

  String _getCourseSuffix(List<String> wordsInTitle) {
    String suffix = '';

    if (wordsInTitle.length > 1) {
      String piece1 = wordsInTitle[0];
      String piece2 = wordsInTitle[1];

      if (piece1.length > 1 && piece2.length > 1) {
        suffix = piece1.substring(0, 2) + piece2.substring(0, 2);
      } else if (piece1.length < 2 && piece2.length > 1) {
        suffix = '$piece1${piece2}XXXX';
        suffix = suffix.substring(0, 4);
      } else if (piece1.length > 1 && piece2.length < 2) {
        suffix = '${piece1.substring(0, 2)}${piece2}XXXX';
      }
    } else {
      suffix = '${wordsInTitle[0]}XXXX';
    }

    if (suffix.length < 4) {
      suffix = '${suffix}XXXX';
    }

    return suffix.substring(0, 4).toUpperCase();
  }

  String generateRandomCourseCode() {
    final random = Random();
    const chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!-_?.';
    String code = '';

    for (int i = 0; i < 6; i++) {
      code += chars[random.nextInt(chars.length)];
    }

    return code;
  }

  Future<bool> courseCodeExists(String courseCode) async {
    final docRef =
        _firebaseFirestore.collection('course_codes').doc(courseCode);

    final doc = await docRef.get();
    if (!doc.exists) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> joinCourse(
      String courseCode, List<Course> regCourses, String userUid) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firebaseFirestore
        .collection('course_codes')
        .doc(courseCode)
        .get();

    if (doc.exists && doc.data() != null && doc.data()!.isNotEmpty) {
      String courseId = doc.data()!['course_id'];

      DocumentSnapshot<Map<String, dynamic>> courseDocSnap =
          await _firebaseFirestore.collection('courses').doc(courseId).get();

      Course course = Course.fromCourseSnapshot(courseDocSnap);
      Course newCourse = course.copyWith(registerDate: DateTime.now());

      int number = 0;
      // Get last registered course
      if (regCourses.isNotEmpty) {
        String lastId = regCourses.last.id!;

        RegExp regex = RegExp(r'\d+$');
        Match? match = regex.firstMatch(lastId);

        if (match != null) {
          String numberString = match.group(0)!;
          number = int.parse(numberString);
        }
      }

      String newCourseName = 'course${(number + 1)}';

      if (regCourses.firstWhereOrNull((element) => element.id == course.id) ==
          null) {
        try {
          final documentReference =
              FirebaseFirestore.instance.collection('reg_courses').doc(userUid);
          await documentReference
              .update({newCourseName: newCourse.toRegCourseJson()});
        } catch (e) {
          print('Error al añadir el curso a registered_courses: $e');
        }
      } else {
        throw 'Already joined the course';
      }
    }
  }
}
