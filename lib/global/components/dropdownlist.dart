import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../assets/global/global.dart';


class YearLevel {
  final String id;
  final String title;

  YearLevel({required this.id, required this.title});

  factory YearLevel.fromJson(Map<String, dynamic> json) {
    return YearLevel(
      id: json['yearLevelID'],
      title: json['yearLevelTitle'],
    );
  }
}

class Course {
  final String id;
  final String title;

  Course({required this.id, required this.title});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['courseID'],
      title: json['courseTitle'],
    );
  }
}





