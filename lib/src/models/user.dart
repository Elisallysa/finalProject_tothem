import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final String lastname;
  final String address;
  final String city;
  final String zipCode;
  final String country;
  final String email;
  final String role;
  final List<Course> courses;

  const User(
      {this.id,
      this.name = '',
      this.lastname = '',
      this.address = '',
      this.city = '',
      this.zipCode = '',
      this.country = '',
      this.email = '',
      this.role = '',
      this.courses = const <Course>[]});

  User copyWith({
    String? id,
    String? name,
    String? lastname,
    String? address,
    String? city,
    String? zipCode,
    String? country,
    String? email,
    String? role,
    List<Course>? courses,
  }) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        lastname: lastname ?? this.lastname,
        address: address ?? this.address,
        city: city ?? this.city,
        zipCode: zipCode ?? this.zipCode,
        country: country ?? this.country,
        email: email ?? this.email,
        role: role ?? this.role,
        courses: courses ?? this.courses);
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        courses:
            List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [name, lastname];

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
      name: snap['name'] ?? '',
      email: snap['email'] ?? '',
    );
    return user;
  }
}

/// Serializes a Json String to a List of User objects.
List<User> usuarioFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

/// Serializes a List of User objects into a Json String.
String usuarioToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
