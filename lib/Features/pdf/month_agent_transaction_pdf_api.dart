// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:expense_manager/Features/pdf/save_and_opne_pdf.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../agent/models/agent_model.dart';
import '../transactions/controller/month_transaction_controller.dart';
import '../transactions/models/transactions_model.dart';

class MonthAgentTransactionPdfController extends GetxController {
  final mTC = Get.put(MonthTransactionController());
  static var font;
  static String? bgShape;
  static String? logo1;
  static String? logo2;
  static const baseColor = PdfColors.blueGrey800;
  static const tealColor = PdfColor.fromInt(0xff009688);
  static const accentColor = PdfColors.white;
  double totalDaag = 0;
  double totalSale = 0;
  double totalExpense = 0;
  double totalBalance = 0;

  RxBool isPDFLoading = false.obs;

  static Future<Font> loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return Font.ttf(fontData);
  }

  Future<File> generateMonthAgentTransactionPdf({
    required RxList<Transactions> transData,
    required RxList<Agent> agent,
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
            contentTable(context, transData, agent),
            SizedBox(height: 20),
            contentFooter(context, transData),
            SizedBox(height: 20),
          ],
        ),
      );

      return SaveAndOpneDocument.savePdf(
        name:
            'Invoice - ${DateFormat('MMMM-yyyy').format(transData[0].transactionDate)}.pdf',
        pdf: pdf,
      );
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
          child: Row(
            children: [
              Spacer(),
              Text(
                DateFormat('MMMM - yyyy')
                    .format(transData[index].transactionDate),
                style: TextStyle(
                  color: baseColor,
                  fontSize: 22,
                  font: font,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget contentTable(
    Context context,
    RxList<Transactions> transData,
    RxList<Agent> agents,
  ) {
    const tableHeaders = [
      'Name',
      "Daag",
      'Sale',
      'Comm',
      'Expense',
      'Balance',
    ];
    List<List<dynamic>> totalData = [];

    double totalDaagAll = 0;
    double totalSaleAll = 0;
    double totalCommissionAll = 0;
    double totalExpenseAll = 0;
    double totalBalanceAll = 0;

    for (var index = 0; index < agents.length; index++) {
      String agentName = agents[index].agentName;

      double totalDaag = mTC.getTotalDaagForAgent(index);
      double totalSale = mTC.getTotalSaleForAgent(index);
      double totalCommission = mTC.getTotalCommissionForAgent(index);
      double totalExpense = mTC.getTotalExpenseForAgent(index);
      double totalBalance = mTC.getTotalBalanceForAgent(index);

      totalData.add([
        agentName,
        totalDaag == 0.00 ? "--" : totalDaag.toStringAsFixed(0),
        totalSale == 0.00 ? "--" : totalSale.toStringAsFixed(2),
        totalCommission == 0.00 ? "--" : totalCommission.toStringAsFixed(2),
        totalExpense == 0.00 ? "--" : totalExpense.toStringAsFixed(2),
        totalBalance == 0.00 ? "--" : totalBalance.toStringAsFixed(2),
      ]);

      // Add to cumulative totals
      totalDaagAll += totalDaag;
      totalSaleAll += totalSale;
      totalCommissionAll += totalCommission;
      totalExpenseAll += totalExpense;
      totalBalanceAll += totalBalance;
    }

    // Add the totals row at the end
    totalData.add([
      "Total",
      totalDaagAll.toStringAsFixed(0),
      totalSaleAll.toStringAsFixed(2),
      totalCommissionAll.toStringAsFixed(2),
      totalExpenseAll.toStringAsFixed(2),
      totalBalanceAll.toStringAsFixed(2),
    ]);

    return TableHelper.fromTextArray(
      border: null,
      cellAlignment: Alignment.centerRight,
      headerAlignment: Alignment.centerRight,
      headerDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: tealColor,
      ),
      headerHeight: 30,
      cellHeight: 30,
      cellPadding: const EdgeInsets.symmetric(horizontal: 5),
      headerPadding: const EdgeInsets.symmetric(horizontal: 5),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
      },
      headerAlignments: {
        0: Alignment.center,
        1: Alignment.center,
      },
      headerStyle: TextStyle(
        color: accentColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        font: font,
      ),
      cellStyle: TextStyle(
        color: baseColor,
        fontSize: 12,
        font: font,
      ),
      cellDecoration: (index, data, rowNum) {
        if (rowNum == totalData.length) {
          return const BoxDecoration(
            color: PdfColors.teal100,
          );
        }
        return const BoxDecoration();
      },
      rowDecoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: baseColor,
            width: .5,
          ),
        ),
      ),
      headers: tableHeaders,
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
              SizedBox(height: 50),
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
