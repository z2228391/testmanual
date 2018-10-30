import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatelessWidget {
  final shareWidget = new GlobalKey();

  Future<PDFDocument> _generateDocument() async{
    final pdf = new PDFDocument(deflate: zlib.encode);
    final page = new PDFPage(pdf, pageFormat: PDFPageFormat(216.0, 384.0));
    final g = page.getGraphics();
    final top = page.pageFormat.height;


    g.setColor(new PDFColor(0.0, 1.0, 1.0));


    var font = await rootBundle.load("assets/GenYoMinTW-Heavy.ttf");
    PDFTTFFont ttf = new PDFTTFFont(pdf, font);

    //PDFTTFFont ttf = new PDFTTFFont(pdf, (new File("assets/open-sans.ttf").readAsBytesSync() as Uint8List).buffer.asByteData());
    g.setColor(new PDFColor(0.3, 0.3, 0.3));

    //var encoded = utf8.encode("檯號： 1");
    g.drawString(ttf, 20.0, '\u4f60\u597d', 10.0 * PDFPageFormat.MM, top - 10.0 * PDFPageFormat.MM);



    return pdf;
  }

  void _printPdf() {
    print("Print ...");
//    final pdf = _generateDocument();
//    Printing.printPdf(document: pdf);

  _generateDocument().then((pdf) {
    Printing.printPdf(document: pdf);
  });

  }


  void _sharePdf() {
    print("Share ...");
    //final pdf = _generateDocument();

    // Calculate the widget center for iPad sharing popup position
    final RenderBox referenceBox =
    shareWidget.currentContext.findRenderObject();
    final topLeft =
    referenceBox.localToGlobal(referenceBox.paintBounds.topLeft);
    final bottomRight =
    referenceBox.localToGlobal(referenceBox.paintBounds.bottomRight);
    final bounds = new Rect.fromPoints(topLeft, bottomRight);

    _generateDocument().then((pdf) {
      Printing.sharePdf(document: pdf, bounds: bounds);
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Printing example'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new RaisedButton(
                child: new Text('Print Document'), onPressed: _printPdf),
            new RaisedButton(
                key: shareWidget,
                child: new Text('Share Document'),
                onPressed: _sharePdf),
          ],
        ),
      ),
    );
  }
}
