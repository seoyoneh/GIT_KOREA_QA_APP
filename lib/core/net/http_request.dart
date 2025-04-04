import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:product_manager/components/indecator/loading_indicator.dart';
import 'package:product_manager/core/net/request_url.dart';

final Dio dio = Dio();

/// <b>HTTP 통신을 위한 클래스</b><br>
/// 이 클래스는 기본적으로 Dio를 사용하여 HTTP 통신을 수행한다.<br>
/// HTTP 통신을 수행하기 위해서는 RequestUrlType을 통해 URL을 지정하고,
/// 필요한 파라미터를 params로 전달하면 된다.<br>
/// HTTP 통신을 수행하는 동안 로딩 인디케이터를 표시하고,
/// 통신이 완료되면 인디케이터를 닫는다.<br>
/// 통신이 완료되면 Response를 반환한다.<br>
/// 인디케이터는 Overlay로 구현되어 있으며, LoadingIndicator를 사용한다.
/// 이런 이유로 Widget내 initState에서 사용할 수 없다.<br>
/// initState에서 사용하려면 Future.delayed를 사용하여야 한다.
class HttpRequest {
  static bool isLoading = false;

  /// HTTP 통신을 수행한다.
  /// [context] : BuildContext
  /// [urlType] : RequestUrlType
  /// [params] : [Map<String, dynamic>?]
  /// [return] : [Future<dynamic>]
  static FutureOr<dynamic>? request(BuildContext context,
      {required RequestUrlType urlType,
      Map<String, dynamic>? params,
      bool hasIndicator = true,
      bool autoCloseIndicator = true}) async {
    Response response = _getErrorResponse();

    String url = _urlGenerator(urlType, params, context);

    if (!isLoading && hasIndicator) {
      LoadingIndicator.show(context);
    }

    isLoading = true;
    dio.options.connectTimeout = const Duration(seconds: 10);

    Map<String, dynamic> data = {};

    if (params != null) {
      for(String key in params.keys) {
        if(params[key] is String && params[key].isNotEmpty) { 
          data[key] = params[key];
        } else if(params[key] is! String) {
          data[key] = params[key];
        }
      }
    }

    response = await HttpRequest.send(
      dio,
      url: url,
      method: urlType.method,
      params: data
    );

    if (isLoading && hasIndicator && context.mounted && autoCloseIndicator) {
      LoadingIndicator.close(context);
    }

    isLoading = false;

    return response;
  }

  static FutureOr<dynamic>? upload(
    BuildContext context,
    {
      required RequestUrlType urlType,
      required File file,
      bool hasIndicator = true,
      bool autoCloseIndicator = true
    }) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: Uri.encodeComponent(file.path.split('/').last)
      )
    });

    if(!context.mounted) {
      return _getErrorResponse();
    }

    Map<String, dynamic> headers = _getMultipartHeaders();
    Response response = _getErrorResponse();
    String url = _urlGenerator(urlType, null, context);

    if (!isLoading && hasIndicator && context.mounted) {
      LoadingIndicator.show(context);
    }

    isLoading = true;
    dio.options.connectTimeout = const Duration(seconds: 10);

    try {
      switch(urlType.method) {
        case RequestMethod.POST:
          response = await dio.post(url,
            data: formData, options: Options(headers: headers));
          break;
        case RequestMethod.PUT:
          response = await dio.put(url,
            data: formData, options: Options(headers: headers));
          break;
        case RequestMethod.PATCH:
          response = await dio.patch(url,
            data: formData, options: Options(headers: headers));
        default:
          return response;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    if (isLoading && hasIndicator && context.mounted && autoCloseIndicator) {
      LoadingIndicator.close(context);
    }
    
    return response;
  }

  /// HTTP 통신을 수행한다.
  /// [dio] : Dio
  /// [url] : String
  /// [method] : RequestMethod
  /// [params] : [Map<String, dynamic>?]
  /// [return] : [Response]
  static Future<Response> send(Dio dio,
      {required String url,
      required RequestMethod method,
      Map<String, dynamic>? params,
      }) async {
    Response response = Response(requestOptions: RequestOptions(path: url));
    Map<String, dynamic> headers = _getHeaders();

    try {
      switch (method) {
        case RequestMethod.GET:
          response = await dio.get(url,
              queryParameters: params, options: Options(headers: headers));
          break;
        case RequestMethod.POST:
          response = await dio.post(url,
              data: params, options: Options(headers: headers));
          break;
        case RequestMethod.PUT:
          response = await dio.put(url,
              data: params, options: Options(headers: headers));
          break;
        case RequestMethod.PATCH:
          response = await dio.patch(url,
              data: params, options: Options(headers: headers));
          break;
        case RequestMethod.DELETE:
          response = await dio.delete(url,
              data: params, options: Options(headers: headers));
          break;
      }
    } catch (e) {
      response = Response(data: {
        'error': {
          'code': 19999,
          'message': 'httpError.networkError'.tr()
        }
      }, requestOptions: RequestOptions(path: url));
    }

    return response;
  }

  /// 헤더를 생성한다.
  static Map<String, dynamic> _getHeaders() {
    Map<String, dynamic> headers = {'Content-Type': 'application/json'};

    // 토큰이 필요한 경우 주석 해제
    // if(null != ApplicationData.getInstance().getUserToken() &&
    //   ApplicationData.getInstance().getUserToken()!.isNotEmpty
    // ) {
    //   headers['Authorization'] = 'Bearer ${ApplicationData.getInstance().getUserToken()!}';
    // }
    
    return headers;
  }

  static Map<String, dynamic> _getMultipartHeaders() {
    Map<String, dynamic> headers = {'Content-Type': 'multipart/form-data'};

    // 토큰이 필요한 경우 주석 해제
    // if(null != ApplicationData.getInstance().getUserToken() &&
    //   ApplicationData.getInstance().getUserToken()!.isNotEmpty
    // ) {
    //   headers['Authorization'] = 'Bearer ${ApplicationData.getInstance().getUserToken()!}';
    // }
    
    return headers;
  }

  /// URL을 생성한다.
  static String getUrl(String host, String url, Map<String, dynamic>? params, BuildContext? context) {
    if (null != params) {
      RegExp regExp = RegExp(r'\{(.*?)\}');
      Iterable<RegExpMatch> matches = regExp.allMatches(url);

      for (final match in matches) {
        String key = '';
        String value = '';

        if (null != match.group(1)) {
          key = match.group(1)!;
          value = params[key] ?? '';

          url = url.replaceAll('{$key}', value);
          params.remove(key);
        }
      }
    }

    return host + url;
  }

  /// RequestUrlType 정보와 파라미터를 이용하여 실제로 통신 할 URL을 생성한다.
  static String _urlGenerator(
    RequestUrlType urlType,
    Map<String, dynamic>? params,
    BuildContext context
  ) {
    String host = urlType.host;
    String url = urlType.url;

    return getUrl(host, url, params, context);
  }

  static Response _getErrorResponse() {
    return Response(data: {
      'error': HttpRequestError.UNKNOWN_ERROR.code,
      'message': 'httpError.unknownError'.tr(),
    }, requestOptions: RequestOptions(path: ''));
  }
}

/// HTTP 통신 에러
enum HttpRequestError {
  NETWORK_ERROR(code: 'NETWORK_ERROR'),
  TIMEOUT_ERROR(code: 'TIMEOUT_ERROR'),
  UNKNOWN_ERROR(code: 'UNKNOWN_ERROR'),
  SERVER_ERROR(code: 'SERVER_ERROR');

  final String code;

  const HttpRequestError({required this.code});

  get value {
    return code;
  }
}
