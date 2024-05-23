// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart'; // Import this package
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Upload extends StatefulWidget {
//   const Upload({Key? key}) : super(key: key);

//   @override
//   State<Upload> createState() => _UploadState();
// }

// class _UploadState extends State<Upload> {
//   final supabase = Supabase.instance.client;

//   Future<String?> uploadPdf(String fileName, Uint8List fileBytes) async {
//     // Define the storage bucket and path
//     String bucketId = 'pdfs'; // Replace with your actual bucket ID
//     String filePath = 'uploadedpdfs/$fileName'; // Path in Supabase Storage to store the file

//     // Prepare the request
//     var uri = Uri.parse('https://isdokcvglocadrraktfe.supabase.co/$bucketId/$filePath');

//     var request = http.MultipartRequest('POST', uri)
//       ..headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzZG9rY3ZnbG9jYWRycmFrdGZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU4NjkxOTEsImV4cCI6MjAzMTQ0NTE5MX0.VfTbcxvvZtj8EZyF2Bdv5egJ_if2d495V-riwrFB2SI' // Replace with your Supabase API key
//       ..headers['apikey'] = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzZG9rY3ZnbG9jYWRycmFrdGZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU4NjkxOTEsImV4cCI6MjAzMTQ0NTE5MX0.VfTbcxvvZtj8EZyF2Bdv5egJ_if2d495V-riwrFB2SI' // Replace with your Supabase API key
//       ..headers['x-upsert'] = 'true' // Allow overwriting files with the same name
//       ..files.add(http.MultipartFile.fromBytes(
//         'file',
//         fileBytes,
//         filename: '$fileName.pdf',
//         contentType: MediaType('application', 'pdf'),
//       ));

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       // File uploaded successfully, return the download URL
//       return 'https://isdokcvglocadrraktfe.supabase.co/$bucketId/$filePath';
//     } else {
//       // File upload failed, print the error message
//       print('Failed to upload PDF file: ${response.statusCode}');
//       return null;
//     }
//   }

//   void pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       String fileName = result.files.first.name;
//       Uint8List fileBytes = result.files.first.bytes!;

//       // Upload file to Supabase Storage
//       final downloadLink = await uploadPdf(fileName, fileBytes);

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
