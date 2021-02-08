import 'package:flutter/material.dart';
import 'package:flutter_odev/utils/databaseHelper.dart';

import 'models/Notlar.dart';

class NotIcerik extends StatefulWidget {
  Notlar notId;
  NotIcerik({this.notId});
  @override
  _NotIcerikState createState() => _NotIcerikState();
}

class _NotIcerikState extends State<NotIcerik> {
  Notlar not;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notId != null) {
      not = widget.notId;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Not Icerik"),
      ),
      body: Container(
        width:MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blueGrey,
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(not.notIcerik,style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,fontFamily: "Icerik"
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
