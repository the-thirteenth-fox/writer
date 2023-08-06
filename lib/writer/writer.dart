import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class Writer extends StatelessWidget {
  const Writer({super.key});

  @override
  Widget build(BuildContext context) {
    final quillController = quill.QuillController.basic();
    ScrollController scrollController = ScrollController();

    void showInfo(String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Writer'), actions: [
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                    text: jsonEncode(
                        quillController.document.toDelta().toJson())));

                showInfo('Coped raw');
              },
              icon: const Icon(Icons.code)),
          IconButton(
              onPressed: () async {
                final data = await Clipboard.getData('text/plain');

                List<dynamic> decodedJson = [];
                try {
                  decodedJson = jsonDecode(data?.text ?? '');
                } on FormatException {
                  decodedJson = [
                    {"insert": '\n'}
                  ];
                }

                quillController.document = quill.Document.fromJson(decodedJson);

                showInfo('Pasted raw');

                print(decodedJson);
              },
              icon: const Icon(Icons.content_paste_go)),
          IconButton(
              onPressed: () {
                quillController.clear();

                showInfo('Cleared');
              },
              icon: const Icon(Icons.clear)),
        ]),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 13, right: 13, top: 13, bottom: 50),
                child: quill.QuillEditor(
                  placeholder: 'Write article:',
                  controller: quillController,
                  autoFocus: true,
                  readOnly: false,
                  scrollController: scrollController,
                  scrollBottomInset: 35,
                  scrollable: false,
                  focusNode: FocusNode(),
                  expands: false,
                  padding: EdgeInsets.zero,
                  detectWordBoundary: false,
                  enableUnfocusOnTapOutside: false,
                  contentInsertionConfiguration:
                      ContentInsertionConfiguration(onContentInserted: (value) {
                    print(value.mimeType);
                    // if(value.mimeType )
                  }),
                  keyboardAppearance: Theme.of(context).brightness,
                  // onImagePaste: (imageBytes) {
                  //   File file = File.fromRawPath(imageBytes);
                  //   return FileSaver().upload(file);
                  // },
                  embedBuilders: FlutterQuillEmbeds.builders(),
                  enableInteractiveSelection: true,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: 32,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).canvasColor,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: quill.QuillToolbar.basic(
                      controller: quillController,
                      showCodeBlock: false,
                      showAlignmentButtons: true,
                      showFontSize: false,
                      showFontFamily: true,
                      showSearchButton: true,
                      showSubscript: false,
                      showSuperscript: true,
                      showIndent: false,
                      embedButtons: FlutterQuillEmbeds.buttons(
                          // onImagePickCallback: (file) => FileSaver().upload(file),
                          // webImagePickImpl: webImagePickImpl,
                          ),
                    )),
              ),
            )
          ],
        ));
  }
}
