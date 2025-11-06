import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/patient.dart';

class Scheduler {

  List<Doctor> doctors=[];
  List<Patient> patients=[];
  List<Appointment> appointments=[];

  Scheduler();

  String scheduleAppointment(String patientId,String doctorId,DateTime time){
    if (time.month < 1 || time.month > 12) {
      return "Invalid month: must be between 1 and 12.";
    }

    if (time.day < 1 || time.day > 31) {
      return "Invalid day: must be between 1 and 31.";
    }

    DateTime now = DateTime.now();
    if (!time.isAfter(now)) {
      return "Invalid date: must be after the current time.";
    }
    Appointment newAppointment=Appointment(doctorId: doctorId, patientId: patientId, time: time);
    appointments.add(newAppointment);

    return "Appointment scheduled successfully!";
  }

  String cancelAppointment(String appointmentId){

    Appointment? a;
    try {
      a = appointments.firstWhere((a) => a.id == appointmentId);
    } catch (e) {
      a = null;
    }

    if(a==null){
      return "Id not found";
    }
    a.cancel();
    return "Cancel success";
  }

  String completeAppointment(String appointmentId){
    Appointment? a;
    try {
      a = appointments.firstWhere((a) => a.id == appointmentId);
    } catch (e) {
      a = null;
    }

    if(a==null){
      return "Id not found";
    }
    a.complete();
    return "complete success";
  }

  void addDoctor(Doctor doctor){
    doctors.add(doctor);
  }

  void addPatient(Patient patient){
    patients.add(patient);
  }

  bool checkAvailability(String doctorId, DateTime dateTime) {
    for (var appointment in appointments) {
      if (appointment.doctorId == doctorId &&
          appointment.status == AppointmentStatus.scheduled &&
          appointment.time.year == dateTime.year &&
          appointment.time.month == dateTime.month &&
          appointment.time.day == dateTime.day &&
          appointment.time.hour == dateTime.hour
      ) {
        return false;
      }
    }
    return true;
  }

  String reSchedule(String appointmentId,DateTime dateTime){
    Appointment? appointment;
    for(Appointment a in appointments){
      if(a.id==appointmentId){
        appointment=a;
      }
    }

    if (appointment == null) {
      return "Appointment not found!";
    }

    if (dateTime.month < 1 || dateTime.month > 12) {
      return "Invalid month: must be between 1 and 12.";
    }

    if (dateTime.day < 1 || dateTime.day > 31) {
      return "Invalid day: must be between 1 and 31.";
    }

    DateTime now = DateTime.now();
    if (!dateTime.isAfter(now)) {
      return "Invalid date: must be after the current time.";
    }

    if(!checkAvailability(appointment.doctorId, dateTime)){
      return "Doctor is not available this time";
    }
    appointment.reSchedule(dateTime);
    return "Time has been schedule";
  }

  Map<String, dynamic> toJson() {
    return {
      'doctors': doctors.map((d) => d.toJson()).toList(),
      'patients': patients.map((p) => p.toJson()).toList(),
      'appointments': appointments.map((a) => a.toJson()).toList(),
    };
  }

  factory Scheduler.fromJson(Map<String, dynamic> json) {
    Scheduler s = Scheduler();
    s.doctors = (json['doctors'] as List)
        .map((d) => Doctor.fromJson(Map<String, dynamic>.from(d)))
        .toList();
    s.patients = (json['patients'] as List)
        .map((p) => Patient.fromJson(Map<String, dynamic>.from(p)))
        .toList();
    s.appointments = (json['appointments'] as List)
        .map((a) => Appointment.fromJson(Map<String, dynamic>.from(a)))
        .toList();
    return s;
  }


}