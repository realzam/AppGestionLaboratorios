import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PdfViewPage extends StatefulWidget {
  final String path;
  PdfViewPage({Key key, this.path}) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool pdfReady = false;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController _pdfViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte'),
        backgroundColor: Color.fromRGBO(1, 127, 255, 1.0),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages;
                pdfReady = true;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {
                _currentPage = page;
              });
              print('page change: $page/$total');
            },
          ),
          (!pdfReady)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  
                    GestureDetector(
                         
                          onTap: () {
                            _currentPage -= 1;
                            _pdfViewController.setPage(_currentPage);
                          },
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            child: (_currentPage > 0)?Icon(FontAwesomeIcons.chevronLeft,size: 30.0,color: Color.fromRGBO(1, 127, 255, 1.0),):Text(''),
                          ),
                        ),
                  Text('${_currentPage + 1}/$_totalPages'),
                  
                       GestureDetector(
                         
                          onTap: () {
                            _currentPage += 1;
                            _pdfViewController.setPage(_currentPage);
                          },
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            child: (_currentPage < _totalPages-1)?Icon(FontAwesomeIcons.chevronRight,size: 30.0,color: Color.fromRGBO(1, 127, 255, 1.0),):Text(''),
                          ),
                        )
                      
                ],
              ),
              SizedBox(height: 10.0)
            ],
          )
        ],
      ),
    );
  }
}
