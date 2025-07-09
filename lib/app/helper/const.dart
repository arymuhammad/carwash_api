import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var white = Colors.white;
var initDate1 = DateFormat('yyyy-MM-dd')
    .format(DateTime.parse(
        DateTime(DateTime.now().year, DateTime.now().month, 1).toString()))
    .toString();
var initDate2 = DateFormat('yyyy-MM-dd')
    .format(DateTime.parse(
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0).toString()))
    .toString();