// import 'dart:io';

// import 'package:expense_manager/Features/pdf/save_and_opne_pdf.dart';
// import 'package:pdf/widgets.dart';

// class SimplePdfApi {
//   static Future<File> generateSimpleTextPdf(String text, String text2) async {
//     final pdf = Document();
//     pdf.addPage(
//       Page(
//         build: (context) => Center(
//           child: Column(
//             children: [
//               Text(text, style: const TextStyle(fontSize: 48)),
//               Text(text2, style: const TextStyle(fontSize: 48)),
//             ],
//           ),
//         ),
//       ),
//     );

//     return SaveAndOpneDocument.savePdf(name: 'simple_pdf.pdf', pdf: pdf);
//   }
// }
