import 'dart:ffi';

import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/Features/common_widgets/custom_button.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../../pdf/month_transaction_pdf_api .dart';
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
  final monthTransactionPdfController =
      Get.put(MonthTransactionPdfController());

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
                                            await monthTransactionPdfController
                                                .generateMonthTransactionPdf(
                                          transData: mTC.allMonthlyTransactions,
                                        );

                                        SaveAndOpneDocument.openPdf(
                                            paragraphPdf);
                                      },
                                      isLoading: monthTransactionPdfController
                                          .isPDFLoading.value,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 60),
                            Visibility(
                              visible: mTC.allMonthlyTransactions.isNotEmpty,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: mTC.agents.length,
                                itemBuilder: (context, index) {
                                  //total balance
                                  // Calculate total balance for each agent

                                  mTC.totalDaag.value =
                                      mTC.getTotalDaagForAgent(index);

                                  mTC.totalSale.value =
                                      mTC.getTotalSaleForAgent(index);

                                  mTC.totalCommission.value =
                                      mTC.getTotalCommissionForAgent(index);

                                  mTC.totalExpense.value =
                                      mTC.getTotalExpenseForAgent(index);

                                  mTC.totalBalance.value =
                                      mTC.getTotalBalanceForAgent(index);

                                  return Text(
                                      "${mTC.agents[index].agentName} \nDaag: ${mTC.totalDaag.value} \nT Sale: ${mTC.totalSale.value} \nT Comm: ${mTC.totalCommission.value} \nT Exp: ${mTC.totalExpense.value} \nBalance:${mTC.totalBalance.value}\n\n");
                                },
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
