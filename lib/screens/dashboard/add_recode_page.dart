import 'package:accounting/app.dart';
import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/db/category_model.dart';
import 'package:accounting/db/record_tag_db.dart';
import 'package:accounting/db/record_tag_model.dart';
import 'package:accounting/db/tag_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/home_widget_provider.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/widget/category_title.dart';
import 'package:accounting/screens/widget/fake_dropdown_button.dart';
import 'package:accounting/screens/widget/tag_title.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddRecodePage extends StatefulWidget {
  final AccountingModel? model;

  const AddRecodePage({Key? key, this.model}) : super(key: key);

  @override
  State<AddRecodePage> createState() => _AddRecodePageState();
}

class _AddRecodePageState extends State<AddRecodePage> {
  List<bool> _selectedIndex = [true, false];
  int currentIndex = 0;

  final TextEditingController amount = TextEditingController();
  String? errorText;
  final TextEditingController note = TextEditingController();

  CategoryModel? currentCategory;

  List<TagModel> tagList = [];

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  void initState() {
    Future.microtask(() async {
      await context.read<MainProvider>().getCategoryList();
      if (!mounted) return;
      await context.read<MainProvider>().getTagList();
      if (widget.model != null) {
        if (widget.model!.amount < 0) {
          _selectedIndex = [false, true];
          currentIndex = 1;
        } else {
          _selectedIndex = [true, false];
          currentIndex = 0;
        }
        if (!mounted) return;
        try {
          currentCategory = context
              .read<MainProvider>()
              .categoryList
              .firstWhere((element) => element.id == widget.model!.category);
        } catch (_) {
          currentCategory = null;
        }
        for (var element in widget.model!.tags) {
          tagList.add(
            context.read<MainProvider>().tagList.firstWhere((e) => e.id == element),
          );
        }
        date = widget.model!.date;
        time = TimeOfDay(
          hour: widget.model!.date.hour,
          minute: widget.model!.date.minute,
        );
        amount.text = widget.model!.amount < 0
            ? (-widget.model!.amount).toString()
            : widget.model!.amount.toString();
        note.text = widget.model!.note;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<MainProvider>(
        builder: (BuildContext context, MainProvider provider, _) {
          ///預算餘額
          double budgetLeft = provider.goalNum;
          double expenditure = 0;
          for (var element in provider.accountingList) {
            if (Utils.checkIsSameMonth(element.date, date)) {
              if (element.amount < 0) {
                expenditure += element.amount;
              }
            }
          }
          budgetLeft += expenditure;
          try {
            if (currentIndex == 1) {
              budgetLeft -= double.parse(amount.text);
            }
          } catch (_) {}

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(widget.model == null ? S.of(context).add : S.of(context).edit),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear),
                )
              ],
            ),
            body: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        if (currentIndex != index) {
                          currentCategory = null;
                        }

                        setState(() {
                          currentIndex = index;
                          for (int i = 0; i < _selectedIndex.length; i++) {
                            _selectedIndex[i] = i == index;
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: currentIndex == 0 ? Colors.blueAccent : Colors.redAccent,
                      selectedColor: Colors.white,
                      fillColor: currentIndex == 0 ? Colors.blueAccent : Colors.redAccent,
                      color: Colors.black54,
                      constraints: BoxConstraints(
                        minHeight: 40.0,
                        minWidth: MediaQuery.of(context).size.width / 2 - 32,
                      ),
                      isSelected: _selectedIndex,
                      children: [
                        Text(S.of(context).income),
                        Text(S.of(context).expenditure),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.book_outlined),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).category} : ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FakeDropDownButton(
                            hint: S.of(context).category,
                            model: currentCategory,
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) => SizedBox(
                                  height: MediaQuery.of(context).size.height / 2,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      Text(
                                        _selectedIndex[0]
                                            ? S.of(context).income
                                            : S.of(context).expenditure,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orangeAccent),
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          shrinkWrap: true,
                                          itemCount: _selectedIndex[0]
                                              ? provider.categoryIncomeList.length
                                              : provider.categoryExpenditureList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  currentCategory = _selectedIndex[0]
                                                      ? provider.categoryIncomeList[index]
                                                      : provider.categoryExpenditureList[index];
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: CategoryTitle(
                                                        model: _selectedIndex[0]
                                                            ? provider.categoryIncomeList[index]
                                                            : provider
                                                                .categoryExpenditureList[index]),
                                                  ),
                                                  if ((_selectedIndex[0]
                                                          ? provider.categoryIncomeList[index].id
                                                          : provider
                                                              .categoryExpenditureList[index].id) ==
                                                      currentCategory?.id)
                                                    const Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    )
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider();
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on_outlined),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).amount} : ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: currentIndex == 0 ? Colors.blueAccent : Colors.redAccent,
                              ),
                            ),
                            child: TextField(
                              controller: amount,
                              cursorColor: currentIndex == 0 ? Colors.blueAccent : Colors.redAccent,
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: currentIndex == 0 ? Colors.blueAccent : Colors.redAccent),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              ],
                              onChanged: (v) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorText: errorText,
                                hintText: S.of(context).amount,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    if (provider.goalNum != -1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${DateFormat('yyyy/MM').format(date)} ${S.of(context).budgetLeft}:',
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontFamily: 'RobotoMono'),
                          ),
                          Text(
                            ' $budgetLeft',
                            style: TextStyle(
                              fontSize: 16,
                              color: budgetLeft < 0 ? Colors.redAccent : Colors.blueAccent,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.local_offer_outlined),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).tag} : ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            children: [
                              for (var element in tagList)
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: element.color),
                                  height: 20,
                                  width: 20,
                                )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (context) => SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                child: ChooseTag(
                                  tagList: tagList,
                                  onCheck: (l) {
                                    setState(() {
                                      tagList = l;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.add),
                              Text(S.of(context).add),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).date} : ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? d = await showDatePicker(
                              cancelText: S.of(context).cancel,
                              confirmText: S.of(context).ok,
                              helpText: S.of(context).selectDay,
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1970),
                              lastDate: DateTime(DateTime.now().year + 100),
                              locale: App.of(context)?.locale ?? const Locale('en', ''),
                            );
                            if (d != null) {
                              setState(() {
                                date = d;
                              });
                            }
                          },
                          child: Text(DateFormat('yyyy/MM/dd').format(date)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.schedule),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).time} : ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? t = await showTimePicker(
                              cancelText: S.of(context).cancel,
                              confirmText: S.of(context).ok,
                              helpText: S.of(context).selectTime,
                              context: context,
                              initialTime: time,
                            );
                            if (t != null) {
                              setState(() {
                                time = t;
                              });
                            }
                          },
                          child: Text(time.format(context)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.edit_note_outlined),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).note} : ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), border: Border.all()),
                      child: TextField(
                        controller: note,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: S.of(context).note,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        saveButton(provider),
                        if (widget.model != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  bool? delete = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(S.of(context).notify),
                                      content: Text(S.of(context).deleteCheck),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            S.of(context).cancel,
                                            style: const TextStyle(color: Colors.black54),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await AccountingDB.deleteData(widget.model!.id!);
                                            await provider.getAccountingList();
                                            if (!mounted) return;
                                            Navigator.pop(context, true);
                                          },
                                          child: Text(S.of(context).ok),
                                        )
                                      ],
                                    ),
                                  );

                                  if (delete ?? false) {
                                    if (!mounted) return;
                                    ///更新widget
                                    context.read<HomeWidgetProvider>().sendAndUpdate();
                                    Navigator.pop(context);
                                  }
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent.shade700,
                                ),
                              )
                            ],
                          )
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget saveButton(MainProvider provider) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
      ),
      onPressed: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (currentCategory == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).notSelectCategory),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        if (amount.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).notFillAmount),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        try {
          double.parse(amount.text);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).amountFormatError),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        if (double.parse(amount.text) == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).cantBe0),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        if (widget.model == null) {
          int? id = await AccountingDB.insertData(
            AccountingModel(
              date: DateTime(date.year, date.month, date.day, time.hour, time.minute),
              category: currentCategory!.id!,
              tags: List.generate(tagList.length, (index) => tagList[index].id!),
              amount: currentIndex == 0 ? double.parse(amount.text) : -double.parse(amount.text),
              note: note.text,
            ),
          );
          if (id != null) {
            await RecordTagDB.deleteData(type: RecordTagType.record, id: id);
            for (var element in tagList) {
              await RecordTagDB.insertData(RecordTagModel(recordId: id, tagId: element.id!));
            }
          }
        } else {
          await AccountingDB.updateData(
            AccountingModel(
              id: widget.model!.id,
              date: DateTime(date.year, date.month, date.day, time.hour, time.minute),
              category: currentCategory!.id!,
              tags: List.generate(tagList.length, (index) => tagList[index].id!),
              amount: currentIndex == 0 ? double.parse(amount.text) : -double.parse(amount.text),
              note: note.text,
            ),
          );

          await RecordTagDB.deleteData(type: RecordTagType.record, id: widget.model!.id!);
          for (var element in tagList) {
            await RecordTagDB.insertData(
                RecordTagModel(recordId: widget.model!.id!, tagId: element.id!));
          }
        }

        provider.getAccountingList();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(widget.model == null ? S.of(context).addSuccess : S.of(context).editSuccess),
            behavior: SnackBarBehavior.floating,
          ),
        );
        ///更新widget
        context.read<HomeWidgetProvider>().sendAndUpdate();
        Navigator.pop(context);
      },
      child: Text(
        S.of(context).save,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class ChooseTag extends StatefulWidget {
  final List<TagModel> tagList;
  final Function(List<TagModel>) onCheck;

  const ChooseTag({Key? key, required this.tagList, required this.onCheck}) : super(key: key);

  @override
  State<ChooseTag> createState() => _ChooseTagState();
}

class _ChooseTagState extends State<ChooseTag> {
  List<TagModel> list = [];

  @override
  void initState() {
    list = widget.tagList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (BuildContext context, MainProvider provider, _) {
      return Column(
        children: [
          const SizedBox(height: 16),
          Text(
            S.of(context).tag,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              itemCount: provider.tagList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (list.indexWhere((element) => element.id == provider.tagList[index].id) !=
                          -1) {
                        list.removeAt(
                            list.indexWhere((element) => element.id == provider.tagList[index].id));
                      } else {
                        list.add(provider.tagList[index]);
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: TagTitle(model: provider.tagList[index]),
                      ),
                      if (list.indexWhere((element) => element.id == provider.tagList[index].id) !=
                          -1)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
            ),
            onPressed: () {
              widget.onCheck(list);
              Navigator.pop(context);
            },
            child: Text(
              S.of(context).ok,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}
