import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final String lastname;
  final String address;
  final String city;
  final String zipCode;
  final String country;
  final String email;

  const User(
      {this.id,
      this.name = '',
      this.lastname = '',
      this.address = '',
      this.city = '',
      this.zipCode = '',
      this.country = '',
      this.email = ''});

  User copyWith({
    String? id,
    String? name,
    String? lastname,
    String? address,
    String? city,
    String? zipCode,
    String? country,
    String? email,
  }) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        lastname: lastname ?? this.lastname,
        address: address ?? this.address,
        city: city ?? this.city,
        zipCode: zipCode ?? this.zipCode,
        country: country ?? this.country,
        email: email ?? this.email);
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
