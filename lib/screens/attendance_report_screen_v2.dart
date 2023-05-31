// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/attendance_provider.dart';
// import '../widgets/custom_drawer.dart';
//
// class AttendanceReportScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: CustomDrawer(),
//
//       appBar: AppBar(
//         title: Text('Attendance Report'),
//       ),
//       body: Consumer<AttendanceProvider>(
//         builder: (context, attendanceProvider, child) {
//           return ListView.builder(
//             itemCount: attendanceProvider.attendanceList.length,
//             itemBuilder: (context, index) {
//               final attendance = attendanceProvider.attendanceList[index];
//               return ListTile(
//                 title: Text(attendance),
//                 subtitle: Text('Grade: ${attendance.grade}'),
//                 trailing: Text(attendance.absentDays.toString()),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
