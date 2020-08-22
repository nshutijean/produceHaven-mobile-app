import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

// class RegexValidation {
//   String urlRegex = "";
// }

class _ScanState extends State<Scan> {
  // initial result whic will be changed as the code updates from the scanner
  String scanResult = "Not yet scanned";

  //my url regex
  // RegexValidation _regexValidation = new RegexValidation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "RESULT",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // Text(
            //   scanResult,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 18.0),
            // ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 30.0,
              child: Material(
                child: GestureDetector(
                  child: Center(
                    child: Text(
                      scanResult,
                      style: TextStyle(color: Colors.blue, fontSize: 18.0),
                    ),
                  ),
                  onTap: () async {
                    //onTap the scanned result will be redirected to its actual web
                    if (scanResult.contains("http")) {
                      await FlutterWebBrowser.openWebPage(
                          url: scanResult,
                          androidToolbarColor: Colors.deepPurple);
                    } else {
                      scanResult = "Should be a valid URL!";
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              child: Text("Scan QR code"),
              onPressed: () async {
                // Scan functions will go here
                String scanning = await BarcodeScanner.scan();
                setState(() {
                  // change the url to produce-haven.herokuapp.com later
                  if (scanning.contains("http://en.m.wikipedia.org")) {
                    scanResult = scanning;
                  } else {
                    scanResult = "Invalid URL!";
                  }
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.green, width: 3.0)),
            )
          ],
        ),
      ),
    );
  }
}
