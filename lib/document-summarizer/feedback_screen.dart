import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'native_ad_widget.dart'; // Import the native ad widget

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 234, 253, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(243, 234, 253, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left,
              size: 28, color: Color.fromRGBO(79, 33, 112, 1)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Feedback',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 24,
            color: Color.fromRGBO(79, 33, 112, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                '* We appreciate any feedback you have',
                                style: GoogleFonts.hankenGrotesk(
                                  fontSize: 14,
                                  color: Color.fromRGBO(79, 33, 112, 1),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Email',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(79, 33, 112, 1),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.black45),
                                fillColor: Color(0xFFD9BAF8),
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Your Message here',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: TextFormField(
                                controller: _messageController,
                                cursorColor: Colors.black,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  hintText: 'Type here..',
                                  hintStyle: TextStyle(color: Colors.black45),
                                  fillColor: Color(0xFFD9BAF8),
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your message';
                                  }
                                  return null;
                                },
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 32),
                            Center(
                              child: ElevatedButton(
                                onPressed: _submitFeedback,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(79, 33, 112, 1),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  'Submit',
                                  style: GoogleFonts.hankenGrotesk(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: constraints.maxHeight * 0.3, // Adjust height as needed
                child: NativeAdWidget(), // Display the native ad here
              ),
            ],
          );
        },
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Implement EmailJS sending functionality here
      sendEmail(
        _emailController.text,
        _messageController.text,
      );
    }
  }

  void sendEmail(String email, String message) async {
    const serviceId = 'service_bq5hh3b';
    const templateId = 'template_q03ao9i';
    const userId = 'OJtwhIjfIECJuWJpU';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http:localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_email': email,
          'message': message,
        },
      }),
    );

    if (response.statusCode == 200) {
      _emailController.clear();
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback sent successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 50.0, left: 10.0, right: 10.0),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send feedback. Please try again later.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 50.0, left: 10.0, right: 10.0),
        ),
      );
    }
  }
}
