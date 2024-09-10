// import 'package:expense_manager/Features/pdf/save_and_opne_pdf.dart';
// import 'package:expense_manager/Features/pdf/simple_pdf_api.dart';
// import 'package:flutter/material.dart';

// class ShowPDFScreen extends StatefulWidget {
//   const ShowPDFScreen({super.key});

//   @override
//   State<ShowPDFScreen> createState() => _ShowPDFScreenState();
// }

// class _ShowPDFScreenState extends State<ShowPDFScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final simplePdfFile = await SimplePdfApi.generateSimpleTextPdf(
//               'Sample Text',
//               'Hello world',
//             );
//             SaveAndOpneDocument.openPdf(simplePdfFile);
//           },
//           child: const Text('Invoice PDF'),
//         ),
//       ),
//     );
//   }
// }
