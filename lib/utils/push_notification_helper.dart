import 'package:dio/dio.dart';

class PushNotificationHelper {
  static Future<void> sendMessage(List<String> devices, String title,
      String body, Map<String, dynamic> payload) async {
    final header = BaseOptions(headers: {
      'Authorization':
          'key=AAAAERADyCU:APA91bE5ficy9agatn4r4HUJWiKTjjBXNVU0QQvkm4a6a2uGHabeH3I_7aS6bEVR4yIDjAPhR9siVXOtG2ecPDhTQ_68pGHZjksla9Z-rdYXlv86jeySTPklaLPGhYOqXD9eWpPQqB0B'
    });
    final request = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        'payload': payload,
      },
    };

    for (var device in devices) {
      if (device != null) {
        request['to'] = device;
        var res = await Dio(header)
            .post('https://fcm.googleapis.com/fcm/send', data: request);
        print(res.data);
      }
    }
  }
}
