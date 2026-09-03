// // lib/services/alarm_plus_service.dart
// import 'package:alarm_plus/alarm_plus.dart' as alarm;
// import 'package:permission_handler/permission_handler.dart';
//  import 'package:permission_handler/permission_handler.dart' as permission;

// class AlarmPlusService {
//  static Future<void> scheduleAlarm({
//   required int id,
//   required String title,
//   required String body,
//   required DateTime scheduledTime,
// }) async {
//   try {
//     var hasPermission = await Permission.scheduleExactAlarm.isGranted;

//     if (!hasPermission) {
// final status = await alarm.AlarmPlus.requestPermissions();

// if (!status.exactAlarmsGranted) {
//   print("Exact Alarm permission denied");
//   return;
// }
      
//     }

//     await alarm.AlarmPlus.cancel(id.toString());

//     print("================================");
//     print("Scheduling Alarm");
//     print("ID      : $id");
//     print("NOW     : ${DateTime.now()}");
//     print("TIME    : $scheduledTime");
//     print("================================");

//     await alarm.AlarmPlus.schedule(
//       id: id.toString(),
//       time: scheduledTime,
//       data: {
//         'title': title,
//         'body': body,
//         'source': 'health_app',
//       },
//       notificationSettings: alarm.AlarmNotificationSettings(
//         title: title,
//         body: body,
//         stopButtonText: 'إيقاف',
//         snoozeButtonText: 'غفوة',
//         volumeSettings: const alarm.VolumeSettings(
//           volume: 1,
//           volumeEnforced: true,
//           fadeDuration: Duration.zero,
//         ),
//         vibrationSettings: const alarm.VibrationSettings(
//   enabled: true,
//   preset: alarm.VibrationPreset.medium,
// )
//       ),
//     );
// final alarms = await alarm.AlarmPlus.getAll();

// print("=========== ALARMS ===========");
// print("Count = ${alarms.length}");

// for (final a in alarms) {
//   print(a);
// }
   
//   } catch (e, s) {
//     print(e); 
//     print(s);
//   }
// }
//   static Future<void> cancelAlarm(int id) async {
//     await alarm.AlarmPlus.cancel(id.toString());
//     print('✅ Alarm $id cancelled');
//   }

//   static Future<void> cancelAllAlarms() async {
//     try {
//       final alarms = await alarm.AlarmPlus.getAll();

// print("Stored alarms: ${alarms.length}");
//       print('✅ All alarms cancelled (${alarms.length} alarms)');
//     } catch (e) {
//       print('❌ Error cancelling all alarms: $e');
//     }
//   }

//   static Future<void> deleteAlarm(int id) async {
//     await alarm.AlarmPlus.delete(id.toString());
//     print('✅ Alarm $id deleted');
//   }

//   static Future<bool> checkPermission() async {
//     final status = await alarm.AlarmPlus.getPermissionStatus();
//     return status.exactAlarmsGranted && status.notificationsGranted;
//   }


// static Future<void> openSettings() async {
//   await permission.openAppSettings();
// }
// }