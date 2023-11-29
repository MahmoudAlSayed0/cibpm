import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

enum RequestStatus { success, failure }

class DioHelper {
  static const String baseURL = 'http://212.90.120.116:8000/';

  static BaseOptions options = BaseOptions(
    baseUrl: baseURL,
    receiveDataWhenStatusError: true,
  );
  static final Dio dio = Dio(options);

  static Future<Response?>? getRequest(
      {required Map<String, dynamic> parameters}) async {
    Response? response;
    try {
      response = await dio.get(
        baseURL,
        queryParameters: parameters,
      );
      log(response.toString());
    } on SocketException catch (e) {
      log(e.message);
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  static Future<RequestStatus> postRequest(data) async {
    FormData formData = FormData.fromMap(data);
    String postUrl = 'video';

    Response? response;
    try {
      response = await dio.post(
        postUrl,
        data: formData,
      );
      log(response.toString());
      return RequestStatus.success;
    } catch (e) {
      log(e.toString());
      return RequestStatus.failure;
    }
  }

  static Future<RequestStatus> postVideo(path) async {
    FormData formData =
        FormData.fromMap({'video': MultipartFile.fromFile(path)});
    String postUrl = 'video';

    Response? response;
    try {
      response = await dio.post(
        postUrl,
        data: formData,
      );
      log(response.toString());
      return RequestStatus.success;
    } catch (e) {
      log(e.toString());
      return RequestStatus.failure;
    }
  }

  static getWithRetry(FormData formData) async {
    if (await checkInternet()) {
      try {
        final Response? response = await getRequest(parameters: {});
        if (response!.statusCode == 200) {
          return response;
        } else {
          log('there is internet but request not sent');
          return response;
        }
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }
    log('retrying in 5 seconds');
    await Future.delayed(const Duration(seconds: 5));
    log('retrying now...');
    return await getWithRetry(formData);
  }

  /*  static postWithRetry(FormData formData) async {
    if (await checkInternet()) {
      try {
        final Response response = await postRequest(formData);
        if (response.statusCode == 200) {
          log(response.toString());
          return response;
        } else {
          log('there is internet but request not sent');
        }
      } on DioException catch (e) {
        log(e.toString());
      }
    }
    log('retrying request   ${formData.fields[0].key} : ${formData.fields[0].value} in 5 seconds');
    await Future.delayed(const Duration(seconds: 5));
    log('retrying now...');

    return await postWithRetry(formData);
  } */

  static Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      log("Couldn't connect to the internet");
      return false; // No network connection
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      Response? response;
      try {
        response = await Dio().get(baseURL);
        log('Successfully connected to the internet');
        return response.statusCode! <
            300; // Successfully connected to the internet
      } catch (e) {
        log("Couldn't connect to the internet ${e.toString()}");
        return false; // Couldn't connect to the internet
      }
    } else {
      log("Couldn't connect to the internet");
      return false; // Other connectivity issues
    }
  }
}
