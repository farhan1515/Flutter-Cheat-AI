import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomBtn({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Align(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              elevation: 0,
              backgroundColor: Colors.purple,
              textStyle: GoogleFonts.hankenGrotesk(
                  fontSize: 16, fontWeight: FontWeight.w500),
             
              minimumSize: Size(mq.width * .4, 50)),
          onPressed: onTap,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}
