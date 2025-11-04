import 'package:hospital_management_system/data/repository.dart';
import 'package:hospital_management_system/domain/scheduler.dart';
import 'package:hospital_management_system/ui/console.dart';

void main(){

  Repository r=Repository("data.json");

  Scheduler scheduler=Scheduler();
  scheduler=r.readFromFile();

  AppointmentConsole console=AppointmentConsole(scheduler: scheduler);

  console.start();

  
  r.writeToFile(scheduler);
}
