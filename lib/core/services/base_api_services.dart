import 'package:flutter/material.dart';

/// basic api service
abstract class BaseApiServices {
  Future<dynamic> generateGetAPIResponse(
    BuildContext context,
    String uri, {
    bool requiredAuthHeader = true,
  });
  Future<dynamic> generatePostAPIResponse(
    BuildContext context,
    String uri,
    Object postData, {
    bool requiredAuthHeader = true,
  });
  Future<dynamic> generatePutAPIResponse(
    BuildContext context,
    String uri,
    Object postData, {
    bool requiredAuthHeader = true,
  });
  Future<dynamic> generateDeleteAPIResponse(
    BuildContext context,
    String uri,
    Object? postData, {
    bool requiredAuthHeader = true,
  });

  Future<dynamic> refreshTokenAPIResonse(BuildContext context);
}
