import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {
  static Future<String> getAccessToken() async {
    const serviceAccountJson =
      {
        "type": "service_account",
        "project_id": "servicesapp2024",
        "private_key_id": "1adae7f119ed37ef6c53a34c57ae6448f2087d08",
        "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCS2GPyDyIIjSPJ\nynn/b4Xm2elcNMsuJ09tVHa6ceQgmUsrZAJ34vw0/uQepmHbj4AuKt6hCE5AG1K5\n4z75mBE8Ow9Z1R5P2Nw3NgFSWaq4bBfoZxU+mjuTOOuoku7J63tgGMCg/vtMMRl4\nk77GaUWfimPOFN1xn0VG4s98WqIF3wJ2uSUrjYPuBTbvjfVO7ayFL/mas6ZZ8Nvo\n2VCbHMwYpMA+U6Hl8L+2beN3BCtr4RlXqqRfd4pZ2qwo2lQuvG4vqwLGTKRWUYdU\n8FkBp7Fh9Dj575uT0HETJcgSKr0yy/GKLawyqjMGxjZ9A0TjmHp+s3lqXataaxoA\ndEpnRER1AgMBAAECggEAMPgmhE9VmyJuH9n8yxkGv1BGCPC2HQMQ8rWrDkvytohI\nUAT+6bnxPz8NFceIdK6rITo8mdjqN2ilMsY8dwGmJb7QRLXUcO4xqdvBnxO14eBy\nLJdLt1+5pEPkGog9R2rW7tnySv4dEXCCPPqQMRxkEmsVE2FT45MoiBYU+TREOc5+\naF/bCfqgfPLjIRHAsK00pw1zVxnlxEqCRN73+f9Shks7x7an6zxZ4Lbx1APHZUiy\n+S70RCSKUGixgB7QzdUXA0jSXZoYRlZFfsqWGVztclHwmyaYl0qjOGr9lUBATSBl\n9FbausJ0OF6vmL4nN9JB4wZP6FBYpXl6WScyqL2VNQKBgQDHGzinBbggZJSh5PwI\nu3W4NidYj+yLyw1wcHuJYh7HyqL1CFTnYdMGJEvvT6AMKRPyPbq9veHkGXM0+s1Y\nljEwlcxQljuPRWretrNp8EsNQD8uIm/ULege24JKKW6qQHN8DnCCVLnCx8/RLfXc\nwX8gDPQSOE59HVW6fcsYclRqQwKBgQC8zju0syZh9eQrtqHJgCd0cL6AQtYKQysr\nqXSBGwmDb8GyP/tKAi+iM5UyeHQeN7sfXypGq2od0AMs0AivTz3c1LWG5rMDF6RB\npLb0kuPjYcyfZGY2EbUseb9ev4o873SwCuSFM8AqxlxW3GclFcVS1sNc81eGKakz\nS8bGK1T25wKBgBUHkQJDHmF9fh1jXCNn+VUNkzZNbUSOm8rGdqXaETo08uVCjgUq\nVemOJ98M3/Co3gx17KVhytwWvA5adxnmMyfYio3wcDX/tPv0/BoyYRrzMDklNf6J\nIr0vniFLIv8kc44k0ElTvZMPG6oSWqeIYG74L0dFXzTjxkw+QRdB7ByVAoGASJKh\nQpEGNOtWXDMkNxbqk4huwVBvg5xT8MF/Bc1Ft97yPjj3t3flpVxcgfzo7WCQrbtf\nvbBP5su5HLWOUQyNg9/DMupkbtDck1rj9Fit/g3uoGnwG+JsmH7nv1yynz+Pw8c8\nFbNRr191yPGJOCkJIxFoIMdsoiZLYmtDKZMoYosCgYAStRu94TD2q1+9avuKmaVW\niBATJYhKQH95bQZzlSlEzxm9yw6LKm+OfXhZ39TVrLvJDFefz4tPoo5FpwLZDcPi\nJ9WmTOoJQgGWQ/HTk3r8WgiR8XsyRGAHgD19HNMVREdUWegldBRyWZeSvsIgKX6K\n+UgVO/RAyban+WLdA4XuFQ==\n-----END PRIVATE KEY-----\n",
        "client_email": "serviceappfcm@servicesapp2024.iam.gserviceaccount.com",
        "client_id": "115763657468661021643",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
        "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/serviceappfcm%40servicesapp2024.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
      String deviceToken, String title, String body)

  async {

    print("Device tokeeeen====$deviceToken");

    final String accessToken = await getAccessToken();

    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/servicesapp2024/messages:send';

    final Map<String, dynamic> message = {
      "message": {
        "token":
        deviceToken,
        "notification": {"title": title, "body": body},
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      print('Notification sent successfully');
      Fluttertoast.showToast(
        msg: "تم إرسال الإشعار بنجاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      print("Failed to send notification: ${response.statusCode}");
      print('Failed to send notification');
      Fluttertoast.showToast(
        msg: "فشل في إرسال الإشعار",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> sendNotificationToAll(String title, String body) async {
    final String accessToken = await getAccessToken();
    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/servicesapp2024/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "topic": "all", // Use a topic to send to all subscribers
        "notification": {"title": title, "body": body},
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent to all successfully');
      Fluttertoast.showToast(
        msg: "تم إرسال الإشعار إلى الجميع بنجاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      print('Failed to send notification to all');
      Fluttertoast.showToast(
        msg: "فشل في إرسال الإشعار إلى الجميع",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
