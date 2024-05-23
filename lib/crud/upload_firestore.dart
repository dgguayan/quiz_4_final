// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class Upload extends StatefulWidget {
//   const Upload({Key? key}) : super(key: key);

//   @override
//   State<Upload> createState() => _UploadState();
// }

// class _UploadState extends State<Upload> {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   Future<String?> uploadPdf(String fileName, File file, {Uint8List? bytes}) async {
//     final reference = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
//     final uploadTask = bytes != null ? reference.putData(bytes) : reference.putFile(file);
//     await uploadTask.whenComplete(() {});
//     final downloadLink = await reference.getDownloadURL();
//     return downloadLink;
//   }

//   Future<String?> extractText(File file, {Uint8List? bytes}) async {
//     Uint8List pdfBytes = bytes ?? await file.readAsBytes();
//     final PdfDocument document = PdfDocument(inputBytes: pdfBytes);
//     final PdfTextExtractor extractor = PdfTextExtractor(document);
//     String text = extractor.extractText();
//     document.dispose(); // Dispose the document to free up resources

//     // Limit the extracted text to 700 words
//     List<String> words = text.split(RegExp(r'\s+'));
//     if (words.length > 700) {
//       text = words.sublist(0, 700).join(' ');
//     }

//     return text;
//   }

//   void pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       String fileName = result.files.first.name!;
//       PlatformFile platformFile = result.files.first;

//       // Get file bytes based on platform
//       Uint8List? fileBytes = platformFile.bytes;

//       String filePathForPdf = kIsWeb ? '' : platformFile.path!;

//       // Upload PDF to Firebase Storage
//       final downloadLink = await uploadPdf(fileName, File(filePathForPdf), bytes: fileBytes);

//       // Extract text from the PDF
//       String? extractedText = await extractText(File(filePathForPdf), bytes: fileBytes);

//       // Store PDF metadata and extracted text in Firestore
//       _firebaseFirestore.collection("pdfs").add({
//         "name": fileName,
//         "url": downloadLink,
//         "text": extractedText, // Assuming you want to store the extracted text as a single field
//       }).then((docRef) {
//         print("PDF uploaded and text extracted successfully.");
//       }).catchError((error) {
//         print("Error adding PDF to Firestore: $error");
//       });
//     } else {
//       // Handle the case where no file was picked
//       print("No file picked.");
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
