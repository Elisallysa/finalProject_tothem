import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Stream<List<Course>> getTeacherCourses(String mail) {
    String userMail = mail.substring(0, mail.indexOf('@'));

    return _firebaseFirestore
        .collection('courses')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: userMail)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList());
  }

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
  Future<void> createCourse(Course course, User user) async {
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
    String idSuffix = _getCourseCodeSuffix(course.title, course.category);

    final today = DateTime.now();

    String month =
        today.month < 10 ? '0${today.month}' : today.month.toString();
    String day = today.day < 10 ? '0${today.day}' : today.day.toString();

    String strDate = today.year.toString() + month + day;

    return _firebaseFirestore
        .collection("courses")
        .doc(user.email!.substring(0, user.email!.indexOf('@')) +
            strDate +
            idSuffix)
        .set(course.toJson())
        .onError((e, _) => print("Error writing document: $e"));
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
}
