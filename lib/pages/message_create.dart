import 'package:flutter/material.dart';
import 'package:agronom/models/message_model.dart';
import 'package:agronom/providers/message_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:agronom/widgets/connectivity.dart';

class MessagesCreatePage extends StatefulWidget {
  final String pageTitle;

  MessagesCreatePage({
    Key key,
    @required this.pageTitle,
  })  : assert(pageTitle != null),
        super(key: key);

  @override
  State<MessagesCreatePage> createState() =>
      _MessageCreateState(this.pageTitle);
}

class _MessageCreateState extends State<MessagesCreatePage> {
  String pageTitle;
  final messageTextController = TextEditingController();
  bool isResendAllowed = false; //only after page loads
  var savedMessage;
  var response;
  var subscription;
  var connectionStatus;

  _MessageCreateState(String pageTitle) {
    this.pageTitle = pageTitle;
  }

  @override
  void initState() {
    super.initState();
    _emptyResponse();
    _checkConnectivity();
    isResendAllowed = true;
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  _checkConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connected) async {
      bool connection = getConnectionStatus(connected);
      setState(() {
        connectionStatus = connection;
      });
      final messageFromStorage = await _getSavedMessage();
      if(connectionStatus && isResendAllowed) {
        if (messageFromStorage != '') {
          print(' ---> resend message $messageFromStorage');
          _sendMessage(messageFromStorage);
        }
      }
    });
  }

  _getSavedMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String messageFromStorage = prefs.getString('message');
    setState(() {
      savedMessage = '';
    });
    if (messageFromStorage != '') {
      setState(() {
        savedMessage = messageFromStorage;
      });
      return messageFromStorage;
    }
    return '';
  }

  _saveMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('message', message);
    setState(() {
      savedMessage = message;
    });
  }

  _emptyResponse(){
    setState(() {
      response = null;
    });
  }


  _sendMessage(String message) async {
    final MessageProvider _messageProvider = MessageProvider();
    _saveMessage(message);
    _emptyResponse();
    try {
      final received = await _messageProvider.sendMessage(content: message);
      if (received != null && received['status'] != 'fail') {
        setState(() {
          response = received['data'];
        });
        //cancel saving message since request passed
        _saveMessage('');
      }
    } catch (error) {
       print(' ---> error send message $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: buildMessageCreateForm(context)
      ),
    );
  }

  Widget buildMessageCreateForm(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        buildTextRow('Message create'),
        TextField(
            controller: messageTextController,
            decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Please enter the message'
          ),
        ),
        buildSendMessageButton(context),
        SizedBox(height: 20.0),
        buildConnectivityCheckBar(connectionStatus),
        buildSavedMessageContainer(),
        SizedBox(height: 10),
        buildTextRow(' ----- Response from server ----- '),
        buildResponseText(context, response),
      ],
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

  Widget buildSavedMessageContainer() {
    if (savedMessage != '' && savedMessage != null) {
      return Column(
        children: <Widget>[
          Text('Saved message',
            style: TextStyle(color: Colors.black),),
          Text('" $savedMessage "',
            style: TextStyle(
              color: Colors.green,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.wavy,
            )),
            Text('that will be resend when internet On',
                style: TextStyle(color: Colors.black),
              ),
          ],
        );
    }
    return Container();
  }

  Widget buildRichText(BuildContext context, String label, String value) {
    return
      Align(
        alignment: Alignment.centerLeft, child: RichText(
          text: TextSpan(
            text: '$label ',
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: value,
                style: TextStyle(
                  color: Colors.green,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.wavy,
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget buildResponseText(context, response) {
    if (response == null) {
      return Container();
    }
    return Column(
      children: <Widget>[
        buildRichText(context, 'link', response.messageLink),
        buildRichText(context, 'message', response.content),
        buildRichText(context, 'date created', response.dateCreated),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget buildSendMessageButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Text('Send message'),
        textColor: Colors.white,
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        onPressed: () {
          final message = messageTextController.text;
          print(' ---> push message $message');
          if (message != '' && message.length > 2) {
            _sendMessage(message);
          } else {
            print(' error message too small');
          }
        },
      ),
    );
  }
}
