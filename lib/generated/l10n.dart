// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Income`
  String get income {
    return Intl.message(
      'Income',
      name: 'income',
      desc: '',
      args: [],
    );
  }

  /// `Expenditure`
  String get expenditure {
    return Intl.message(
      'Expenditure',
      name: 'expenditure',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Tag`
  String get tag {
    return Intl.message(
      'Tag',
      name: 'tag',
      desc: '',
      args: [],
    );
  }

  /// `Budget`
  String get budget {
    return Intl.message(
      'Budget',
      name: 'budget',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Expand`
  String get expand {
    return Intl.message(
      'Expand',
      name: 'expand',
      desc: '',
      args: [],
    );
  }

  /// `Icon`
  String get icon {
    return Intl.message(
      'Icon',
      name: 'icon',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Category Name`
  String get categoryName {
    return Intl.message(
      'Category Name',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter a name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Select Day`
  String get selectDay {
    return Intl.message(
      'Select Day',
      name: 'selectDay',
      desc: '',
      args: [],
    );
  }

  /// `Select Time`
  String get selectTime {
    return Intl.message(
      'Select Time',
      name: 'selectTime',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `No category selected`
  String get notSelectCategory {
    return Intl.message(
      'No category selected',
      name: 'notSelectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Amount not filled`
  String get notFillAmount {
    return Intl.message(
      'Amount not filled',
      name: 'notFillAmount',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notify {
    return Intl.message(
      'Notification',
      name: 'notify',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete?`
  String get deleteCheck {
    return Intl.message(
      'Do you want to delete?',
      name: 'deleteCheck',
      desc: '',
      args: [],
    );
  }

  /// `Add Success!`
  String get addSuccess {
    return Intl.message(
      'Add Success!',
      name: 'addSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Format error`
  String get errorFormat {
    return Intl.message(
      'Format error',
      name: 'errorFormat',
      desc: '',
      args: [],
    );
  }

  /// `Amount cannot be 0`
  String get cantBe0 {
    return Intl.message(
      'Amount cannot be 0',
      name: 'cantBe0',
      desc: '',
      args: [],
    );
  }

  /// `Edit Successful!`
  String get editSuccess {
    return Intl.message(
      'Edit Successful!',
      name: 'editSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `This week`
  String get thisWeek {
    return Intl.message(
      'This week',
      name: 'thisWeek',
      desc: '',
      args: [],
    );
  }

  /// `This month`
  String get thisMonth {
    return Intl.message(
      'This month',
      name: 'thisMonth',
      desc: '',
      args: [],
    );
  }

  /// `This year`
  String get thisYear {
    return Intl.message(
      'This year',
      name: 'thisYear',
      desc: '',
      args: [],
    );
  }

  /// `Customize...`
  String get customize {
    return Intl.message(
      'Customize...',
      name: 'customize',
      desc: '',
      args: [],
    );
  }

  /// `Fixed Income and Budget`
  String get inAndOut {
    return Intl.message(
      'Fixed Income and Budget',
      name: 'inAndOut',
      desc: '',
      args: [],
    );
  }

  /// `No budget set`
  String get noBudget {
    return Intl.message(
      'No budget set',
      name: 'noBudget',
      desc: '',
      args: [],
    );
  }

  /// `Set Budget`
  String get setBudget {
    return Intl.message(
      'Set Budget',
      name: 'setBudget',
      desc: '',
      args: [],
    );
  }

  /// `Click here to set budget`
  String get clickSetBudget {
    return Intl.message(
      'Click here to set budget',
      name: 'clickSetBudget',
      desc: '',
      args: [],
    );
  }

  /// `No record`
  String get noRecord {
    return Intl.message(
      'No record',
      name: 'noRecord',
      desc: '',
      args: [],
    );
  }

  /// `each month`
  String get eachMonth {
    return Intl.message(
      'each month',
      name: 'eachMonth',
      desc: '',
      args: [],
    );
  }

  /// `...before`
  String get longBefore {
    return Intl.message(
      '...before',
      name: 'longBefore',
      desc: '',
      args: [],
    );
  }

  /// `before`
  String get before {
    return Intl.message(
      'before',
      name: 'before',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save1 {
    return Intl.message(
      'save',
      name: 'save1',
      desc: '',
      args: [],
    );
  }

  /// `start`
  String get start {
    return Intl.message(
      'start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Please select a start time`
  String get notFillStartTime {
    return Intl.message(
      'Please select a start time',
      name: 'notFillStartTime',
      desc: '',
      args: [],
    );
  }

  /// `Please select an end time`
  String get notFillEndTime {
    return Intl.message(
      'Please select an end time',
      name: 'notFillEndTime',
      desc: '',
      args: [],
    );
  }

  /// `End time must not be earlier than start time`
  String get endBeforeStart {
    return Intl.message(
      'End time must not be earlier than start time',
      name: 'endBeforeStart',
      desc: '',
      args: [],
    );
  }

  /// `Amount format error`
  String get amountFormatError {
    return Intl.message(
      'Amount format error',
      name: 'amountFormatError',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message(
      'month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `year`
  String get year {
    return Intl.message(
      'year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `balance`
  String get balance {
    return Intl.message(
      'balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `total`
  String get total {
    return Intl.message(
      'total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Budget Balance`
  String get budgetLeft {
    return Intl.message(
      'Budget Balance',
      name: 'budgetLeft',
      desc: '',
      args: [],
    );
  }

  /// `Fixed Income`
  String get fixedIncome {
    return Intl.message(
      'Fixed Income',
      name: 'fixedIncome',
      desc: '',
      args: [],
    );
  }

  /// `period`
  String get period {
    return Intl.message(
      'period',
      name: 'period',
      desc: '',
      args: [],
    );
  }

  /// `Everyday`
  String get eachDay {
    return Intl.message(
      'Everyday',
      name: 'eachDay',
      desc: '',
      args: [],
    );
  }

  /// `Every Year`
  String get eachYear {
    return Intl.message(
      'Every Year',
      name: 'eachYear',
      desc: '',
      args: [],
    );
  }

  /// `o'clock`
  String get oClock {
    return Intl.message(
      'o\'clock',
      name: 'oClock',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
