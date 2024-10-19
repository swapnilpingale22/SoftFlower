import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../../pdf/month_agent_transaction_pdf_api.dart';
import '../../pdf/save_and_opne_pdf.dart';
import '../controller/month_transaction_controller.dart';

class MonthAgentTransactionScreen extends StatefulWidget {
  const MonthAgentTransactionScreen({super.key});

  @override
  State<MonthAgentTransactionScreen> createState() =>
      _MonthAgentTransactionScreenState();
}

class _MonthAgentTransactionScreenState
    extends State<MonthAgentTransactionScreen> {
  MonthTransactionController mTC = Get.put(MonthTransactionController());
  final monthAgentPdfController = Get.put(MonthAgentTransactionPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Month All Business Patti',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
        () => mTC.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: mTC.monthTransactionFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //select month section
                            Text(
                              'Select Month',
                              style: lightTextTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: mTC.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : DropdownButton<String>(
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      dropdownColor: primaryColor3,
                                      value: mTC.selectedMonth.value,
                                      hint: Text(
                                        'Select a month',
                                        style: lightTextTheme.headlineMedium
                                            ?.copyWith(
                                          fontSize: 14,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (String? newValue) {
                                        mTC.selectedMonth.value = newValue!;
                                        mTC.allMonthlyTransactions.clear();
                                      },
                                      items: mTC.monthList.map((String month) {
                                        return DropdownMenuItem<String>(
                                          value: month,
                                          child: Text(
                                            month,
                                            style: lightTextTheme.headlineMedium
                                                ?.copyWith(
                                              fontSize: 16,
                                              color: textColor,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Flexible(
                                  child: CustomButton(
                                    text: 'Search',
                                    onTap: () {
                                      if (mTC.selectedMonth.value != null) {
                                        mTC.fetchAllMonthlyTransactions();
                                      } else {
                                        showSnackBar(
                                            'Please select a month!', context);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Visibility(
                                  visible:
                                      mTC.allMonthlyTransactions.isNotEmpty,
                                  child: Flexible(
                                    child: CustomButton(
                                      text: 'View PDF',
                                      onTap: () async {
                                        final paragraphPdf =
                                            await monthAgentPdfController
                                                .generateMonthAgentTransactionPdf(
                                          transData: mTC.allMonthlyTransactions,
                                          agent: mTC.agents,
                                        );

                                        SaveAndOpneDocument.openPdf(
                                            paragraphPdf);
                                      },
                                      isLoading: monthAgentPdfController
                                          .isPDFLoading.value,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 60),
                            Visibility(
                              visible: mTC.allMonthlyTransactions.isNotEmpty,
                              child: Card(
                                color: primaryColor2,
                                elevation: 4,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header Table
                                      Table(
                                        border: const TableBorder.symmetric(
                                          inside: BorderSide(
                                            color: Colors.black12,
                                          ),
                                          outside: BorderSide(
                                            color: Colors.black12,
                                          ),
                                        ),
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        columnWidths: const {
                                          0: FixedColumnWidth(130),
                                          1: FixedColumnWidth(80),
                                          2: FixedColumnWidth(100),
                                          3: FixedColumnWidth(100),
                                          4: FixedColumnWidth(100),
                                          5: FixedColumnWidth(100),
                                        },
                                        children: const [
                                          TableRow(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  primaryColor1,
                                                  primaryColor2,
                                                  primaryColor3,
                                                ],
                                              ),
                                            ),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Name:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Daag:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Sale:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Comm:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Expense:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Balance:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // Rows with Agent Data
                                      SizedBox(
                                        height:
                                            mTC.agents.length * 35, //* 0.35,
                                        width: Get.width,
                                        child: ListView.builder(
                                          // shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: mTC.agents.length,
                                          itemBuilder: (context, index) {
                                            mTC.totalDaag.value =
                                                mTC.getTotalDaagForAgent(index);
                                            mTC.totalSale.value =
                                                mTC.getTotalSaleForAgent(index);
                                            mTC.totalCommission.value =
                                                mTC.getTotalCommissionForAgent(
                                                    index);
                                            mTC.totalExpense.value = mTC
                                                .getTotalExpenseForAgent(index);
                                            mTC.totalBalance.value = mTC
                                                .getTotalBalanceForAgent(index);

                                            // log("Agent: ${mTC.agents[index].agentName}, Daag: ${mTC.totalDaag.value}, Sale: ${mTC.totalSale.value}, Commission: ${mTC.totalCommission.value}, Expense: ${mTC.totalExpense.value}, Balance: ${mTC.totalBalance.value}");

                                            return SizedBox(
                                              // height: 50,
                                              // width: Get.width,
                                              child: Table(
                                                border:
                                                    const TableBorder.symmetric(
                                                  inside: BorderSide(
                                                    color: Colors.black12,
                                                  ),
                                                  outside: BorderSide(
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                defaultVerticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                columnWidths: const {
                                                  0: FixedColumnWidth(130),
                                                  1: FixedColumnWidth(80),
                                                  2: FixedColumnWidth(100),
                                                  3: FixedColumnWidth(100),
                                                  4: FixedColumnWidth(100),
                                                  5: FixedColumnWidth(100),
                                                },
                                                children: [
                                                  TableRow(
                                                    // decoration: BoxDecoration(
                                                    //   color: index % 2 == 0
                                                    //       ? primaryColor1
                                                    //       : primaryColor3
                                                    //           .withOpacity(0.1),
                                                    // ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(mTC
                                                            .agents[index]
                                                            .agentName),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          mTC.totalDaag.value ==
                                                                  0.00
                                                              ? "-"
                                                              : "${mTC.totalDaag.value?.toStringAsFixed(0)}",
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          mTC.totalSale.value ==
                                                                  0.00
                                                              ? "-"
                                                              : "${mTC.totalSale.value?.toStringAsFixed(2)}",
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          mTC.totalCommission
                                                                      .value ==
                                                                  0.00
                                                              ? "-"
                                                              : "${mTC.totalCommission.value?.toStringAsFixed(2)}",
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          mTC.totalExpense
                                                                      .value ==
                                                                  0.00
                                                              ? "-"
                                                              : "${mTC.totalExpense.value?.toStringAsFixed(2)}",
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          mTC.totalBalance
                                                                      .value ==
                                                                  0.00
                                                              ? "-"
                                                              : "${mTC.totalBalance.value?.toStringAsFixed(2)}",
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // Final Row for Totals
                                      Obx(
                                        () {
                                          // Calculate Total of all agents for each column
                                          double totalDaagAll = mTC.agents
                                              .fold(0.0, (prev, agent) {
                                            return prev +
                                                mTC.getTotalDaagForAgent(
                                                    mTC.agents.indexOf(agent));
                                          });

                                          double totalSaleAll = mTC.agents
                                              .fold(0.0, (prev, agent) {
                                            return prev +
                                                mTC.getTotalSaleForAgent(
                                                    mTC.agents.indexOf(agent));
                                          });

                                          double totalCommissionAll = mTC.agents
                                              .fold(0.0, (prev, agent) {
                                            return prev +
                                                mTC.getTotalCommissionForAgent(
                                                    mTC.agents.indexOf(agent));
                                          });

                                          double totalExpenseAll = mTC.agents
                                              .fold(0.0, (prev, agent) {
                                            return prev +
                                                mTC.getTotalExpenseForAgent(
                                                    mTC.agents.indexOf(agent));
                                          });

                                          double totalBalanceAll = mTC.agents
                                              .fold(0.0, (prev, agent) {
                                            return prev +
                                                mTC.getTotalBalanceForAgent(
                                                    mTC.agents.indexOf(agent));
                                          });

                                          return Table(
                                            border: const TableBorder.symmetric(
                                              inside: BorderSide(
                                                color: Colors.black12,
                                              ),
                                              outside: BorderSide(
                                                color: Colors.black12,
                                              ),
                                            ),
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            columnWidths: const {
                                              0: FixedColumnWidth(130),
                                              1: FixedColumnWidth(80),
                                              2: FixedColumnWidth(100),
                                              3: FixedColumnWidth(100),
                                              4: FixedColumnWidth(100),
                                              5: FixedColumnWidth(100),
                                            },
                                            children: [
                                              TableRow(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: primaryColor3,
                                                  ),
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Total:",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        totalDaagAll
                                                            .toStringAsFixed(0),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        totalSaleAll
                                                            .toStringAsFixed(2),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        totalCommissionAll
                                                            .toStringAsFixed(2),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        totalExpenseAll
                                                            .toStringAsFixed(2),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        totalBalanceAll
                                                            .toStringAsFixed(2),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ]),
                                            ],
                                            //
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
