import 'package:books_discovery_app/core/constants/AppUrl.dart';
import 'package:books_discovery_app/core/services/network_api_services.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeRepository {
  NetworkAPIServices networkAPIServices = NetworkAPIServices();
  Future<dynamic> fetchBooks(BuildContext context, {String query = ''}) async {
    return networkAPIServices.generateGetAPIResponse(context, Appurl.booksSerachApi);
  }
}
