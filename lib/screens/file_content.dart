import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../data/file_helper.dart';
import '../data/shared_prefs.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'files.dart';
// import 'package:share/share.dart';

class FileScreen extends StatefulWidget {
  late Object file;
  FileScreen(this.file);

  @override
  _FileScreenState createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  int settingColor = 0xff1976D2;
  double fontSize = 16;
  late SPSettings settings;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late FileHelper helper;
  @override
  void initState() {
    settings = SPSettings();
    settings.init().then((_) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    helper = FileHelper();
    if (widget.file == 0) {
      titleController.text = 'New File';
      contentController.text = '';
    } else {
      titleController.text = basename((widget.file as File).path);
      helper
          .readFromFile(widget.file as File)
          .then((value) => contentController.text = value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: titleController,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
        backgroundColor: Color(settingColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              saveFile().then((value) => Share.shareFiles(
                  [(widget.file as File).path],
                  text: basename((widget.file as File).path)));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              controller: contentController,
              style: TextStyle(fontSize: fontSize),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        backgroundColor: Color(settingColor),
        onPressed: () {
          saveFile();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => FilesScreen()));
        },
      ),
    );
  }

  Future saveFile() async {
    helper.writeToFile(titleController.text, contentController.text);
  }
}
