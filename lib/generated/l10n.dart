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

  /// `Spending`
  String get expenditure {
    return Intl.message(
      'Spending',
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

  /// `Confirm`
  String get ok {
    return Intl.message(
      'Confirm',
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

  /// `Uncategory`
  String get unCategory {
    return Intl.message(
      'Uncategory',
      name: 'unCategory',
      desc: '',
      args: [],
    );
  }

  /// `There is a record using this category in your account book. If you delete this category, the item will be classified as 'Uncategory'`
  String get toUnCategory {
    return Intl.message(
      'There is a record using this category in your account book. If you delete this category, the item will be classified as \'Uncategory\'',
      name: 'toUnCategory',
      desc: '',
      args: [],
    );
  }

  /// `View items`
  String get showRecord {
    return Intl.message(
      'View items',
      name: 'showRecord',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `No Tag`
  String get noTag {
    return Intl.message(
      'No Tag',
      name: 'noTag',
      desc: '',
      args: [],
    );
  }

  /// `Time Scale`
  String get timeScale {
    return Intl.message(
      'Time Scale',
      name: 'timeScale',
      desc: '',
      args: [],
    );
  }

  /// `Data Source`
  String get dataType {
    return Intl.message(
      'Data Source',
      name: 'dataType',
      desc: '',
      args: [],
    );
  }

  /// `Incoming and Spending`
  String get inOut {
    return Intl.message(
      'Incoming and Spending',
      name: 'inOut',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Please choose a time`
  String get plzChooseTime {
    return Intl.message(
      'Please choose a time',
      name: 'plzChooseTime',
      desc: '',
      args: [],
    );
  }

  /// `Chart`
  String get chart {
    return Intl.message(
      'Chart',
      name: 'chart',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Backup`
  String get backup {
    return Intl.message(
      'Backup',
      name: 'backup',
      desc: '',
      args: [],
    );
  }

  /// `Backup Time`
  String get backupTime {
    return Intl.message(
      'Backup Time',
      name: 'backupTime',
      desc: '',
      args: [],
    );
  }

  /// `none`
  String get none {
    return Intl.message(
      'none',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `download`
  String get download {
    return Intl.message(
      'download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Your data will be overwritten and cannot be recovered. Do you want to continue?`
  String get overwriteInfo {
    return Intl.message(
      'Your data will be overwritten and cannot be recovered. Do you want to continue?',
      name: 'overwriteInfo',
      desc: '',
      args: [],
    );
  }

  /// `We will use your google drive to store your account data. After the backup is completed, a "accountingData.act" file will be generated on your google drive. Please do not modify or move this file to Make sure the backup function is normal, if you want to remove the backup data, you need to delete the files completely (including the files in the trash)`
  String get googleDriveInfo {
    return Intl.message(
      'We will use your google drive to store your account data. After the backup is completed, a "accountingData.act" file will be generated on your google drive. Please do not modify or move this file to Make sure the backup function is normal, if you want to remove the backup data, you need to delete the files completely (including the files in the trash)',
      name: 'googleDriveInfo',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get notification {
    return Intl.message(
      'Reminder',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get repeat {
    return Intl.message(
      'Repeat',
      name: 'repeat',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get sunday {
    return Intl.message(
      'Sunday',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get mon {
    return Intl.message(
      'Mon',
      name: 'mon',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get tue {
    return Intl.message(
      'Tue',
      name: 'tue',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get wed {
    return Intl.message(
      'Wed',
      name: 'wed',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get thu {
    return Intl.message(
      'Thu',
      name: 'thu',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get fri {
    return Intl.message(
      'Fri',
      name: 'fri',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get sat {
    return Intl.message(
      'Sat',
      name: 'sat',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sun {
    return Intl.message(
      'Sun',
      name: 'sun',
      desc: '',
      args: [],
    );
  }

  /// `A penny saved is a penny earned`
  String get slang1 {
    return Intl.message(
      'A penny saved is a penny earned',
      name: 'slang1',
      desc: '',
      args: [],
    );
  }

  /// `Saving for a rainy day`
  String get slang2 {
    return Intl.message(
      'Saving for a rainy day',
      name: 'slang2',
      desc: '',
      args: [],
    );
  }

  /// `Money doesn’t grow on trees.`
  String get slang3 {
    return Intl.message(
      'Money doesn’t grow on trees.',
      name: 'slang3',
      desc: '',
      args: [],
    );
  }

  /// `Start saving now!`
  String get savingNow {
    return Intl.message(
      'Start saving now!',
      name: 'savingNow',
      desc: '',
      args: [],
    );
  }

  /// `Export Excel`
  String get exportExcel {
    return Intl.message(
      'Export Excel',
      name: 'exportExcel',
      desc: '',
      args: [],
    );
  }

  /// `Start Export`
  String get startExport {
    return Intl.message(
      'Start Export',
      name: 'startExport',
      desc: '',
      args: [],
    );
  }

  /// `Exporting`
  String get exporting {
    return Intl.message(
      'Exporting',
      name: 'exporting',
      desc: '',
      args: [],
    );
  }

  /// `Export your ledger to Excel`
  String get exportInfo {
    return Intl.message(
      'Export your ledger to Excel',
      name: 'exportInfo',
      desc: '',
      args: [],
    );
  }

  /// `Export complete`
  String get finishExport {
    return Intl.message(
      'Export complete',
      name: 'finishExport',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Please go to "Download" in your phone's storage to view the exported file, or click "Share" to share your file to your group or cloud`
  String get finishExportInfo {
    return Intl.message(
      'Please go to "Download" in your phone\'s storage to view the exported file, or click "Share" to share your file to your group or cloud',
      name: 'finishExportInfo',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Please select the type of feedback you want`
  String get feedbackType {
    return Intl.message(
      'Please select the type of feedback you want',
      name: 'feedbackType',
      desc: '',
      args: [],
    );
  }

  /// `Please explain your question or feedback`
  String get explainFeedback {
    return Intl.message(
      'Please explain your question or feedback',
      name: 'explainFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Your Content`
  String get yorContent {
    return Intl.message(
      'Your Content',
      name: 'yorContent',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the type`
  String get typeEmpty {
    return Intl.message(
      'Please enter the type',
      name: 'typeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter content`
  String get contentEmpty {
    return Intl.message(
      'Please enter content',
      name: 'contentEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Please enter...`
  String get enter {
    return Intl.message(
      'Please enter...',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `Suggestions for improvement`
  String get recommendation {
    return Intl.message(
      'Suggestions for improvement',
      name: 'recommendation',
      desc: '',
      args: [],
    );
  }

  /// `Error report`
  String get errorReport {
    return Intl.message(
      'Error report',
      name: 'errorReport',
      desc: '',
      args: [],
    );
  }

  /// `Usage Problem`
  String get usageProblem {
    return Intl.message(
      'Usage Problem',
      name: 'usageProblem',
      desc: '',
      args: [],
    );
  }

  /// `Other...`
  String get other {
    return Intl.message(
      'Other...',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `your nickname`
  String get yourName {
    return Intl.message(
      'your nickname',
      name: 'yourName',
      desc: '',
      args: [],
    );
  }

  /// `your E-mail`
  String get yourEmail {
    return Intl.message(
      'your E-mail',
      name: 'yourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Remove Ad`
  String get removeAd {
    return Intl.message(
      'Remove Ad',
      name: 'removeAd',
      desc: '',
      args: [],
    );
  }

  /// `We hope that a certain level of advertising can be placed without affecting the normal use of the APP to maintain basic income. If you feel that advertising is annoying, you can choose to buy a plan to remove advertising. At the same time, It is also our support. If you still feel that you have unreasonable or other suggestions, please use "feedback"report.`
  String get removeAdInfo {
    return Intl.message(
      'We hope that a certain level of advertising can be placed without affecting the normal use of the APP to maintain basic income. If you feel that advertising is annoying, you can choose to buy a plan to remove advertising. At the same time, It is also our support. If you still feel that you have unreasonable or other suggestions, please use "feedback"report.',
      name: 'removeAdInfo',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get subscription {
    return Intl.message(
      'Subscribe',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Subscribing`
  String get subscribing {
    return Intl.message(
      'Subscribing',
      name: 'subscribing',
      desc: '',
      args: [],
    );
  }

  /// `Your cloud data will be overwritten and cannot be recovered. Do you want to continue?`
  String get backupInfo {
    return Intl.message(
      'Your cloud data will be overwritten and cannot be recovered. Do you want to continue?',
      name: 'backupInfo',
      desc: '',
      args: [],
    );
  }

  /// `Upload successful`
  String get uploadSuccess {
    return Intl.message(
      'Upload successful',
      name: 'uploadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Download successful`
  String get downloadSuccess {
    return Intl.message(
      'Download successful',
      name: 'downloadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get error {
    return Intl.message(
      'An error occurred',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribe`
  String get unSubscribe {
    return Intl.message(
      'Unsubscribe',
      name: 'unSubscribe',
      desc: '',
      args: [],
    );
  }

  /// `Update Info`
  String get updateInfo {
    return Intl.message(
      'Update Info',
      name: 'updateInfo',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `There is a new version`
  String get newVersion {
    return Intl.message(
      'There is a new version',
      name: 'newVersion',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Fixed income and spending will be automatically added to your ledger at the date or time you set, you will no longer need to manually add fixed income and Spending.`
  String get fixedInfo {
    return Intl.message(
      'Fixed income and spending will be automatically added to your ledger at the date or time you set, you will no longer need to manually add fixed income and Spending.',
      name: 'fixedInfo',
      desc: '',
      args: [],
    );
  }

  /// `Select Icon`
  String get selectIcon {
    return Intl.message(
      'Select Icon',
      name: 'selectIcon',
      desc: '',
      args: [],
    );
  }

  /// `Long press and drag to change the order`
  String get categoryTutorial {
    return Intl.message(
      'Long press and drag to change the order',
      name: 'categoryTutorial',
      desc: '',
      args: [],
    );
  }

  /// `"Widgets" can display your income and spending on your home screen, which is convenient for you to manage your finances. Do you want to view the tutorial?`
  String get appWidgetShow {
    return Intl.message(
      '"Widgets" can display your income and spending on your home screen, which is convenient for you to manage your finances. Do you want to view the tutorial?',
      name: 'appWidgetShow',
      desc: '',
      args: [],
    );
  }

  /// `View Now`
  String get showMeNow {
    return Intl.message(
      'View Now',
      name: 'showMeNow',
      desc: '',
      args: [],
    );
  }

  /// `Understand!`
  String get understand {
    return Intl.message(
      'Understand!',
      name: 'understand',
      desc: '',
      args: [],
    );
  }

  /// `Widgets`
  String get widgets {
    return Intl.message(
      'Widgets',
      name: 'widgets',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get selectAll {
    return Intl.message(
      'Select All',
      name: 'selectAll',
      desc: '',
      args: [],
    );
  }

  /// `We need your file access permission to export the file`
  String get permissionInfo {
    return Intl.message(
      'We need your file access permission to export the file',
      name: 'permissionInfo',
      desc: '',
      args: [],
    );
  }

  /// `Please enable the alarm clock permission so that we can set reminders for you`
  String get openAlarmPermission {
    return Intl.message(
      'Please enable the alarm clock permission so that we can set reminders for you',
      name: 'openAlarmPermission',
      desc: '',
      args: [],
    );
  }

  /// `Add, then continue adding`
  String get addAndToNext {
    return Intl.message(
      'Add, then continue adding',
      name: 'addAndToNext',
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
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'vi'),
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
