import 'package:hospital_management_system/domain/person.dart';

class Doctor extends Person{

  static int _counter = 1;

  String specialty;

  Doctor({
    String? id,
    required super.name,
    required super.gender,
    required super.dob,
    required super.contactInfo,
    required this.specialty,
  }) : super(
          id: id ?? 'D$_counter',
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
      'specialty': specialty,
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    
    final numberPart = int.tryParse(id.substring(1)) ?? 0;

    if (numberPart >= _counter) {
      _counter = numberPart ;
    }
    return Doctor(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      contactInfo: json['contactInfo'],
      specialty: json['specialty'],
    );
  }

}