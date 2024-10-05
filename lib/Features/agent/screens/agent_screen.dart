import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/agent/controller/edit_agent_controller.dart';
import 'package:expense_manager/Features/agent/screens/add_agent_screen.dart';
import 'package:expense_manager/Features/agent/screens/edit_agent_alert_box.dart';
import 'package:expense_manager/Features/transactions/controller/add_transaction_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import '../../transactions/screens/reports_screen.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  AddTransactionController addTransactionController =
      Get.put(AddTransactionController());

  EditAgentController editAgentController = Get.put(EditAgentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Farmers',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
        actions: [
          const SizedBox(width: 50),
          Expanded(
            child: SearchBarAnimation(
              buttonColour: primaryColor3,
              searchBoxColour: primaryColor1,
              hintText: 'Search farmer',
              durationInMilliSeconds: 500,
              isSearchBoxOnRightSide: true,
              textEditingController:
                  addTransactionController.searchAgentController.value,
              isOriginalAnimation: false,
              enableKeyboardFocus: true,
              buttonBorderColour: Colors.black45,
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              onFieldSubmitted: (String value) {
                addTransactionController.searchAgentByName(value);
              },
              onChanged: (String value) {
                addTransactionController.searchAgentByName(value);
              },
              onPressButton: (isSearchBarOpens) {
                addTransactionController.searchAgentController.value.clear();
                addTransactionController.filteredAgents.value =
                    addTransactionController.agents;
                // log('do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
              },
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor3,
        child: const Icon(Icons.add, size: 28),
        onPressed: () => Get.to(
          () => const AddAgentScreen(),
        ),
      ),
      body: Obx(
        () => addTransactionController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : addTransactionController.agents.isEmpty
                ? Center(
                    child: Text(
                      "No data available",
                      style: lightTextTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  )
                : addTransactionController.filteredAgents.isEmpty
                    ? Center(
                        child: Text(
                          "No results found",
                          style: lightTextTheme.headlineMedium?.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: addTransactionController
                                    .filteredAgents.length,
                                itemBuilder: (context, index) {
                                  final agent = addTransactionController
                                      .filteredAgents[index];
                                  return ZoomIn(
                                    child: Card(
                                      color: primaryColor2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 20),
                                      elevation: 4,
                                      child: ListTile(
                                        isThreeLine: true,
                                        title: Row(
                                          children: [
                                            Text(
                                              "${agent.agentName}, ",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              agent.agentCity,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  CustomRow(
                                                    title: 'Motor Rent:',
                                                    value: agent.motorRent
                                                        .toStringAsFixed(2),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomRow(
                                                    title: 'Coolie:',
                                                    value: agent.coolie
                                                        .toStringAsFixed(2),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomRow(
                                                    title: 'Jaga Bhade:',
                                                    value: agent.jagaBhade
                                                        .toStringAsFixed(2),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomRow(
                                                    title: 'Postage:',
                                                    value: agent.postage
                                                        .toStringAsFixed(2),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomRow(
                                                    title: 'Caret:',
                                                    value: agent.caret
                                                        .toStringAsFixed(2),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  // CustomRow(
                                                  //   title: 'City:',
                                                  //   value: agent.agentCity,
                                                  //   fontWeight: FontWeight.bold,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            // Text(
                                            //   'Motor Rent: ${agent.motorRent}  \nCoolie: ${agent.coolie} \nJaga Bhade: ${agent.jagaBhade} \nPostage: ${agent.postage} \nCaret: ${agent.caret} \nCity: ${agent.agentCity}',
                                            //   style: const TextStyle(
                                            //     color: Colors.black54,
                                            //   ),
                                            // ),
                                            Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      primaryColor3,
                                                  child: InkWell(
                                                    onTap: () async =>
                                                        await showEditAgentDialog(
                                                      context,
                                                      editAgentController,
                                                      agent,
                                                    ),
                                                    child: const Icon(
                                                      Icons.edit_note_outlined,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      primaryColor3,
                                                  child: InkWell(
                                                    onTap: () {
                                                      addTransactionController
                                                          .showDeleteDialog(
                                                        agentId: agent.agentId,
                                                        collectionName: 'agent',
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.delete_forever,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // trailing: Column(
                                        //   mainAxisAlignment: MainAxisAlignment.end,
                                        //   crossAxisAlignment: CrossAxisAlignment.end,
                                        //   children: [
                                        //     Expanded(
                                        //       child: InkWell(
                                        //         onTap: () {},
                                        //         child:
                                        //             const Icon(Icons.edit_note_outlined),
                                        //       ),
                                        //     ),
                                        //     const SizedBox(height: 10),
                                        //     Expanded(
                                        //       child: CircleAvatar(
                                        //         minRadius: 20,
                                        //         backgroundColor: primaryColor3,
                                        //         maxRadius: 20,
                                        //         child: InkWell(
                                        //           onTap: () {},
                                        //           child: const Icon(Icons.delete_forever),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
