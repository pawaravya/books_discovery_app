import 'package:books_discovery_app/core/constants/AppUrl.dart';
import 'package:books_discovery_app/core/services/network_api_services.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeRepository {
  NetworkAPIServices networkAPIServices = NetworkAPIServices();
  Future<dynamic> fetchBooks(
    BuildContext context, {
    String query = '',
    String scannerSearch = "",
    required int offset,
    required int limit,
  }) async {
    String url = "";
    if (query != "" || scannerSearch.isEmpty) {
      url =
          "${Appurl.booksSerachApi}$query&startIndex=$offset&maxResults=$limit";
    } else {
      final isNumeric = RegExp(r'^\d+$').hasMatch(scannerSearch);

      if (isNumeric) {
        url =
            "${Appurl.booksIsbnSearchApi}$query&startIndex=$offset&maxResults=$limit";
      } else {
        url =
            "${Appurl.booksTitleSearchApi}$query&startIndex=$offset&maxResults=$limit";
      }
    }
    return networkAPIServices.generateGetAPIResponse(context, url);
  }
}
