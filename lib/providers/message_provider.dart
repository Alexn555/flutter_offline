import 'dart:convert';
import 'package:http/http.dart' show http, Client, Response;
import 'package:agronom/models/message_model.dart';
import 'package:agronom/env.dart';

class MessageProvider {
  final Client _client = Client();
  final useParseJson = false;

  Future fetchMessage(String url) async {
    url = url != '' ? url : '$API/5e2a0153-8da3-4382-a34d-d7e24ae0f109';
    final response = await _client.get(url,
      headers: {
        'Content-type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    );

    try {
      if (response.statusCode == 200) {
        if (useParseJson) {
           final Map<String, dynamic> parsedJson = jsonDecode(response.body);
           return Message.fromJson(parsedJson);
        }
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    String content,
  }) async {
    final Map<String, dynamic> data = {
      'default_content': content,
      'timeout': 0
    };

    final params = jsonEncode(data);
    print(' --> send message $params');
    Response response = await _client.post(
      '$API/token',
      body: params,
      headers: {
        'Content-type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(' send message $responseData');

    try {
      if (response.statusCode == 201) {
        final res = new MessageSentResponse.fromJson(responseData);
        return {'status': 'success', 'data': res};
      } else {
        return {
          'status': 'fail',
          'message': 'something when wrong',
          'errors': 'error 1'
        };
      }
    } catch (error) {
      print(error);
      return {'status': 'fail', 'message': 'error message'};
    }
  }

}
