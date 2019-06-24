import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

bool getConnectionStatus(ConnectivityResult connected){
  bool connection;
  switch(connected) {
    case ConnectivityResult.mobile:
    case  ConnectivityResult.wifi:
      connection = true;
      break;
    case ConnectivityResult.none:
    default:
      connection = false;
      break;
  }
  return connection;
}

buildConnectivityCheckBar(bool connection) {
  final text = connection ? buildText('Online', Colors.black) : buildText('Offline', Colors.white);
  return Container(
          color: connection ? Color(0xFF00EE44) : Color(0xFFEE4400),
          child: Center(
            child: text
      )
  );
}

buildText(String text, Color color) {
  return Text(text,
    style: TextStyle(fontStyle: FontStyle.italic, color: color, fontSize: 15.0),
  );
}





