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

class MonthTransactionScreen extends StatefulWidget {
  const MonthTransactionScreen({super.key});

  @override
  State<MonthTransactionScreen> createState() => _MonthTransactionScreenState();
}

class _MonthTransactionScreenState extends State<MonthTransactionScreen> {
  MonthTransactionController monthTransactionController =
      Get.put(MonthTransactionController());
  final monthTransactionPdfController =
      Get.put(MonthTransactionPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Month Business Patti',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
        () => monthTransactionController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: monthTransactionController.monthTransactionFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //farmer section
                            Text(
                              'Select Farmer',
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
                              child: monthTransactionController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(10),
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      dropdownColor: primaryColor3,
                                      value: monthTransactionController
                                          .selectedAgentId.value,
                                      hint: Text(
                                        'Select a farmer',
                                        style: lightTextTheme.headlineMedium
                                            ?.copyWith(
                                          fontSize: 14,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (String? newValue) {
                                        monthTransactionController
                                            .selectedAgentId.value = newValue!;
                                        monthTransactionController
                                            .fetchAgentDetails(newValue);
                                        monthTransactionController.transactions
                                            .clear();
                                      },
                                      items: monthTransactionController.agents
                                          .map((Agent agent) {
                                        return DropdownMenuItem<String>(
                                          value: agent.agentId,
                                          child: Text(
                                            agent.agentName,
                                            style: lightTextTheme.headlineMedium
                                                ?.copyWith(
                                                    fontSize: 16,
                                                    color: textColor),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ),

                            const SizedBox(height: 10),

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
                              child: monthTransactionController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : DropdownButton<String>(
                                      underline: const SizedBox.shrink(),
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      dropdownColor: primaryColor3,
                                      value: monthTransactionController
                                          .selectedMonth.value,
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
                                        monthTransactionController
                                            .selectedMonth.value = newValue!;
                                        monthTransactionController.transactions
                                            .clear();
                                      },
                                      items: monthTransactionController
                                          .monthList
                                          .map((String month) {
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
                            // Visibility(
                            //   visible: monthTransactionController
                            //               .selectedMonth.value !=
                            //           null &&
                            //       monthTransactionController
                            //               .selectedAgentId.value !=
                            //           null &&
                            //       monthTransactionController
                            //           .transactions.isNotEmpty,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         "Transactions found: ${monthTransactionController.transactions.length}",
                            //         style: lightTextTheme.bodyMedium!.copyWith(
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            Row(
                              children: [
                                Flexible(
                                  child: CustomButton(
                                    text: 'Search',
                                    onTap: () {
                                      if (monthTransactionController
                                              .selectedAgentId.value !=
                                          null) {
                                        if (monthTransactionController
                                                .selectedMonth.value !=
                                            null) {
                                          monthTransactionController
                                              .fetchTransactions();
                                        } else {
                                          showSnackBar('Please select a month!',
                                              context);
                                        }
                                      } else {
                                        showSnackBar(
                                            'Please select a farmer!', context);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Visibility(
                                  visible: monthTransactionController
                                      .transactions.isNotEmpty,
                                  child: Flexible(
                                    child: CustomButton(
                                      text: 'View PDF',
                                      onTap: () async {
                                        final paragraphPdf =
                                            await monthTransactionPdfController
                                                .generateMonthTransactionPdf(
                                          transData: monthTransactionController
                                              .transactions,
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
