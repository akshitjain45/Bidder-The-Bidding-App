import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

class CheckInternet extends StatefulWidget {
  @override
  _CheckInternetState createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {
  bool isOnline = true;

  check() async {
    if (await DataConnectionChecker().hasConnection) {
      isOnline = true;
    } else {
      isOnline = false;
    }
    if (this.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: check() as Future<Object>,
      builder: (context, snapshot) => Visibility(
        visible: !isOnline,
        child: Container(
          height: 40,
          color: Colors.black,
          child: Center(
            child: Text(
              "No Internet!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
