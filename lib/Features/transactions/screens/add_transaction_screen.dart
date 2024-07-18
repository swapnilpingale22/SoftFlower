import 'package:expense_manager/Features/agent/models/agent_model.dart';
import 'package:expense_manager/Features/company/models/company_model.dart';
import 'package:expense_manager/Features/product/models/product_model.dart';
import 'package:expense_manager/Features/transactions/controller/add_transaction_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/global_variables.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  AddTransactionController addTransactionController =
      Get.put(AddTransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Transaction',
            style: lightTextTheme.headlineMedium?.copyWith(
              fontSize: 20,
            ),
          ),
        ),
        body: const CommingSoonScreen()
        //  Obx(
        //   () => Padding(
        //     padding: const EdgeInsets.all(20),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           'Company Name',
        //           style: lightTextTheme.bodyMedium!.copyWith(
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //         Container(
        //           alignment: Alignment.centerLeft,
        //           child: addTransactionController.companies.isEmpty
        //               ? const Center(child: CircularProgressIndicator())
        //               : DropdownButton<String>(
        //                   dropdownColor: primaryColor3,
        //                   value: addTransactionController.selectedCompanyId.value,
        //                   hint: Text(
        //                     'Select a company',
        //                     style: lightTextTheme.headlineMedium
        //                         ?.copyWith(fontSize: 16, color: secondaryColor),
        //                   ),
        //                   onChanged: (String? newValue) {
        //                     addTransactionController.selectedCompanyId.value =
        //                         newValue!;
        //                   },
        //                   items: addTransactionController.companies
        //                       .map((Company company) {
        //                     return DropdownMenuItem<String>(
        //                       value: company.companyName,
        //                       child: Text(
        //                         company.companyName,
        //                         style: lightTextTheme.headlineMedium
        //                             ?.copyWith(fontSize: 16, color: textColor),
        //                       ),
        //                     );
        //                   }).toList(),
        //                 ),
        //         ),
        //         const SizedBox(height: 10),
        //         Text(
        //           'Agent Name',
        //           style: lightTextTheme.bodyMedium!.copyWith(
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //         Container(
        //           alignment: Alignment.centerLeft,
        //           child: addTransactionController.agents.isEmpty
        //               ? const Center(child: CircularProgressIndicator())
        //               : DropdownButton<String>(
        //                   dropdownColor: primaryColor3,
        //                   value: addTransactionController.selectedAgentId.value,
        //                   hint: Text(
        //                     'Select an agent',
        //                     style: lightTextTheme.headlineMedium
        //                         ?.copyWith(fontSize: 16, color: secondaryColor),
        //                   ),
        //                   onChanged: (String? newValue) {
        //                     addTransactionController.selectedAgentId.value =
        //                         newValue!;
        //                   },
        //                   items:
        //                       addTransactionController.agents.map((Agent agent) {
        //                     return DropdownMenuItem<String>(
        //                       value: agent.agentId,
        //                       child: Text(
        //                         agent.agentName,
        //                         style: lightTextTheme.headlineMedium
        //                             ?.copyWith(fontSize: 16, color: textColor),
        //                       ),
        //                     );
        //                   }).toList(),
        //                 ),
        //         ),
        //         const SizedBox(height: 10),
        //         Text(
        //           'Product Name',
        //           style: lightTextTheme.bodyMedium!.copyWith(
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //         Container(
        //           alignment: Alignment.centerLeft,
        //           child: addTransactionController.products.isEmpty
        //               ? const Center(child: CircularProgressIndicator())
        //               : DropdownButton<String>(
        //                   dropdownColor: primaryColor3,
        //                   value: addTransactionController.selectedProductId.value,
        //                   hint: Text(
        //                     'Select a product',
        //                     style: lightTextTheme.headlineMedium
        //                         ?.copyWith(fontSize: 16, color: secondaryColor),
        //                   ),
        //                   onChanged: (String? newValue) {
        //                     addTransactionController.selectedProductId.value =
        //                         newValue!;
        //                   },
        //                   items: addTransactionController.products
        //                       .map((Product product) {
        //                     return DropdownMenuItem<String>(
        //                       value: product.productId,
        //                       child: Text(
        //                         product.productName,
        //                         style: lightTextTheme.headlineMedium
        //                             ?.copyWith(fontSize: 16, color: textColor),
        //                       ),
        //                     );
        //                   }).toList(),
        //                 ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
