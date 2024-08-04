// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:expense_manager/utils/colors.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class CustomSingleDropdown extends StatefulWidget {
//   List<DropdownMenuItem<dynamic>> items = [];
//   final dynamic value;
//   final TextEditingController? textEditingController;
//   final dynamic onChanged;
//   final dynamic onChangedCancelBtn;
//   final String hint;
//   final double? dropdownWidth;
//   final bool? isSearchDropdown;
//   final bool? optionalValidator;
//   final bool? requiredCancelBtn;
//   final Color? borderColor;
//   final bool Function(DropdownMenuItem, String)? searchMatchFn;
//   final String? errorMsg;

//   CustomSingleDropdown({
//     super.key,
//     required this.items,
//     required this.value,
//     this.textEditingController,
//     required this.onChanged,
//     this.onChangedCancelBtn,
//     required this.hint,
//     this.dropdownWidth,
//     this.optionalValidator = false,
//     this.isSearchDropdown = false,
//     this.requiredCancelBtn = false,
//     this.searchMatchFn,
//     this.borderColor,
//     this.errorMsg,
//   });

//   @override
//   State<CustomSingleDropdown> createState() => _CustomSingleDropdownState();
// }

// class _CustomSingleDropdownState extends State<CustomSingleDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField2<dynamic>(
//       isExpanded: true,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: (value) {
//         if (widget.optionalValidator == false) {
//           if (value == null) {
//             return 'Please select ${widget.errorMsg}.';
//           } else {
//             return null;
//           }
//         } else {
//           return null;
//         }
//       },
//       buttonStyleData: const ButtonStyleData(
//         height: 30,
//         width: 160,
//         padding: EdgeInsets.only(left: 14, right: 14),
//         elevation: 0,
//       ),
//       decoration: InputDecoration(
//         suffixIcon: (widget.requiredCancelBtn ?? false)
//             ? widget.value != null
//                 ? IconButton(
//                     icon: const Icon(Icons.cancel_outlined),
//                     color: Colors.red,
//                     onPressed: widget.onChangedCancelBtn,
//                   )
//                 : null
//             : null,
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: widget.borderColor ?? primaryColor),
//         ),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: widget.borderColor ?? primaryColor),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: widget.borderColor ?? primaryColor),
//         ),
//       ),
//       style: Theme.of(context).textTheme.bodyLarge,
//       hint: Text(
//         widget.hint,
//         style:
//             Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
//         overflow: TextOverflow.ellipsis,
//       ),
//       items: widget.items,
//       value: widget.value,
//       onChanged: widget.onChanged,
//       iconStyleData: IconStyleData(
//         icon: const Icon(Icons.keyboard_arrow_down_sharp),
//         iconSize: 24,
//         iconEnabledColor: (widget.requiredCancelBtn ?? false)
//             ? widget.value == null
//                 ? primaryColor
//                 : Colors.transparent
//             : primaryColor,
//         iconDisabledColor: (widget.requiredCancelBtn ?? false)
//             ? widget.value == null
//                 ? primaryColor
//                 : Colors.transparent
//             : primaryColor,
//       ),
//       dropdownStyleData: DropdownStyleData(
//         maxHeight: 200,
//         width: widget.dropdownWidth ?? 200,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: primaryColor,
//         ),
//         offset: const Offset(-20, 0),
//         scrollbarTheme: ScrollbarThemeData(
//           radius: const Radius.circular(40),
//           thickness: WidgetStateProperty.all<double>(6),
//           thumbVisibility: WidgetStateProperty.all<bool>(true),
//         ),
//       ),
//       menuItemStyleData: const MenuItemStyleData(
//         height: 40,
//         padding: EdgeInsets.only(left: 14, right: 14),
//       ),
//       dropdownSearchData: widget.isSearchDropdown == true
//           ? DropdownSearchData(
//               searchController: widget.textEditingController,
//               searchInnerWidgetHeight: 50,
//               searchInnerWidget: Container(
//                 height: 50,
//                 padding: const EdgeInsets.only(
//                   top: 8,
//                   bottom: 4,
//                   right: 8,
//                   left: 8,
//                 ),
//                 child: TextFormField(
//                   controller: widget.textEditingController,
//                   keyboardType: TextInputType.text,
//                 ),

//                 // BTextFormField(
//                 //   controller: widget.textEditingController,
//                 //   keyboardType: TextInputType.text,
//                 // ),
//               ),
//               searchMatchFn: widget.searchMatchFn)
//           : null,
//       onMenuStateChange: (isOpen) {
//         if (!isOpen) {
//           widget.textEditingController?.clear();
//         }
//       },
//     );
//   }
// }

// class CommonDropdown extends StatefulWidget {
//   List<DropdownMenuItem<dynamic>> items = [];
//   final dynamic value;
//   final TextEditingController? textEditingController;
//   final dynamic onChanged;
//   final dynamic onChangedCancelBtn;
//   final String hint;
//   final double? dropdownWidth;
//   final bool? isSearchDropdown;
//   final bool? optionalValidator;
//   final bool? requiredCancelBtn;
//   final bool? enable;
//   final bool Function(DropdownMenuItem, String)? searchMatchFn;
//   final String? errorMsg;
//   final bool? filled;
//   final EdgeInsetsGeometry? padding;

//   CommonDropdown({
//     super.key,
//     required this.items,
//     required this.value,
//     this.textEditingController,
//     required this.onChanged,
//     this.onChangedCancelBtn,
//     required this.hint,
//     this.dropdownWidth,
//     this.optionalValidator = false,
//     this.isSearchDropdown = false,
//     this.requiredCancelBtn = false,
//     this.enable,
//     this.searchMatchFn,
//     this.errorMsg,
//     this.filled,
//     this.padding,
//   });

//   @override
//   State<CommonDropdown> createState() => _CommonDropdownState();
// }

// class _CommonDropdownState extends State<CommonDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField2<dynamic>(
//       isExpanded: true,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: (value) {
//         if (widget.optionalValidator == false) {
//           if (value == null) {
//             return 'Please select ${widget.errorMsg}.';
//           } else {
//             return null;
//           }
//         } else {
//           return null;
//         }
//       },
//       buttonStyleData: ButtonStyleData(
//         height: 50,
//         width: 160,
//         padding: widget.padding ?? const EdgeInsets.only(left: 14, right: 14),
//         elevation: 0,
//       ),
//       decoration: InputDecoration(
//         enabled: widget.enable ?? true,
//         labelStyle: Theme.of(context)
//             .textTheme
//             .bodyLarge!
//             .copyWith(color: Colors.white),
//         suffixIcon: (widget.requiredCancelBtn ?? false)
//             ? widget.value != null
//                 ? IconButton(
//                     icon: const Icon(Icons.cancel_outlined),
//                     color: Colors.red,
//                     onPressed: widget.onChangedCancelBtn,
//                   )
//                 : null
//             : null,
//         fillColor: primaryColor,
//         filled: widget.filled ?? true,
//         enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.transparent, width: 0.7),
//             borderRadius: BorderRadius.circular(10)),
//         focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
//             borderRadius: BorderRadius.circular(10)),
//         disabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
//             borderRadius: BorderRadius.circular(10)),
//       ),
//       style: Theme.of(context).textTheme.bodyLarge,
//       hint: Text(
//         widget.hint,
//         style:
//             Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
//         overflow: TextOverflow.ellipsis,
//       ),
//       items: widget.items,
//       value: widget.value,
//       onChanged: widget.onChanged,
//       iconStyleData: IconStyleData(
//         icon: const Icon(Icons.keyboard_arrow_down_sharp),
//         iconSize: 24,
//         iconEnabledColor: (widget.requiredCancelBtn ?? false)
//             ? widget.value == null
//                 ? Colors.white
//                 : Colors.transparent
//             : Colors.white,
//         iconDisabledColor: (widget.requiredCancelBtn ?? false)
//             ? widget.value == null
//                 ? Colors.white
//                 : Colors.transparent
//             : Colors.white,
//       ),
//       dropdownStyleData: DropdownStyleData(
//         maxHeight: 200,
//         width: widget.dropdownWidth ?? 200,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: primaryColor,
//         ),
//         offset: const Offset(-20, 0),
//         scrollbarTheme: ScrollbarThemeData(
//           radius: const Radius.circular(40),
//           thickness: WidgetStateProperty.all<double>(6),
//           thumbVisibility: WidgetStateProperty.all<bool>(true),
//         ),
//       ),
//       menuItemStyleData: const MenuItemStyleData(
//         height: 40,
//         padding: EdgeInsets.only(left: 14, right: 14),
//       ),
//       dropdownSearchData: widget.isSearchDropdown == true
//           ? DropdownSearchData(
//               searchController: widget.textEditingController,
//               searchInnerWidgetHeight: 45,
//               searchInnerWidget: Container(
//                 height: 45,
//                 padding: const EdgeInsets.only(
//                   top: 8,
//                   bottom: 4,
//                   right: 8,
//                   left: 8,
//                 ),
//                 child: TextFormField(
//                   controller: widget.textEditingController,
//                   keyboardType: TextInputType.text,
//                   cursorColor: const Color.fromRGBO(255, 255, 255, 1),
//                   decoration: const InputDecoration(
//                     hintText: "search",
//                     focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white30)),
//                     enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white30)),
//                   ),
//                 ),

//                 // BTextFormField(
//                 //   controller: widget.textEditingController,
//                 //   keyboardType: TextInputType.text,
//                 // ),
//               ),
//               searchMatchFn: widget.searchMatchFn)
//           : null,
//       onMenuStateChange: (isOpen) {
//         if (!isOpen) {
//           widget.textEditingController?.clear();
//         }
//       },
//     );
//   }
// }
