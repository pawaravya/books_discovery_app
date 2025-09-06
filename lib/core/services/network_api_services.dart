
import 'dart:async';
import 'package:books_discovery_app/core/services/base_api_services.dart';
import 'package:books_discovery_app/features/authentication/views/login_screen.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/shared/internet_connection_helper.dart';
import 'package:books_discovery_app/shared/app_logger.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class NetworkAPIServices extends BaseApiServices {
  static bool isHandlingTokenExpiration =
      false; // Add this flag to prevent duplicates
  final Dio dio = Dio();
  final InternetConnectionHelper _internetHelper =
      Get.put<InternetConnectionHelper>(InternetConnectionHelper());

  // GET requests
  @override
  Future<dynamic> generateGetAPIResponse(
    BuildContext context,
    String uri, {
    bool requiredAuthHeader = true,
    bool isAfterRefreshedToken = false,
    Object? data,
  }) async {
    if (!_internetHelper.isInternetConnected.value) {
      return _handleNoInternetError();
    }
    try {
      AppLogger.showInfoLogs('GET: $uri');
      final response = await dio.get(
        uri,
        options: await _buildOptions(requiredAuthHeader),
        data: data,
      );

      return _parseApiResponse(response);
    } catch (e) {
      if (e is DioException &&
          e.response != null &&
          e.response!.statusCode != null &&
          e.response!.statusCode == 401) {
        var refreshTokenResponse = await refreshTokenAPIResonse(context);
        if (refreshTokenResponse == true && isAfterRefreshedToken == false) {
          generateGetAPIResponse(
            context,
            uri,
            requiredAuthHeader: requiredAuthHeader,
            isAfterRefreshedToken: true,
          );
        } else {
          handleTokenExpiredFunctionality(context);
        }
      } else {
        return _handleError(e);
      }
    }
  }

  // POST requests
  @override
  Future<dynamic> generatePostAPIResponse(
    BuildContext context,
    String uri,
    Object postData, {
    bool requiredAuthHeader = false,
    bool isAfterRefreshedToken = false,
  }) async {
    if (!_internetHelper.isInternetConnected.value) {
      return _handleNoInternetError();
    }
    try {
      AppLogger.showInfoLogs('POST: $uri ,PARAMETER: $postData');
      final response = await dio.post(
        uri,
        data: postData,
        options: await _buildOptions(requiredAuthHeader),
      );

      return response.data;
    } catch (e) {
      if (e is DioException &&
          e.response != null &&
          e.response!.statusCode != null &&
          e.response!.statusCode == 401) {
      } else {
        return _handleError(e);
      }
    }
  }

  // PUT request
  @override
  Future<dynamic> generatePutAPIResponse(
    BuildContext context,
    String uri,
    Object postData, {
    bool requiredAuthHeader = true,
    bool isAfterRefreshedToken = false,
  }) async {
    if (!_internetHelper.isInternetConnected.value) {
      return _handleNoInternetError();
    }
    try {
      AppLogger.showInfoLogs('PUT: $uri,PARAMETER: $postData');
      final response = await dio.put(
        uri,
        data: postData,
        options: await _buildOptions(requiredAuthHeader),
      );
      return _parseApiResponse(response);
    } catch (e) {
      if (e is DioException &&
          e.response != null &&
          e.response!.statusCode != null &&
          e.response!.statusCode == 401) {
        var refreshTokenResponse = await refreshTokenAPIResonse(context);
        if (refreshTokenResponse == true && isAfterRefreshedToken == false) {
          generatePutAPIResponse(
            context,
            uri,
            postData,
            requiredAuthHeader: requiredAuthHeader,
            isAfterRefreshedToken: true,
          );
        } else {
          handleTokenExpiredFunctionality(context);
        }
      } else {
        return _handleError(e);
      }
    }
  }

  // DELETE request
  @override
  Future<dynamic> generateDeleteAPIResponse(
    BuildContext context,
    String uri,
    Object? postData, {
    bool requiredAuthHeader = true,
    bool isAfterRefreshedToken = false,
  }) async {
    if (!_internetHelper.isInternetConnected.value) {
      return _handleNoInternetError();
    }
    try {
      AppLogger.showInfoLogs('DELETE: $uri,PARAMETER: $postData');
      final response = await dio.delete(
        uri,
        data: postData,
        options: await _buildOptions(requiredAuthHeader),
      );
      return _parseApiResponse(response);
    } catch (e) {
      if (e is DioException &&
          e.response != null &&
          e.response!.statusCode != null &&
          e.response!.statusCode == 401) {
        var refreshTokenResponse = await refreshTokenAPIResonse(context);
        if (refreshTokenResponse == true && isAfterRefreshedToken == false) {
          generateDeleteAPIResponse(
            context,
            uri,
            postData,
            requiredAuthHeader: requiredAuthHeader,
            isAfterRefreshedToken: true,
          );
        } else {
          handleTokenExpiredFunctionality(context);
        }
      } else {
        return _handleError(e);
      }
    }
  }

  @override
  Future<dynamic> refreshTokenAPIResonse(BuildContext context) async {
    if (!_internetHelper.isInternetConnected.value) {
      _handleNoInternetError();
      return false;
    }
    // try {
    //   final response = await dio.post(
    //     AppUrl.refreshTokenUrl,
    //     options: await _buildOptions(true),
    //   );
    //   AppLogger.showInfoLogs("REFRESHTOKENRESPONSE ::: $response");

    //   if (response.statusCode != null &&
    //       response.statusCode == 200 &&
    //       response.data != null &&
    //       response.data['token'] != null &&
    //       response.data['token'] != "") {
    //     AppSharedPreferences.customSharedPreferences.saveValue(
    //       authToken,
    //       response.data['token'],
    //     );
    //     return true;
    //   }
    // } catch (e) {
    //   AppLogger.showInfoLogs("REFRESHTOKENERROR ::: $e");

    //   _handleError(e);
    //   return false;
    // }
  }

  static void handleTokenExpiredFunctionality(BuildContext context) {
    if (isHandlingTokenExpiration) return; // Prevent duplicate calls
    isHandlingTokenExpiration = true;
    AppViewUtils.showSnackBar("Token Expired", isError: true);
    AppSharedPreferences.customSharedPreferences.clearSharedPreference();

    // Navigate to HomeBottomBar and clear the stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Clears all previous routes
    );
  }

  Future<Options> _buildOptions(
    bool requiredAuthHeader, {
    String? contentType,
  }) async {
    return Options(
      headers: await _getHeaders(requiredAuthHeader),
      sendTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 15000),
      contentType: contentType ?? 'application/json',
    );
  }

  Future<Map<String, dynamic>> _getHeaders(bool requiredAuthHeader) async {
    var token = "" ; // TODO
    // AppSharedPreferences.customSharedPreferences.getValue<String>(
    //   authToken,
    // );

    AppLogger.showInfoLogs("TOKEN ::: $token");

    try {
      if (token != null && requiredAuthHeader) {
        return {
          "Authorization": 'Bearer $token',
          "Content-Type": "application/json",
        };
      } else {
        return {"Content-Type": "application/json"};
      }
    } catch (e) {
      AppLogger.showErrorLogs(e.toString());
      return {};
    }
  }

  // Helper: Parse API response
  dynamic _parseApiResponse(Response response) {
    switch (response.statusCode) {
      case 200 || 201:
        return response.data;
      case 500 || 400 || 422 || 404:
        return response.data;
      case 429:
        return response.data;
      case 401:
        _handleUnAuthorizedError();
        return '';
      case 403:
        return response.data;
      default:
        AppLogger.showErrorLogs(
          "Response Statuscode Decode Failed ${response.data.toString()}",
        );
        return '';
    }
  }

  dynamic _handleNoInternetError() {
    AppLogger.showErrorLogs('No internet connection.');
    return {'error': 'No internet connection'};
  }

  dynamic _handleUnAuthorizedError() {
    AppLogger.showErrorLogs('Token Expired');
   
    return {'error': 'Token Expired.'};
  }

  dynamic _handleError(Object e) {
    if (e is DioError) {
      if (e.type == DioErrorType.receiveTimeout) {
        AppLogger.showErrorLogs('Request timed out');
        AppViewUtils.showSnackBar('Request timed out', isError: true);
        throw TimeoutException('Request timed out');
      } else if (e.response != null) {
        AppLogger.showErrorLogs('API Error: ${e.response?.statusCode}');
        return _parseApiResponse(e.response!);
      }
    } else {
      AppLogger.showErrorLogs('Unknown error: ${e.toString()}');
    }
  }
}
