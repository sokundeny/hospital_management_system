import 'package:hospital_management_system/domain/person.dart';

class Patient extends Person {
  static int _counter = 1;

  String? illness;

  Patient({
    String? id,
    required super.name,
    required super.gender,
    required super.dob,
    required super.contactInfo,
    required this.illness
  }) : super(
          id: id ?? 'P$_counter',
        ) {
    _counter++;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'contactInfo': contactInfo,
      'illness': illness,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    
    final numberPart = int.tryParse(id.substring(1)) ?? 0;

    if (numberPart >= _counter) {
      _counter = numberPart ;
    }

    return Patient(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      contactInfo: json['contactInfo'],
      illness: json['illness'],
    );
  }
}