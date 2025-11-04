abstract class Person {
  
  String id;
  String name;
  String gender;
  String contactInfo;
  DateTime dob;

  Person({required this.id,required this.name,required this.gender,required this.dob,required this.contactInfo});

  Map<String,dynamic> toJson();
}
