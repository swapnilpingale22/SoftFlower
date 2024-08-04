import 'package:animate_do/animate_do.dart';
import 'package:expense_manager/Features/agent/controller/edit_agent_controller.dart';
import 'package:expense_manager/Features/agent/screens/add_agent_screen.dart';
import 'package:expense_manager/Features/agent/screens/edit_agent_alert_box.dart';
import 'package:expense_manager/Features/transactions/controller/add_transaction_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          'Agents',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor3,
        child: const Icon(Icons.add, size: 28),
        onPressed: () => Get.to(
          () => const AddAgentScreen(),
        ),
      ),
      body: Obx(
        () => addTransactionController.isLoading.value == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: addTransactionController.agents.length,
                        itemBuilder: (context, index) {
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
                                title: Text(
                                  addTransactionController
                                      .agents[index].agentName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Motor Rent: ${addTransactionController.agents[index].motorRent}  \nCoolie: ${addTransactionController.agents[index].coolie} \nJaga Bhade: ${addTransactionController.agents[index].jagaBhade} \nPostage: ${addTransactionController.agents[index].postage} \nCaret: ${addTransactionController.agents[index].caret} \nCity: ${addTransactionController.agents[index].agentCity}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: primaryColor3,
                                          child: InkWell(
                                            onTap: () async =>
                                                await showEditAgentDialog(
                                              context,
                                              editAgentController,
                                              addTransactionController
                                                  .agents[index],
                                            ),
                                            child: const Icon(
                                              Icons.edit_note_outlined,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        CircleAvatar(
                                          backgroundColor: primaryColor3,
                                          child: InkWell(
                                            onTap: () {
                                              addTransactionController
                                                  .showDeleteDialog(
                                                agentId:
                                                    addTransactionController
                                                        .agents[index].agentId,
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
