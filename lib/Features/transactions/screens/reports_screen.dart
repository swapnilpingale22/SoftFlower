import 'package:expense_manager/Features/transactions/controller/reports_controller.dart';
import 'package:expense_manager/utils/colors.dart';
import 'package:expense_manager/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  ReportsController reportsController = Get.put(ReportsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: lightTextTheme.headlineMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: //const CommingSoonScreen(),
          Obx(
        () => reportsController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : reportsController.dataList.isEmpty
                ? Center(
                    child: Text(
                      "No data available",
                      style: lightTextTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortColumnIndex: 1,
                      // sortAscending: true,
                      columns: _createColumns(reportsController.dataList),
                      rows: _createRows(reportsController.dataList),
                    ),
                  ),
      ),
    );
  }

  List<DataColumn> _createColumns(List<Map<String, dynamic>> data) {
    return data.first.keys
        .map((key) => DataColumn(
              label: Text(
                key,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              numeric: true,
            ))
        .toList();
  }

  List<DataRow> _createRows(List<Map<String, dynamic>> data) {
    return data.map((item) {
      return DataRow(
        cells: item.values
            .map((value) => DataCell(Text(value.toString(),
                style: const TextStyle(color: textColor))))
            .toList(),
      );
    }).toList();
  }
}
