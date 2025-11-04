import 'dart:io';
import 'dart:convert';

import 'package:hospital_management_system/domain/scheduler.dart';

class Repository {

  final filePath;

  Repository(this.filePath);

  void writeToFile(Scheduler scheduler) {
    final file = File(filePath);
    final data = scheduler.toJson();
    file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(data));
  }

  Scheduler readFromFile() {
    final file = File(filePath);
    if (!file.existsSync()) return Scheduler();
    final content = file.readAsStringSync();
    final jsonData = jsonDecode(content);
    return Scheduler.fromJson(jsonData);
  }


}