import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:agronom/env.dart';

final String url = API;

class Message extends Equatable{
    String content;

    Message({
      @required this.content,
      }) : super([
        content
      ]);

    Message.fromJson(Map<String, dynamic> jsonData) {
       this.content = jsonData['content'];
    }
}

class MessageList extends Equatable {
  List<Message> activityListItem;

  MessageList({
    this.activityListItem,
  }) : super([activityListItem]);

  MessageList.fromJson(List<dynamic> jsonData) {
    activityListItem =
        jsonData.map((i) => Message.fromJson(i)).toList();
  }
}

class MessageSentResponse extends Equatable {
  final String messageLink;
  final String content;
  final String dateCreated;

  MessageSentResponse(this.messageLink, this.content, this.dateCreated);

  MessageSentResponse.fromJson(Map<String, dynamic> json)
      : messageLink = '$url/${json['uuid']}',
        content = json['default_content'],
        dateCreated = json['created_at'];

  Map<String, dynamic> toJson() => {
    'messageLink': messageLink,
    'content': content,
    'dateCreated': dateCreated
  };
}