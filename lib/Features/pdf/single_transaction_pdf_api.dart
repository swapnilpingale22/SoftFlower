import 'dart:io';

import 'package:expense_manager/Features/pdf/save_and_opne_pdf.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../transactions/models/transactions_model.dart';

class SingleTransactionPdfApi {
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

    final data = transData[index]
        .transactionDetailsList
        .map((transactionDetails) => [
              transactionDetails.itemName,
              transactionDetails.rate.toStringAsFixed(2),
              transactionDetails.quantity,
              transactionDetails.totalSale.toStringAsFixed(2),
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
    String? mobileNumber = RegExp(r'\b\d{10}\b')
        .firstMatch(transData[index].companyAddress)
        ?.group(0);
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
          height: 80,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: DefaultTextStyle(
                  style: const TextStyle(
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
              Column(
                children: [
                  Text(
                    'Scan to Pay',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.only(top: 3),
                    child: BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        data: mobileNumber ?? '',
                        drawText: false,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        padding: const EdgeInsets.all(2)),
                  ),
                ],
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
                height: 30,
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
          ],
        ),
      ],
    );
  }

  static List<Widget> bulletPoints(
      RxList<Transactions> transData, int index, String formattedDate) {
    return [
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
            ],
          ),
        ),
      ],
    );
  }
}
