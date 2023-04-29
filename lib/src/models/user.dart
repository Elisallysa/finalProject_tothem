import 'dart:convert';

import 'course.dart';

class User {
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
      this.courses = const []});

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
}

// Método de serialización de string de json a lista de Usuario
List<User> usuarioFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

// Método de serialización de lista de Usuario a cadena de caracteres
String usuarioToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
