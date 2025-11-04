import 'dart:io';

import 'package:hospital_management_system/domain/appointment.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/patient.dart';
import 'package:hospital_management_system/domain/scheduler.dart';

class AppointmentConsole{
  Scheduler scheduler;

  AppointmentConsole({required this.scheduler});

  void start(){

    String result='';

    while(true){

      print('\x1B[2J\x1B[0;0H');

      String? choice;
      print("=========================================");
      print("         HOSPITAL MANAGEMENT SYSTEM      ");
      print("            Appointment Module           ");
      print("=========================================");
      if (result.isNotEmpty) {
        print(result);
        result = '';
      }
      print("1. Doctor");
      print("2. Patient");
      print("3. Schedule Appointment");
      print("4. View Appointment");
      print("0. Exit");

      stdout.write('Enter Your Choice: ');
      choice = stdin.readLineSync();
      
      switch(choice){
        case "1":
          viewDoctor();
          break;
        case "2":
          viewPatient();
          break;
        case "3":
          result=addAppointment();
          break;
        case "4":
          viewAppointment();
          break;
        case "0":
         break;
        default:
         print("\nPlease select the ccorrect Option");
         break;
        
      }

      if(choice=="0"){
        print("Good Bye!");
        break;
      }

    }
  }

  void viewDoctor(){

    String result="";

    while(true){
      print('\x1B[2J\x1B[0;0H');

      if(result!=""){
        print(result);
      }

      print("\n\nThis is the list of the doctor");
      
      for (Doctor doctor in scheduler.doctors) {
        print("${doctor.id} Name:${doctor.name} Gender:${doctor.gender} DOB:${doctor.dob.toIso8601String().substring(0,10)} speciality:${doctor.specialty}");
      }

      print("\nEnter your Choice:");
      print("1. Add Doctor");
      print("0. Exit");

      stdout.write('Enter Choice: ');
      String? choice = stdin.readLineSync();
      switch(choice){
        case "1":

          stdout.write('Enter Name: ');
          String? name = stdin.readLineSync();
          stdout.write('Enter Gender(e.g Male): ');
          String? gender = stdin.readLineSync();
          stdout.write('Enter contactInfo: ');
          String? contactInfo = stdin.readLineSync();
          stdout.write('Enter Year (e.g., 2025): ');
          int? year = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter Month (1-12): ');
          int? month = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter Day (1-31): ');
          int? day = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter specialty: ');
          String? specialty = stdin.readLineSync();

          if (name == null || gender == null || specialty == null || year == null || month == null ||contactInfo==null || day == null) {
            result="Invalid input! Please try again.";
            break;
          }
          Doctor d=Doctor(name: name, gender: gender, dob: DateTime(year,month,day), contactInfo: contactInfo, specialty: specialty);
          scheduler.addDoctor(d);
          result="Doctor has been added";
          break;
        default:
          break;
      }

      if(choice=="0") break;

    }

  }

  void viewPatient(){

    String result="";

    while(true){

      if(result!=""){
        print(result);
      }
      print('\x1B[2J\x1B[0;0H');

      print("\n\nThis is the list of the Patient");

      for (Patient p in scheduler.patients) {
        print("${p.id} Name:${p.name} Gender:${p.gender} DOB:${p.dob.toIso8601String().substring(0,10)} ");
      }

      print("\nEnter your Choice:");
      print("1. Add Patient");
      print("0. Exit");

      stdout.write('Enter Choice: ');
      String? choice = stdin.readLineSync();
      switch(choice){
        case "1":

          stdout.write('Enter Name: ');
          String? name = stdin.readLineSync();
          stdout.write('Enter Gender(e.g Male): ');
          String? gender = stdin.readLineSync();
          stdout.write('Enter contactInfo: ');
          String? contactInfo = stdin.readLineSync();
          stdout.write('Enter Year (e.g., 2025): ');
          int? year = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter Month (1-12): ');
          int? month = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter Day (1-31): ');
          int? day = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter illnes: ');
          String? illnes = stdin.readLineSync();

          if (name == null || gender == null || illnes == null || year == null || month == null ||contactInfo==null || day == null) {
            result="Invalid input! Please try again.";
            break;
          }
          Patient p=Patient(name: name, gender: gender, dob: DateTime(year,month,day), contactInfo: contactInfo, illness: illnes);
          scheduler.addPatient(p);
          result="Patient has been added";
          break;
        default:
          break;
      }

      if(choice=="0") break;
    }

  }

  String addAppointment() {
    print('\x1B[2J\x1B[0;0H');
    print("\n\nPlease fill the information below");

    stdout.write('Enter DoctorId: ');
    String? dId = stdin.readLineSync();
    if (dId == null || dId.isEmpty || !scheduler.doctors.any((d) => d.id == dId)) {
      return "Invalid Doctor ID!";
    }

    stdout.write('Enter PatientId: ');
    String? pId = stdin.readLineSync();
    if (pId == null || pId.isEmpty || !scheduler.patients.any((p) => p.id == pId)) {
      return "Invalid Patient ID!";
    }

    stdout.write('Enter Year (e.g., 2025): ');
    int? year = int.tryParse(stdin.readLineSync() ?? '');
    stdout.write('Enter Month (1-12): ');
    int? month = int.tryParse(stdin.readLineSync() ?? '');
    stdout.write('Enter Day (1-31): ');
    int? day = int.tryParse(stdin.readLineSync() ?? '');
    stdout.write('Enter Hour (1-24): ');
    int? hour = int.tryParse(stdin.readLineSync() ?? '');
    stdout.write('Enter Minute (0-60): ');
    int? minute = int.tryParse(stdin.readLineSync() ?? '');

    if (year == null || month == null || day == null|| hour == null|| minute == null) {
      return "Invalid date input!";
    }

    DateTime appointmentTime;
    appointmentTime = DateTime(year, month, day,hour,minute);

    bool available = scheduler.checkAvailability(
      dId,
      appointmentTime,
    );

    if (!available) {
      return "Doctor is not available at this time.";
    }

    scheduler.scheduleAppointment(pId,dId,appointmentTime);

    return "Appointment scheduled successfully!";
  }


  void viewAppointment(){

    String result=' ';

    while(true){   
      print('\x1B[2J\x1B[0;0H'); 
      
      print(result);
      print("\n\nThis is the list of the Appointment\n");
      for (Appointment a in scheduler.appointments) {
        String formattedTime = "${a.time.year}-${a.time.month.toString().padLeft(2,'0')}-${a.time.day.toString().padLeft(2,'0')} "
                              "${a.time.hour.toString().padLeft(2,'0')}:${a.time.minute.toString().padLeft(2,'0')}";
        print("${a.id} Doctor:${a.doctorId} Patient:${a.patientId} Time:$formattedTime status:${a.status.toString().split('.').last}");
      }

      print("\n Choice:");
      print("1. Complete appointment");
      print("2. Cancel appointment");
      print("3. Reschedule appointment");
      print("0. Exit");
      stdout.write('Enter Choice: ');
      String? choice = stdin.readLineSync();

      switch(choice){
        case "1":
          stdout.write('Enter Id: ');
          String? aId = stdin.readLineSync();
          result= scheduler.completeAppointment(aId!);
          break;
        case "2":
          stdout.write('Enter Id: ');
          String? aId = stdin.readLineSync();
          result= scheduler.cancelAppointment(aId!);
          break;       
        case "3":

          stdout.write('Enter Id: ');
          String? aId = stdin.readLineSync();
          stdout.write('Enter Year (e.g., 2025): ');
          int? year = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter Month (1-12): ');
          int? month = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter Day (1-31): ');
          int? day = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter Hour (1-24): ');
          int? hour = int.tryParse(stdin.readLineSync() ?? '');
          stdout.write('Enter Minute (0-60): ');
          int? minute = int.tryParse(stdin.readLineSync() ?? '');

          if (year == null || month == null || day == null|| hour == null|| minute == null) {
            result= "Invalid date input!";
            break;
          }

          DateTime dt=DateTime(year,month,day,hour,minute);

          result=scheduler.reSchedule(aId!, dt);

          break;
      }
      if(choice=="0") break;
    }
  }

}