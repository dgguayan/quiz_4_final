// import 'dart:io';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Upload extends StatefulWidget {
//   const Upload({Key? key}) : super(key: key);

//   @override
//   State<Upload> createState() => _UploadState();
// }

// class _UploadState extends State<Upload> {
//   final supabase = Supabase.instance.client;

//   Future<String?> uploadFile(String fileName, Uint8List fileBytes) async {
//     // No authentication or session checks, proceed with the upload logic

//     final response = await http.post(
//       Uri.parse('https://isdokcvglocadrraktfe.supabase.co/storage/v1/s3/$fileName'),
//       headers: {
//         'Content-Type': 'application/octet-stream',
//         // You may need to add other headers if required by Supabase
//       },
//       body: fileBytes,
//     );

//     if (response.statusCode == 200) {
//       return 'https://isdokcvglocadrraktfe.supabase.co/storage/v1/s3/$fileName';
//     } else {
//       print('Failed to upload file: ${response.reasonPhrase}');
//       return null;
//     }
//   }

//   void pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       String fileName = result.files.first.name!;
//       PlatformFile platformFile = result.files.first;
//       Uint8List fileBytes = platformFile.bytes!;

//       // Upload file to Supabase Storage
//       String? downloadLink = await uploadFile(fileName, fileBytes);

//       if (downloadLink != null) {
//         print('File uploaded successfully. Download link: $downloadLink');
//       } else {
//         print('Failed to upload file.');
//       }
//     } else {
//       print('No file picked.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Upload PDF"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: pickFile,
//               child: Text("Pick PDF File"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
