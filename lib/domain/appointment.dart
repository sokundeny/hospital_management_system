enum AppointmentStatus {
  scheduled,
  completed,
  cancelled
  }

class Appointment {
  static int _counter = 1;

  String id;
  DateTime time;
  String doctorId;
  String patientId;
  AppointmentStatus status;

  Appointment({
    String? id,
    required this.doctorId,
    required this.patientId,
    required this.time,
  })  : id = id ?? 'A${_counter++}',
        status = AppointmentStatus.scheduled;

  void reSchedule(DateTime newTime){
    time=newTime;
  }

  void cancel(){
    status=AppointmentStatus.cancelled;
  }

  void complete(){
    status=AppointmentStatus.completed;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'time': time.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;

    final numberPart = int.tryParse(id.substring(1)) ?? 0;

    if (numberPart >= _counter) {
      _counter = numberPart +1;
    }

    return Appointment(
      id: json['id'],
      doctorId: json['doctorId'],
      patientId: json['patientId'],
      time: DateTime.parse(json['time']),
    )..status = AppointmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      );
  }

}