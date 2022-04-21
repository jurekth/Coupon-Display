import 'dart:convert';
import 'dart:io';

import 'package:coupon_display/pages/details.dart';
import 'package:coupon_display/utils/constants.dart';
import 'package:coupon_display/utils/util.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_store/json_store.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = [];

  JsonStore jsonStore = JsonStore();

  Future<http.Response> fetchData() {
    return http.get(Uri.parse(
        'https://raw.githubusercontent.com/jurekth/de_burgerking_coupons/main/data.json'));
  }

  Future<void> readData() async {
    Map<String, dynamic> data = new Map<String, dynamic>();

    bool isConnected = await hasNetwork();
    print(isConnected);

    if (isConnected) {
      http.Response webResponse = await fetchData();
      if (webResponse.statusCode == 200) {
        String body = webResponse.body;
        print(body);
        data = json.decode(body);
        jsonStore.setItem("saved", data);
      }
    } else {
      stderr.writeln("no connection");
      data = await jsonStore.getItem("saved");
    }

    setState(() {
      _items = data["items"];
    });
  }

  void showDetails(dynamic item) {
    Navigator.push(
        context,
        //MaterialPageRoute(builder: (context) => DetailsPage(item: item)));
        PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return DetailsPage(item: item);
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero));
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Coupon Display"),
          backgroundColor: Constants.primaryColor,
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: RefreshIndicator(
                onRefresh: () async {
                  await readData();
                },
                child: Column(
                  children: [
                    _items.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: _items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    color: Constants.greyColor,
                                    child: InkWell(
                                        onTap: () {
                                          if (_items[index]["header"] == "1")
                                            return;
                                          showDetails(_items[index]);
                                        },
                                        child: _items[index]["header"] == "1"
                                            ? ListTile(
                                                title: Text(
                                                    _items[index]["title"],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        decoration:
                                                            TextDecoration
                                                                .underline)),
                                                leading: const Icon(Icons.info),
                                                tileColor: const Color.fromARGB(
                                                    1, 136, 136, 136),
                                              )
                                            : ListTile(
                                                leading: (_items[index]["real"]
                                                            .toString() ==
                                                        "1"
                                                    ? const Icon(Icons
                                                        .check_circle_outline_rounded)
                                                    : const Icon(Icons.close)),
                                                title:
                                                    Text(_items[index]["name"]),
                                                subtitle: Text(_items[index]
                                                    ["description"]),
                                                trailing: Text(_items[index]
                                                        ["price"] +
                                                    ""))));
                              },
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ],
                ))));
  }
}
