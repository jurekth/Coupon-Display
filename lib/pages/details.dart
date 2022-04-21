import 'package:coupon_display/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.item}) : super(key: key);

  dynamic item;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.item["name"]),
          backgroundColor: Constants.primaryColor,
        ),
        body: Center(
          child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.item["id"], style: const TextStyle(fontSize: 32)),
                  const Text(""),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(widget.item["description"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                  ),
                  const Text(""),
                  QrImage(
                    data: widget.item["id"],
                    version: QrVersions.auto,
                    size: 240.0,
                  ),
                ],
              )),
        ));
  }
}
