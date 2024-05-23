import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListPDF extends StatefulWidget {
  const ListPDF({super.key});

  @override
  State<ListPDF> createState() => _ListViewState();
}

class _ListViewState extends State<ListPDF> {
  final FlutterTts flutterTts = FlutterTts();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  List<QueryDocumentSnapshot> pdfDocs = [];

  @override
  void initState() {
    super.initState();
    getAllPdf();
  }

  void getAllPdf() async {
    try {
      final results = await _firebaseFirestore.collection("pdfs").get();
      debugPrint('Fetched PDFs: ${results.docs.length}');
      setState(() {
        pdfDocs = results.docs;
      });
    } catch (e) {
      debugPrint('Error fetching PDFs: $e');
    }
  }

  void deletePdf(String id) async {
    try {
      await _firebaseFirestore.collection("pdfs").doc(id).delete();
      getAllPdf();
    } catch (e) {
      debugPrint('Error deleting PDF: $e');
    }
  }

  Future<void> updatePdf(String id, String newName, String? newUrl) async {
    try {
      Map<String, dynamic> updatedData = {'name': newName};
      if (newUrl != null) {
        updatedData['url'] = newUrl;
      }
      await _firebaseFirestore.collection("pdfs").doc(id).update(updatedData);
      getAllPdf();
    } catch (e) {
      debugPrint('Error updating PDF: $e');
    }
  }

  Future<void> showUpdateDialog(BuildContext context, String id, String currentName, String currentUrl) async {
    TextEditingController nameController = TextEditingController(text: currentName);
    String? newUrl;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update PDF'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'New Name'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );

                  if (result != null) {
                    PlatformFile file = result.files.first;
                    Uint8List? fileBytes;

                    if (file.bytes != null) {
                      fileBytes = file.bytes!;
                    } else if (file.path != null) {
                      fileBytes = await File(file.path!).readAsBytes();
                    }

                    if (fileBytes != null) {
                      String fileName = basename(file.name);
                      UploadTask uploadTask = _firebaseStorage
                          .ref('pdfs/$fileName')
                          .putData(fileBytes);

                      TaskSnapshot taskSnapshot = await uploadTask;
                      newUrl = await taskSnapshot.ref.getDownloadURL();
                    }
                  }
                },
                child: Text('Select New PDF'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                updatePdf(id, nameController.text, newUrl);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List of all PDF",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        itemCount: pdfDocs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          final pdfData = pdfDocs[index].data() as Map<String, dynamic>;
          final pdfId = pdfDocs[index].id;

          return Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PDFViewerScreen(pdfUrl: pdfData['url']),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset("assets/pdf.png"),
                        ),
                      ),
                    Text(
                      pdfData['name'],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            deletePdf(pdfId);
                          },
                          child: Icon(
                            Icons.delete,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showUpdateDialog(context, pdfId, pdfData['name'], pdfData['url']);
                          },
                          child: Icon(
                            Icons.edit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PDFViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
  

  Future<String?> readPdfText(String pdfUrl, int pageNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pdfs')
          .where('url', isEqualTo: pdfUrl)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> pdfData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String name = pdfData['text'];
        return '$name $pageNumber';
      } else {
        return null;
      }
    } catch (e) {
      print('Error reading document: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDF Viewer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.network(widget.pdfUrl),
          ),
          ElevatedButton(
            onPressed: () async {
              String? text = await readPdfText(widget.pdfUrl, 1); 
              if (text != null) {
                _speak(text); 
              }
            },
            child: Text('Read Aloud'),
          ),
        ],
      ),
    );
  }
}
