import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';
import 'package:personal_financial_management/app/components/icons/my_icons.dart';
import 'package:personal_financial_management/app/components/widgets/ShowCustomDialog.dart';
import 'package:personal_financial_management/domain/blocs/home_bloc/home_bloc.dart';
import 'package:personal_financial_management/domain/cubits/category/category_cubit.dart';

typedef void ParentCallback(Object val);

class CateGoriesSeletor extends StatefulWidget {
  CateGoriesSeletor({
    Key? key,
    required this.categories,
    this.parentCallback,
    this.parentKey = 'none',
    this.categoryType = 'none',
    this.itemId = '',
  }) : super(key: key);
  late Map<String, Widget> categories;
  final String itemId;
  final String parentKey;
  final String categoryType;
  ParentCallback? parentCallback;
  @override
  State<CateGoriesSeletor> createState() => _CateGoriesSeletorState();
}

class _CateGoriesSeletorState extends State<CateGoriesSeletor> {
  late String defaultDropdownValue = 'Chọn danh mục';
  TextEditingController _newCategoryName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late final dropdownKey;
  @override
  void initState() {
    super.initState();
    dropdownKey = GlobalKey();
    if (widget.categories.isNotEmpty) {
      defaultDropdownValue = widget.categories.keys.first;
    }
    if (widget.categoryType == 'category' || widget.categoryType == 'income') {
      widget.categories['Thêm danh mục'] = Icon(
        Icons.add,
        color: MyAppColors.gray800,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.categoryType);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
            color: MyAppColors.gray600, style: BorderStyle.solid, width: 0.80),
      ),
      child: widget.categories.isEmpty
          ? DropdownButtonHideUnderline(
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: DropdownButton(
                  onChanged: null,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      child: Container(
                          margin: const EdgeInsets.only(left: 82),
                          child:
                              const Text('Không có danh mục nào để hiện thị')),
                    ),
                  ],
                ),
              ),
            )
          : DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                padding: EdgeInsets.zero,
                child: DropdownButton<String>(
                  value: defaultDropdownValue,
                  key: dropdownKey,
                  icon: MyAppIcons.arrowDropDown,
                  elevation: 16,
                  isExpanded: true,
                  alignment: Alignment.center,
                  underline: null,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (newValue) {
                    setState(() {
                      defaultDropdownValue = newValue!;
                    });
                  },
                  items: widget.categories.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    if (value == 'Thêm danh mục') {
                      return DropdownMenuItem<String>(
                        value: 'none',
                        child: RadioListTile(
                          groupValue: defaultDropdownValue,
                          selected: false,
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: 'none',
                          secondary: const Icon(
                            Icons.add,
                            color: MyAppColors.gray800,
                          ),
                          title: const Text(
                            'Thêm danh mục',
                            textAlign: TextAlign.start,
                          ),
                          onChanged: (newValue) {
                            showNewCategoryDialog(context);
                          },
                        ),
                      );
                    }
                    return DropdownMenuItem<String>(
                      value: value,
                      child: RadioListTile(
                        groupValue: defaultDropdownValue,
                        selected: defaultDropdownValue == value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: value,
                        secondary: widget.categories[value],
                        title: Text(
                          value,
                          textAlign: TextAlign.start,
                        ),
                        onChanged: (newValue) {
                          if (widget.parentCallback != null) {
                            widget.parentCallback!({
                              'parentKey': widget.parentKey,
                              'value': newValue,
                              'selectorType': widget.categoryType,
                            });
                          }
                          setState(() {
                            defaultDropdownValue = newValue.toString();
                            Navigator.pop(dropdownKey.currentContext!);
                          });
                        },
                      ),
                    );
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return widget.categories.keys.map((String value) {
                      return ListTile(
                        title: Text(value),
                        leading: widget.categories[value],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
    );
    ;
  }

  void showNewCategoryDialog(BuildContext categoryContext) {
    showDialog(
        context: context,
        builder: (categoryContext) {
          return BlocProvider(
            create: (context) => CategoryCubit(),
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is CategoryCreating) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return AlertDialog(
                  content: Stack(
                    clipBehavior: Clip.antiAlias,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: MyAppColors.accent700,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1, color: MyAppColors.accent800)),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                controller: _newCategoryName,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: const OutlineInputBorder(),
                                  focusColor: MyAppColors.accent800,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyAppColors.accent800,
                                          width: 1)),
                                  labelText: 'Loại mới',
                                  hintText: 'Nhập tên loại mới',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 26),
                                    child: MyAppIcons.vnd,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 4,
                                        primary: MyAppColors.accent800,
                                        alignment: Alignment.center),
                                    onPressed: () {
                                      // if _amountController.text is exist in categories list then not add new dropdown item else add new dropdown item
                                      if (_newCategoryName.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Tên loại không được để trống'),
                                            backgroundColor:
                                                MyAppColors.accent800,
                                          ),
                                        );
                                        Navigator.of(context).pop();

                                        return;
                                      }
                                      if (widget.categories
                                          .containsKey(_newCategoryName.text)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Tên loại đã tồn tại, vui lòng chọn tên khác'),
                                            backgroundColor:
                                                MyAppColors.accent800,
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          // add new category to categories list at first position of widget.categories
                                          Map<String, Widget> newMap = {
                                            _newCategoryName.text:
                                                MyAppIcons.person
                                          };
                                          newMap.addAll(widget.categories);
                                          widget.categories = newMap;
                                          defaultDropdownValue =
                                              _newCategoryName.text;
                                          Navigator.pop(
                                              dropdownKey.currentContext!);
                                        });
                                      }
                                      BlocProvider.of<CategoryCubit>(context)
                                          .createNewCategory(
                                              categoryName:
                                                  _newCategoryName.text,
                                              isOutput:
                                                  widget.parentKey == 'tab1');

                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'THÊM',
                                            style: TextStyle(
                                              color: MyAppColors.white000,
                                              fontSize: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  void onSaveCategoryTab(BuildContext context) {}
}
