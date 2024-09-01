import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';

class AssistantMessageWidget extends StatelessWidget {
  const AssistantMessageWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 249, 238, 85),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 8),
        child: message.isEmpty
            ? const SizedBox(
                width: 50,
                child: SpinKitThreeBounce(
                  color: Colors.blueGrey,
                  size: 20.0,
                ),
              )
            : RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: message,
                      style: DefaultTextStyle.of(context).style,
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: IconButton(
                        icon: Icon(Icons.copy, color: Colors.grey[500]),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: message));
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text('Message copied to clipboard'),
                          //     duration: Duration(seconds: 2),
                          //   ),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
