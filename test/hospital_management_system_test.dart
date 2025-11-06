import 'package:test/test.dart';
import 'package:hospital_management_system/domain/doctor.dart';
import 'package:hospital_management_system/domain/patient.dart';
import 'package:hospital_management_system/domain/scheduler.dart';

void main() {
  group('Hospital Management System Tests', () {
    late Scheduler scheduler;
    late Doctor doctor;
    late Patient patient;

    setUp(() {
      scheduler = Scheduler();

      // create dr and p for test
      doctor = Doctor(
        name: 'Dr Ronan the best',
        gender: 'Male',
        dob: DateTime(1980, 5, 12),
        contactInfo: '0123456789',
        specialty: 'Cardiology',
      );
      patient = Patient(
        name: 'leab',
        gender: 'Male',
        dob: DateTime(1995, 7, 20),
        contactInfo: '0998765432',
        illness: 'Flu',
      );

      scheduler.addDoctor(doctor);
      scheduler.addPatient(patient);
    });

    test('TC01: Add doctor', () {
      expect(scheduler.doctors.contains(doctor), true);
    });

    test('TC02: Prevent empty doctor', () {
      final emptyDoc = Doctor(
        name: '',
        gender: 'Male',
        dob: DateTime(1990, 1, 1),
        contactInfo: '01234',
        specialty: 'Cardiology',
      );
      scheduler.addDoctor(emptyDoc);
      expect(scheduler.doctors.contains(emptyDoc), false);
    });

    test('TC03: Add patient', () {
      expect(scheduler.patients.contains(patient), true);
    });

    test('TC04: Prevent empty patient', () {
      final emptyPatient = Patient(
        name: '',
        gender: 'Female',
        dob: DateTime(1990, 2, 2),
        contactInfo: '011223344',
        illness: 'Cold',
      );
      scheduler.addPatient(emptyPatient);
      expect(scheduler.patients.contains(emptyPatient), false);
    });

    test('TC05: Schedule appointment valid', () {
      final result = scheduler.scheduleAppointment(
          patient.id, doctor.id, DateTime.now().add(Duration(hours: 1)));
      expect(result, 'Appointment scheduled successfully!');
    });

    test('TC06: Invalid doctor', () {
      final msg = scheduler.scheduleAppointment(
          patient.id, 'D999', DateTime.now().add(Duration(hours: 1)));
      expect(msg, 'Error: Doctor not found.');
    });

    test('TC07: Invalid patient', () {
      final msg = scheduler.scheduleAppointment(
          'P999', doctor.id, DateTime.now().add(Duration(hours: 1)));
      expect(msg, 'Error: Patient not found.');
    });

    test('TC08: Prevent overlapping', () {
      final t = DateTime.now().add(Duration(hours: 2));
      scheduler.scheduleAppointment(patient.id, doctor.id, t);
      expect(scheduler.checkAvailability(doctor.id, t), false);
    });

    test('TC09: Cancel appointment', () {
      final t = DateTime.now().add(Duration(hours: 3));
      scheduler.scheduleAppointment(patient.id, doctor.id, t);
      final id = scheduler.appointments.first.id;
      expect(scheduler.cancelAppointment(id), 'Cancel success');
    });

    test('TC10: Reschedule appointment', () {
      final t = DateTime.now().add(Duration(hours: 4));
      scheduler.scheduleAppointment(patient.id, doctor.id, t);
      final id = scheduler.appointments.first.id;
      final newTime = DateTime.now().add(Duration(hours: 5));
      expect(scheduler.reSchedule(id, newTime), 'Time has been schedule'); 
    });

    test('TC11: Complete appointment', () {
      final t = DateTime.now().add(Duration(hours: 6));
      scheduler.scheduleAppointment(patient.id, doctor.id, t);
      final id = scheduler.appointments.first.id;
      expect(scheduler.completeAppointment(id), 'complete success');
    });

    test('TC12: View appointments', () {
      final t = DateTime.now().add(Duration(hours: 7));
      scheduler.scheduleAppointment(patient.id, doctor.id, t);
      expect(scheduler.appointments.isNotEmpty, true);
    });

    test('TC13: Reschedule to past date fails', () {
      final t = DateTime.now().add(Duration(hours: 8));
      scheduler.scheduleAppointment(patient.id, doctor.id, t);
      final id = scheduler.appointments.first.id;
      final past = DateTime.now().subtract(Duration(days: 1));
      expect(scheduler.reSchedule(id, past),
          'Invalid date: must be after the current time.');
    });

    test('TC14: Multiple appointments for different doctors', () {
      final d2 = Doctor(
        name: 'Dr Thy',
        gender: 'Female',
        dob: DateTime(1985, 1, 1),
        contactInfo: '0123',
        specialty: 'Derm',
      );
      final p2 = Patient(
        name: 'thea',
        gender: 'Male',
        dob: DateTime(1990, 1, 1),
        contactInfo: '0222',
        illness: 'Cold',
      );
      scheduler.addDoctor(d2);
      scheduler.addPatient(p2);
      scheduler.scheduleAppointment(
          patient.id, doctor.id, DateTime.now().add(Duration(hours: 9)));
      scheduler.scheduleAppointment(
          p2.id, d2.id, DateTime.now().add(Duration(hours: 9)));
      expect(scheduler.appointments.length, 2);
    });

    test('TC15: Check availability', () {
      final t = DateTime.now().add(Duration(hours: 10));
      scheduler.scheduleAppointment(patient.id, doctor.id, t);
      expect(scheduler.checkAvailability(doctor.id, t), false);
    });
  });
}
