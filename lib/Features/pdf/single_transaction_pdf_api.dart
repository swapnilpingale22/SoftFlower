import 'dart:io';

import 'package:expense_manager/Features/pdf/save_and_opne_pdf.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../utils/strings.dart';
import '../transactions/models/transactions_model.dart';

class SingleTransactionPdfApi {
  static var image1;
  static var font;
  static String? bgShape;
  static String? logo1;
  static String? logo2;
  static const baseColor = PdfColors.blueGrey800;
  static const tealColor = PdfColor.fromInt(0xff009688);
  static const accentColor = PdfColors.white;

  static Future<Font> loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return Font.ttf(fontData);
  }

  static Future<File> generateSingleTransactionPdf({
    required RxList<Transactions> transData,
    required int index,
  }) async {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(transData[index].transactionDate);

    bgShape = await rootBundle.loadString('assets/svg/invoice.svg');
    logo1 = await rootBundle.loadString('assets/svg/logo_1.svg');
    logo2 = await rootBundle.loadString('assets/svg/logo_2.svg');

    final pdf = Document();

    font = await loadFont('assets/fonts/Roboto-Regular.ttf');

    Future<Uint8List> loadImage() async {
      final ByteData data =
          await rootBundle.load('assets/images/transaction.png');
      final Uint8List imageLogo = data.buffer.asUint8List();

      return imageLogo;
    }

    image1 = await loadImage();

    final data = transData[index]
        .transactionDetailsList
        .map((transactionDetails) => [
              transactionDetails.itemName,
              transactionDetails.rate,
              transactionDetails.quantity,
              transactionDetails.totalSale,
            ])
        .toList();

    pdf.addPage(
      MultiPage(
        pageTheme: customPageTheme(PdfPageFormat.a4, font, font, font),
        header: (context) =>
            mainHeader(context, formattedDate, transData, index),
        footer: (context) => buildFooter(context, transData, index),
        build: (context) => [
          contentHeader(formattedDate, context, transData, index),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          ...bulletPoints(transData, index, formattedDate),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          contentTable(context, data),
          SizedBox(height: 20),
          contentFooter(context, transData, index),
          SizedBox(height: 20),
          // termsAndConditions(context),
        ],
      ),
    );

    return SaveAndOpneDocument.savePdf(
        name: 'Invoice - ${transData[index].agentName} $formattedDate.pdf',
        pdf: pdf);
  }

  static PageTheme customPageTheme(
      PdfPageFormat pageFormat, Font base, Font bold, Font italic) {
    return PageTheme(
      pageFormat: pageFormat,
      theme: ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => FullPage(
        ignoreMargins: true,
        child: SvgImage(svg: bgShape!),
      ),
    );
  }

  static Widget mainHeader(
    Context context,
    String formattedDate,
    RxList<Transactions> transData,
    int index,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo 1
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                // padding: const EdgeInsets.only(bottom: 8, left: 0),
                height: 100,
                child: logo1 != null ? SvgImage(svg: logo1!) : PdfLogo(),
              ),
            ),
            //company title
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.center,
                    child: Text(
                      transData[index].companyId,
                      style: TextStyle(
                        color: tealColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.center,
                    child: Text(
                      transData[index].companyAddress,
                      style: TextStyle(
                        color: tealColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                // padding: const EdgeInsets.only(bottom: 8, left: 20),
                height: 100,
                child: logo2 != null ? SvgImage(svg: logo2!) : PdfLogo(),
              ),
            ),
          ],
        ),
        // SizedBox(height: 20),
        Divider(
          height: 20,
          color: PdfColors.grey500,
        ),
        if (context.pageNumber > 1) SizedBox(height: 20)
      ],
    );
  }

  static Widget buildFooter(
    Context context,
    RxList<Transactions> transData,
    int index,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  static Widget contentHeader(
    String formattedDate,
    Context context,
    RxList<Transactions> transData,
    int index,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: PdfColors.grey500),
            // color: baseColor,
          ),
          padding:
              const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
          alignment: Alignment.centerLeft,
          height: 80,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    // color: accentColor,
                    color: baseColor,
                    fontSize: 22,
                  ),
                  child: GridView(
                    crossAxisCount: 2,
                    children: [
                      Text('Farmer name: '),
                      Text(transData[index].agentName,
                          overflow: TextOverflow.clip),
                      Text('Date:'),
                      Text(formattedDate),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                child: BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: 'Invoice# ${transData[index].transactionId}',
                    drawText: false,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: const EdgeInsets.all(2)),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 50,
                child: Text(
                  'Total: \u20B9${transData[index].totalBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 28,
                    font: font,
                    color: tealColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Expanded(
            //   child: Row(
            //     children: [
            //       Container(
            //         margin: const EdgeInsets.only(left: 10, right: 10),
            //         height: 70,
            //         child: Text(
            //           'Invoice #:',
            //           style: TextStyle(
            //             color: baseColor,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 24,
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(
            //           height: 70,
            //           child: RichText(
            //             text: TextSpan(
            //               text: '${transData[index].transactionId}\n',
            //               style: TextStyle(
            //                 color: baseColor,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 22,
            //               ),
            //               children: const [
            //                 TextSpan(
            //                   text: '\n',
            //                   style: TextStyle(
            //                     fontSize: 5,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  static Widget contentTable(Context context, List<List<Object>> data) {
    const tableHeaders = ['Item Description', 'Price', 'Quantity', 'Total'];

    return TableHelper.fromTextArray(
      border: null,
      cellAlignment: Alignment.centerLeft,
      headerDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        color: tealColor,
      ),
      headerHeight: 30,
      cellHeight: 50,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.center,
        3: Alignment.centerRight,
      },
      headerStyle: TextStyle(
        color: accentColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
      cellStyle: const TextStyle(
        color: baseColor,
        fontSize: 22,
      ),
      rowDecoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: baseColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: data,
      // List<List<String>>.generate(
      //   products.length,
      //   (row) => List<String>.generate(
      //     tableHeaders.length,
      //     (col) => products[row].getIndex(col),
      //   ),
      // ),
    );
  }

  static Widget contentFooter(
    Context context,
    RxList<Transactions> transData,
    int index,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thank you for your business',
                style: TextStyle(
                  color: baseColor,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 20, bottom: 8),
              //   child: Text(
              //     'Payment Info:',
              //     style: TextStyle(
              //       color: baseColor,
              //       fontSize: 22,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // Text(
              //   "${transData[index].companyId}\n${transData[index].companyAddress}",
              //   style: const TextStyle(
              //     fontSize: 22,
              //     lineSpacing: 5,
              //     color: baseColor,
              //   ),
              // ),
            ],
          ),
        ),
        // Expanded(
        //   flex: 1,
        //   child: DefaultTextStyle(
        //     style: const TextStyle(
        //       fontSize: 10,
        //       color: baseColor,
        //     ),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text('Sub Total:'),
        //             Text('\u20B9${transData[index].totalSale}'),
        //           ],
        //         ),
        //         SizedBox(height: 5),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text('Commission:'),
        //             Text('${transData[index].commission.toStringAsFixed(2)}%'),
        //           ],
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text('Motor Rent:'),
        //             Text('${transData[index].motorRent.toStringAsFixed(2)}%'),
        //           ],
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text('Coolie:'),
        //             Text('${transData[index].coolie.toStringAsFixed(2)}%'),
        //           ],
        //         ),
        //         Divider(color: accentColor),
        //         DefaultTextStyle(
        //           style: TextStyle(
        //             color: tealColor,
        //             fontSize: 14,
        //             fontWeight: FontWeight.bold,
        //           ),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Text('Total:'),
        //               Text('\u20B9${transData[index].totalBalance}'),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  static Widget termsAndConditions(Context context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: baseColor)),
                ),
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 22,
                    color: baseColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                terms,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 20,
                  lineSpacing: 2,
                  color: baseColor,
                ),
              ),
            ],
          ),
        ),
        // Expanded(
        //   child: SizedBox(),
        // ),
      ],
    );
  }

  static Widget customHeader(RxList<Transactions> transData, int index) =>
      Container(
        padding: const EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: PdfColors.black,
            ),
          ),
        ),
        child: Row(
          children: [
            // PdfLogo(),
            Image(MemoryImage(image1), height: 60),
            // SizedBox(width: 0.5 * PdfPageFormat.cm),

            Expanded(
              child: Column(
                children: [
                  Text(
                    transData[index].companyId != ""
                        ? transData[index].companyId
                        : "Company Name",
                    style: TextStyle(
                      fontSize: 26,
                      color: PdfColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    transData[index].companyAddress != ""
                        ? transData[index].companyAddress
                        : "Company Name",
                    style: const TextStyle(
                      fontSize: 18,
                      color: PdfColors.blue,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  static Widget customHeadLine(
      RxList<Transactions> transData, int index, String formattedDate) {
    return Header(
      child: Container(
        alignment: Alignment.center,
        // margin: const EdgeInsets.only(top: 10),
        child: Text(
          'INVOICE',
          style: TextStyle(
            fontSize: 20,
            color: PdfColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: PdfColors.blue200,
      ),
    );
  }

  static List<Widget> bulletPoints(
      RxList<Transactions> transData, int index, String formattedDate) {
    return [
      // Bullet(
      //   text: 'Date: $formattedDate',
      //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      //   bulletMargin: const EdgeInsets.only(top: 9, right: 5),
      //   bulletSize: 3 * PdfPageFormat.mm,
      // ),
      // Bullet(
      //   text: 'Name: ${transData[index].agentName}',
      //   style: const TextStyle(fontSize: 14),
      //   bulletMargin: const EdgeInsets.only(top: 9, right: 5),
      //   bulletSize: 3 * PdfPageFormat.mm,
      // ),
      // Bullet(
      //   text: 'Product: ${transData[index].transactionDetailsList[0].itemName}',
      //   style: const TextStyle(fontSize: 14),
      //   bulletMargin: const EdgeInsets.only(top: 9, right: 5),
      //   bulletSize: 3 * PdfPageFormat.mm,
      // ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Daag:',
              style: const TextStyle(fontSize: 22),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].daag}   ',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
      // Bullet(
      //   text:
      //       'Rate: ${transData[index].transactionDetailsList[0].rate.toStringAsFixed(2)}/-',
      //   style: const TextStyle(fontSize: 14),
      //   bulletMargin: const EdgeInsets.only(top: 9, right: 5),
      //   bulletSize: 3 * PdfPageFormat.mm,
      // ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Total Sale:',
              style: const TextStyle(fontSize: 22),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].totalSale.toStringAsFixed(2)}/-',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Commission:',
              style: const TextStyle(fontSize: 22),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].commission.toStringAsFixed(2)}/-',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Motor Rent:',
              style: const TextStyle(fontSize: 22),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].motorRent.toStringAsFixed(2)}/-',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Coolie:',
              style: const TextStyle(fontSize: 22),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].coolie.toStringAsFixed(2)}/-',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Total Expense:',
              style: const TextStyle(fontSize: 22),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].totalExpense.toStringAsFixed(2)}/-',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Total Balance:',
              style: const TextStyle(fontSize: 22),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].totalBalance.toStringAsFixed(2)}/-',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
    ];
  }

  static Widget buildPageNumber(Context context) => Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(top: 10, right: 10),
        child: Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const TextStyle(
            fontSize: 10,
            color: PdfColors.white,
          ),
        ),
      );
}
