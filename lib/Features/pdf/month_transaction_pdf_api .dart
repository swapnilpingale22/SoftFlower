// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:expense_manager/Features/pdf/save_and_opne_pdf.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../transactions/models/transactions_model.dart';

class MonthTransactionPdfController extends GetxController {
  static var font;
  static String? bgShape;
  static String? logo1;
  static String? logo2;
  static const baseColor = PdfColors.blueGrey800;
  static const tealColor = PdfColor.fromInt(0xff009688);
  static const accentColor = PdfColors.white;

  RxBool isPDFLoading = false.obs;

  static Future<Font> loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return Font.ttf(fontData);
  }

  Future<File> generateMonthTransactionPdf({
    required RxList<Transactions> transData,
  }) async {
    try {
      isPDFLoading.value = true;

      bgShape = await rootBundle.loadString('assets/svg/invoice.svg');
      logo1 = await rootBundle.loadString('assets/svg/logo_1.svg');
      logo2 = await rootBundle.loadString('assets/svg/logo_2.svg');

      final pdf = Document();

      font = await loadFont('assets/fonts/Roboto-Regular.ttf');

      pdf.addPage(
        MultiPage(
          pageTheme: customPageTheme(PdfPageFormat.a4, font, font, font),
          header: (context) => mainHeader(context, transData, 0),
          footer: (context) => buildFooter(context, transData, font),
          build: (context) => [
            contentHeader(context, transData, 0, font),
            SizedBox(height: 0.5 * PdfPageFormat.cm),
            // ...bulletPoints1(transData, index, formattedDate),
            // SizedBox(height: 0.5 * PdfPageFormat.cm),
            contentTable(context, transData),
            // SizedBox(height: 0.5 * PdfPageFormat.cm),
            // ...bulletPoints2(transData, index, formattedDate),
            SizedBox(height: 20),
            contentFooter(context, transData),
            SizedBox(height: 20),
          ],
        ),
      );

      return SaveAndOpneDocument.savePdf(
          name:
              'Invoice - ${transData[0].agentName} ${DateFormat('MMMM-yyyy').format(transData[0].transactionDate)}.pdf',
          pdf: pdf);
    } catch (e) {
      print("Error generating PDF: $e");
      throw Exception();
    } finally {
      isPDFLoading.value = false;
    }
  }

  static PageTheme customPageTheme(
      PdfPageFormat pageFormat, Font base, Font bold, Font italic) {
    return PageTheme(
      pageFormat: pageFormat,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      theme: ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
        boldItalic: font,
        fontFallback: [font],
        icons: font,
      ),
      buildBackground: (context) => FullPage(
        ignoreMargins: true,
        child: SvgImage(svg: bgShape!),
      ),
    );
  }

  static Widget mainHeader(
    Context context,
    // String formattedDate,
    RxList<Transactions> transData,
    int index,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                height: 100,
                child: logo1 != null ? SvgImage(svg: logo1!) : PdfLogo(),
              ),
            ),
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
                        font: font,
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
                        font: font,
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
                height: 100,
                child: logo2 != null ? SvgImage(svg: logo2!) : PdfLogo(),
              ),
            ),
          ],
        ),
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
    // int index,
    Font font,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: TextStyle(
            fontSize: 12,
            color: PdfColors.white,
            font: font,
          ),
        ),
      ],
    );
  }

  static Widget contentHeader(
    Context context,
    RxList<Transactions> transData,
    int index,
    Font font,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: PdfColors.grey500),
          ),
          padding:
              const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
          alignment: Alignment.centerLeft,
          // height: 40,
          child: Row(
            children: [
              Text(
                'Name: ',
                style: TextStyle(
                  color: baseColor,
                  fontSize: 22,
                  font: font,
                ),
              ),
              Text(
                transData[index].agentName,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: baseColor,
                  fontSize: 22,
                  font: font,
                ),
              ),
              Spacer(),
              // Text(
              //   'Date: ',
              //   style: TextStyle(
              //     color: baseColor,
              //     fontSize: 22,
              //     font: font,
              //   ),
              // ),
              Text(
                DateFormat('MMMM - yyyy')
                    .format(transData[index].transactionDate),
                style: TextStyle(
                  color: baseColor,
                  fontSize: 22,
                  font: font,
                ),
              ),
              // Expanded(
              //   flex: 4,
              //   child: DefaultTextStyle(
              //     style: TextStyle(
              //       color: baseColor,
              //       fontSize: 22,
              //       font: font,
              //     ),
              //     child: GridView(
              //       crossAxisCount: 2,
              //       children: [
              //         Text('Name: '),
              //         Text(transData[index].agentName,
              //             overflow: TextOverflow.clip),
              //         Text('Date:'),
              //         Text(formattedDate),
              //       ],
              //     ),
              //   ),
              // ),
              // Column(
              //   children: [
              //     Text(
              //       'Scan to Pay',
              //       style: TextStyle(
              //         fontSize: 12,
              //         font: font,
              //       ),
              //     ),
              //     Container(
              //       height: 40,
              //       width: 40,
              //       padding: const EdgeInsets.only(top: 3),
              //       child: BarcodeWidget(
              //           barcode: Barcode.qrCode(),
              //           data: mobileNumber ?? '',
              //           drawText: false,
              //           decoration: BoxDecoration(
              //             border: Border.all(),
              //             borderRadius: BorderRadius.circular(2),
              //           ),
              //           padding: const EdgeInsets.all(2)),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Expanded(
        //       child: Container(
        //         margin:
        //             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //         height: 30,
        //         child: Text(
        //           'Total: \u20B9${transData[index].totalBalance.toStringAsFixed(2)}',
        //           style: TextStyle(
        //             fontSize: 28,
        //             font: font,
        //             color: tealColor,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  static List<Widget> bulletPoints1(
      RxList<Transactions> transData, int index, String formattedDate) {
    return [
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Daag:',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].daag}   ',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
    ];
  }

  static List<Widget> bulletPoints2(
      RxList<Transactions> transData, int index, String formattedDate) {
    return [
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Bullet(
              text: 'Total Sale:',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].totalSale.toStringAsFixed(2)}/-',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
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
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].commission.toStringAsFixed(2)}/-',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
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
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].motorRent.toStringAsFixed(2)}/-',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
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
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].coolie.toStringAsFixed(2)}/-',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
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
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].totalExpense.toStringAsFixed(2)}/-',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
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
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
              bulletMargin: const EdgeInsets.only(top: 9, right: 5),
              bulletSize: 3 * PdfPageFormat.mm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.right,
              '${transData[index].totalBalance.toStringAsFixed(2)}/-',
              style: TextStyle(
                fontSize: 22,
                font: font,
              ),
            ),
          ),
          Expanded(flex: 2, child: SizedBox())
        ],
      ),
    ];
  }

  static Widget contentTable(Context context, RxList<Transactions> transData) {
    const tableHeaders = [
      'Date',
      "Daag",
      'Flower',
      'Quantity',
      'Rate',
      'Total sale',
      "Commission",
      "Coolie",
      "Jaga Bhade",
      "Motor Rent",
      "Postage",
      "Caret",
      "Total Expense",
      "Total Balance",
    ];
    List<List<dynamic>> totalData = [];

    // Variables to store the total sum
    double totalDaag = 0;
    double totalSale = 0;
    double totalExpense = 0;
    double totalBalance = 0;
    String? lastTransactionId;

    for (var index = 0; index < transData.length; index++) {
      var transactionDetailsList = transData[index].transactionDetailsList;
      var transactionDate =
          DateFormat('dd/MM/yyyy').format(transData[index].transactionDate);
      var transactionId = transData[index].transactionId;
      var daag = transData[index].daag;
      var commission = transData[index].commission;
      var coolie = transData[index].coolie;
      var jagaBhade = transData[index].jagaBhade;
      var motorRent = transData[index].motorRent;
      var postage = transData[index].postage;
      var caret = transData[index].caret;
      var totalExpenseValue = transData[index].totalExpense;
      var totalBalanceValue = transData[index].totalBalance;

      // Update the total variables
      totalDaag += daag;
      totalExpense += totalExpenseValue;
      totalBalance += totalBalanceValue;

      bool isFirstRowOfTransaction = (transactionId != lastTransactionId);
      //
      for (var transactionDetails in transactionDetailsList) {
        totalSale += transactionDetails.totalSale;

        totalData.add([
          transactionDate,
          isFirstRowOfTransaction ? daag : '',
          transactionDetails.itemName,
          transactionDetails.quantity,
          transactionDetails.rate.toStringAsFixed(0),
          transactionDetails.totalSale.toStringAsFixed(0),
          commission.toStringAsFixed(0),
          coolie.toStringAsFixed(0),
          jagaBhade.toStringAsFixed(0),
          motorRent.toStringAsFixed(0),
          postage.toStringAsFixed(0),
          caret.toStringAsFixed(0),
          totalExpenseValue.toStringAsFixed(0),
          totalBalanceValue.toStringAsFixed(0)
        ]);
        isFirstRowOfTransaction = false;
      }
      lastTransactionId = transactionId;
    }

    totalData.add([
      'Total', // Date (Total)
      totalDaag.toStringAsFixed(0), // Daag total
      '', // Empty for Flower
      '', // Empty for Quantity
      '', // Empty for Rate
      totalSale.toStringAsFixed(2), // Total Sale
      '', // Empty for Commission
      '', // Empty for Coolie
      '', // Empty for Jaga Bhade
      '', // Empty for Motor Rent
      '', // Empty for Postage
      '', // Empty for Caret
      totalExpense.toStringAsFixed(2), // Total Expense
      totalBalance.toStringAsFixed(2), // Total Balance
    ]);

    return TableHelper.fromTextArray(
      border: null,
      cellAlignment: Alignment.centerRight,
      headerDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: tealColor,
      ),
      headerHeight: 30,
      cellHeight: 50,
      cellPadding: const EdgeInsets.symmetric(horizontal: 1),
      headerPadding: const EdgeInsets.symmetric(horizontal: 1),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.centerLeft,
      },
      headerAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
      },
      headerStyle: TextStyle(
        color: accentColor,
        fontSize: 8,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        font: font,
      ),
      cellStyle: TextStyle(
        color: baseColor,
        fontSize: 8,
        font: font,
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
      data: totalData,
    );
  }

  static Widget contentFooter(
    Context context,
    RxList<Transactions> transData,
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
                  font: font,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
