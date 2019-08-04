import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nga/utils/others/logUtils.dart';
import 'package:nga/utils/others/toast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nga/utils/net/entityFactory.dart';
import 'package:nga/utils/net/model/baseEntity.dart';
import 'errorHandle.dart';
import 'intercept.dart';
import 'package:nga/utils/global/globalConst.dart';


enum Method {
  get,
  post,
  put,
  patch,
  delete,
}

class DioUtils {
  static final DioUtils _singleton = DioUtils._internal();

  static DioUtils get instance => DioUtils();

  factory DioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  DioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 30000,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
//      baseUrl: "http://192.168.3.100:8086/",
//      contentType: ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8'),
    );
    _dio = Dio(options);

    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());

    /// 刷新Token
    _dio.interceptors.add(TokenInterceptor());

    /// 打印Log
    _dio.interceptors.add(LoggingInterceptor());

    /// 适配数据
    _dio.interceptors.add(AdapterInterceptor());
  }

  // 数据返回格式统一，统一处理异常
  Future<BaseEntity<T>> _request<T>(String method, String url,{
    String dataType,
    Map<String, dynamic> data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options
  }) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options, dataType),
        cancelToken: cancelToken);
    String _flag;
    String _msg;
    T _data;
    try {
      Map<String, dynamic> _map = json.decode(response.data.toString());
      if (_map.containsKey("data")) {
        Map<String, dynamic> _mapData = _map["data"];
        _flag = _mapData["flag"];
        _msg = _mapData["msg"];
        if (_mapData.containsKey("data")) {
          _data = EntityFactory.generateOBJ(_mapData["data"]);
        } else if (_mapData.containsKey("id")) {
          _data = EntityFactory.generateOBJ(_mapData["id"]);
        }
      }
    } catch (e) {
      print(e);
      return parseError();
    }
    return BaseEntity(_flag, _msg, _data);
  }

  Future<BaseEntity<List<T>>> _requestList<T>(String method, String url,{
    String dataType,
    Map<String, dynamic> data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options
  }) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options, dataType),
        cancelToken: cancelToken);
    String _flag;
    String _msg;
    List<T> _data = [];
    try {
      Map<String, dynamic> _map = json.decode(response.data.toString());
      Map<String, dynamic> _mapData = _map["data"];
      _flag = _mapData["flag"]; // 测试出来因为后台返回是 String 和前端的不符合，所以报错。
      _msg = _mapData["msg"];
      if (_mapData.containsKey("data")) {
        ///  List类型处理，暂不考虑Map
        (_mapData["data"] as List).forEach((item) {
          _data.add(EntityFactory.generateOBJ<T>(item));
        });
      }
    } catch (e) {
      print(e);
      return parseError();
    }
    return BaseEntity(_flag, _msg, _data);
  }

  BaseEntity parseError() {
    return BaseEntity(ExceptionHandle.parse_error.toString(), "数据解析错误", null);
  }

  Options _checkOptions(method, options, dataType) {
    if (options == null && dataType == 'json') {
      options = new Options();
    } else if(options == null && dataType == 'formData') {
      options = new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"));
    }
    options.method = method;
    return options;
  }

  Future<BaseEntity<T>> request<T>(String method, String url,{
    String dataType,
    Map<String, dynamic> params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options
  }) async {
    var response = await _request<T>(method, url,
        data: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
    return response;
  }

  Future<BaseEntity<List<T>>> requestList<T>(String method, String url,{
    String dataType,
    Map<String, dynamic> params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options
  }) async {
    var response = await _requestList<T>(method, url,
        data: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
    return response;
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回List<T>)
  requestNetwork<T>(Method method, String url,{
    String dataType: 'json',
    Function(T t) onSuccess,
    Function(List<T> list) onSuccessList,
    Function(int code, String mag) onError,
    Map<String, dynamic> params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
    bool isList: false
  }) {
    String m;
    switch (method) {
      case Method.get:
        m = "GET";
        break;
      case Method.post:
        m = "POST";
        break;
      case Method.put:
        m = "PUT";
        break;
      case Method.patch:
        m = "PATCH";
        break;
      case Method.delete:
        m = "DELETE";
        break;
    }
    url = GlobalConst.RemoteServerUrl + url;
    // Observable实现并扩展了Stream，它将常用的stream和streamTransformer组合成了非常好用的api。你可以把它想像成stream
    // 通过 Stream.asBroadcastStream() 可以将一个单订阅模式的 Stream 转换成一个多订阅模式的 Stream，isBroadcast 属性可以判断当前 Stream 所处的模式。
    Observable.fromFuture(isList
            ? requestList<T>(m, url,
                dataType: dataType,
                params: params,
                queryParameters: queryParameters,
                options: options,
                cancelToken: cancelToken)
            : request<T>(m, url,
                dataType: dataType,
                params: params,
                queryParameters: queryParameters,
                options: options,
                cancelToken: cancelToken))
        .asBroadcastStream()
        .listen((result) {
          if (result.flag == '0') {
            isList ? onSuccessList(result.data) : onSuccess(result.data);
          } else {
            onError == null ? _onError(result.flag, result.msg) : onError(int.parse(result.flag), result.msg);
          }
        }, onError: (e) {
          if (CancelToken.isCancel(e)) {
            Log.i("取消请求接口： $url");
          }
          Error error = ExceptionHandle.handleException(e);
          onError == null ? _onError(error.code.toString(), error.msg) : onError(error.code, error.msg);
        });
  }

  _onError(String code, String mag) {
    Log.e("接口请求异常： code: $code, mag: $mag");
    Toast.show(mag);
  }
}
