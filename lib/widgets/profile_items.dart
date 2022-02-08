// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class ProfileHelpers with ChangeNotifier {
//   Widget headerProfile(BuildContext context, dynamic snapshot) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.2,
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         children: [
//           Container(
//             height: 200,
//             width: 180,
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: () {},
//                   child: CircleAvatar(
//                     backgroundColor: Colors.transparent,
//                     radius: 60,
//                     backgroundImage: snapshot.data != null
//                         ? NetworkImage(snapshot['userimage'])
//                         : NetworkImage(
//                             'https://i0.wp.com/www.camberpg.com/wp-content/uploads/2018/03/personicon.png'),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     snapshot.data['username'],
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.email,
//                         color: Colors.blue,
//                       ),
//                       Text(
//                         snapshot['username'],
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       height: 70,
//                       width: 80,
//                       child: Column(
//                         children: [
//                           Text(
//                             '0',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Text(
//                             'Takipçi',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       height: 70,
//                       width: 80,
//                       child: Column(
//                         children: [
//                           Text(
//                             '0',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Text(
//                             'Takip Edilen',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       height: 70,
//                       width: 80,
//                       child: Column(
//                         children: [
//                           Text(
//                             '0',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Text(
//                             'Gönderiler',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
