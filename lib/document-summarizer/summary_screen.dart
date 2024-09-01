import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryScreen extends StatelessWidget {
  final String summary;
  final String filename;

  SummaryScreen({
    Key? key,
    required this.summary,
    required this.filename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffff0),
      appBar: AppBar(
        backgroundColor: Color(0xFFfffff0),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left,
              color: Color.fromRGBO(79, 33, 112, 1)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Summary: $filename',
            style: GoogleFonts.hankenGrotesk(
                color: const Color.fromRGBO(79, 33, 112, 1))),
        // backgroundColor: Colors.deepPurple,
        elevation: 2.0,
        //shadowColor: Colors.grey[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  //color: Color(0xFFfffff0),
                  color: Color(0xFFf5fffa),
                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(
                    color: Colors.black54,
                    //borderRadius: BorderRadius.circular
                    //  borderRadius: BorderRadius.circular(12),
                    //borderSide: BorderSide(color: Colors.grey[400], width: 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: Color.fromARGB(255, 134, 72, 241),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: summary));
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     backgroundColor:
                          //         Colors.deepPurple.withOpacity(0.9),
                          //     content: Text('Summary copied to clipboard'),
                          //     behavior: SnackBarBehavior.floating,
                          //     margin: EdgeInsets.all(20),
                          //   ),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () async {
              //     // final summaryService = SummaryService();
              //     // await summaryService.storeSummary(summary, filename);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     foregroundColor: Colors.white,
              //     backgroundColor: Colors.deepPurple,
              //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              //     textStyle: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: Text("Save Summary"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/api/summary_service.dart';

// class SummaryScreen extends StatelessWidget {
//    SummaryScreen({super.key,
//   required this.summary,
//   required this.filename,
//   });
//   final String summary;
//   final String filename;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Summary'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Text(summary,style: TextStyle(
//                 fontSize: 16
//               ),),
//               ElevatedButton(onPressed: () async{
//                final summaryService=SummaryService();
//                await summaryService.storeSummary(summary, filename);
        
//               }, child: Text("Save Summary"))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }