import 'dart:convert';

import 'package:chat_ui/chatpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//
class MyApp extends StatelessWidget {
  MyApp({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    final Map<String, String> body = {
      'name': emailController.text,
      'password': passwordController.text,
    };
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      showLoadingDialog(context);
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/login/"),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json'
        }, // Specify the request header // Specify the request header
      );
      // ignore: use_build_context_synchronously
      hideLoadingDialog(context);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ChatRoomPage(
            emailController.text
          )),
        );
      } else {
        // Failed login
        showResponseDialog(context, extractErrorMessage(response.body));

        // Handle error or display error message
      }
    }
  }

  String extractErrorMessage(String response) {
    final parsedResponse = jsonDecode(response);

    try {
      final errorMessage = parsedResponse['detail'][0]['msg'];
      return errorMessage;
    } catch (e) {
      // Error occurred while parsing the response or accessing the field
      // Handle the error accordingly
      try {
        final errorMessage = parsedResponse['detail'];
        return errorMessage;
      } catch (e) {
        return 'Error occurred';
      }
    }
  }

  void showResponseDialog(BuildContext context, String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Server Response'),
          content: Text(response),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Function to show loading dialog
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(), // Loading spinner
                SizedBox(
                    width: 16.0), // Add some space between the spinner and text
                Text('Loading...'), // Loading text
              ],
            ),
          ),
        );
      },
    );
  }

// Function to hide loading dialog
  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  loginUser(context);
                },
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp( MaterialApp(
    home: MyApp(),
  ));
}
