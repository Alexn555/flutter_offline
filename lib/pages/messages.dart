import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agronom/models/message_model.dart';
import 'package:agronom/providers/message_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:agronom/widgets/connectivity.dart';
import 'package:agronom/env.dart';

class MessagesListPage extends StatefulWidget {
  final String pageTitle;

  MessagesListPage({
    Key key,
    @required this.pageTitle,
  })  : assert(pageTitle != null),
        super(key: key);

  @override
  State<MessagesListPage> createState() =>
      _MessagesListState(this.pageTitle);
}

class _MessagesListState extends State<MessagesListPage> {
  String pageTitle;
  String messageContent;
  var subscription;
  var connectionStatus;

  _MessagesListState(String pageTitle) {
    this.pageTitle = pageTitle;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      messageContent = '';
    });
    _checkConnectivity();
  }

  _checkConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connected) async {
      bool connection = getConnectionStatus(connected);
      setState(() {
        connectionStatus = connection;
      });
      await _getSavedMessage();
      // re-send request as soon as internet restores
      if (connectionStatus) {
        print(' ---> reset request');
        _fetchData();
      }
    });
  }

  _getSavedMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String messageFromStorage = prefs.getString('list_message');
    setState(() {
      messageContent = '';
    });
    if (messageFromStorage != '') {
      setState(() {
        messageContent = messageFromStorage;
      });
      return messageFromStorage;
    }
    return '';
  }

  _saveMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('list_message', message);
    setState(() {
      messageContent = message;
    });
  }

  _fetchData() async{
    final MessageProvider _messageProvider = MessageProvider();
    final url = '$API/5e2a0153-8da3-4382-a34d-d7e24ae0f109';
    final message = await _messageProvider.fetchMessage(url);
    _saveMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: buildMessageList(context)
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  Widget buildMessageList(BuildContext context) {
    final messageContainer = messageContent != '' && messageContent != null ?
              buildTextRow(messageContent) : buildErrorContainer();
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        buildButtonGetMessage(),
        SizedBox(height: 12.0),
        buildConnectivityCheckBar(connectionStatus),
        buildTextRow(' ------ Message list ------ '),
        messageContainer
      ],
    );
  }

  Widget buildErrorContainer() {
    return Text(
      'No message found',
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
        letterSpacing: 0.5,
        fontSize: 17,
      ),
    );
  }

  Widget buildTextRow(String text) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              text,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  buildButtonGetMessage() {
    return  RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Text('Get messages'),
      textColor: Colors.white,
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(20.0),
      ),
      onPressed: () {
        _fetchData();
      },
    );
  }

}
