import 'package:flutter/material.dart';
import 'package:agronom/pages/messages.dart';
import 'package:agronom/pages/message_create.dart';

void main() => runApp(MessageApp());

class MessageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agronom app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MessageHomePage(title: 'Agronom app'),
    );
  }
}

class MessageHomePage extends StatefulWidget {
  MessageHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MessageHomePageState createState() => _MessageHomePageState();
}

class _MessageHomePageState extends State<MessageHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Messages',
            ),
            RaisedButton(
              onPressed: () {
                print('messages open');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {  return MessagesListPage(pageTitle: 'Messages list'); },
                  ),
                );
              },
              child: Text('Messages'),
            ),
            RaisedButton(
              onPressed: () {
                print('messages open');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) { return MessagesCreatePage(pageTitle: 'Message create'); },
                  ),
                );
              },
             child: Text('Send Message'),
           ),
        ],
      ),
     )
    );
  }
}
