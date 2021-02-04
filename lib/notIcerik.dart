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
        child: Text(not.notIcerik,style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
  }
}
