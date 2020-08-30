import 'dart:async';
import 'package:get/get.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/appcontroller.dart';

class FurniturescanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    var _getText = (text) {
      if (text != "") {
        return "READ: " + text;
      } else {
        return "";
      }
    };

    final scanButton = RaisedButton(
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {
        _scan(ctx);
      },
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      color: Theme.of(ctx).primaryColor,
      child: Text(
        "Scan Code",
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Scansione'),
        ),
        body: Center(
          child: new Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: GetBuilder<AppController>(
                    builder: (_) {
                      return Text(
                        _getText(_.getFilter()),
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: scanButton,
                padding: const EdgeInsets.all(24.0),
              ),
            ],
          ),
        ));
  }

  Future _scan(mycontext) async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      String rawContent = barcode.rawContent;
      print("**********************>>>>>>>>>>>${rawContent}");
      AppController.to.setFilter(rawContent);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        Get.snackbar(
          'Errore',
          'L\'utente non ha fornito i permessi per accedere alla fotocamera.',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Errore',
          'Errore sconosciuto $e',
          snackPosition: SnackPosition.TOP,
        );
      }
    } on FormatException {
      Get.snackbar(
        'Errore',
        'l\'utente ha premuto il pulsante indietro prima di aver effettuato una scansione)',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print("Errore sconosciuto.... $e");
      Get.snackbar(
        'Errore',
        'Errore sconosciuto $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}