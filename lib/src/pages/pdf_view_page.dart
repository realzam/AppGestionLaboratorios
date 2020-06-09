import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfViewPage extends StatefulWidget {
  final PDFDocument document;
  PdfViewPage({Key key, this.document}) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reporte'),
          backgroundColor: Color.fromRGBO(1, 127, 255, 1.0),
        ),
        body: Center(
          child: (_isLoading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : PDFViewer(
                
                  document: widget.document,
                  showPicker: true,
                ),
        ));
  }
}
