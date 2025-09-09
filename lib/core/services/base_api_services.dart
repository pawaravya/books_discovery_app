import 'package:flutter/material.dart';

/// basic api service
abstract class BaseApiServices {
  Future<dynamic> generateGetAPIResponse(  BuildContext context, String uri);
  Future<dynamic> generatePostAPIResponse(
    BuildContext context,
    String uri,
    Object postData,
  );
  Future<dynamic> generatePutAPIResponse(
    BuildContext context,
    String uri,
    Object postData,
  );
  Future<dynamic> generateDeleteAPIResponse(
    BuildContext context,
    String uri,
    Object? postData,
  );

  Future<dynamic> refreshTokenAPIResonse(BuildContext context);
}
