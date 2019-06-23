import 'package:dio/dio.dart';

import 'package:visitor/com/goldccm/visitor/util/Constant.dart';//用于配置公用常量
import 'package:visitor/com/goldccm/visitor/util/DataUtils.dart';
import 'package:visitor/com/goldccm/visitor/util/CommonUtil.dart';

class Http{
  static Http instance;
  static String token;
  Dio _dio;

  static  getInstance(){
    print("getInstance");
    if(instance == null){
      instance  = new Http();
    }
  }

  Http(){

//    Options options = new BaseOptions(
//      baseUrl: "https://www.xx.com/api",
//      connectTimeout: 5000,
//      receiveTimeout: 3000,
//    );
       _dio = new Dio();
       _dio.options.baseUrl = "http://47.99.209.40:8082/";
       _dio.options.connectTimeout = 5000; //5s
       _dio.options.receiveTimeout = 3000;
  }



  // get 请求封装 需要token验证
  getWithHeader(url,{ options, cancelToken, queryParameters}) async {
    print('get:::url：$url ,body: $queryParameters');
    Response response;
    var headers = Map<String, String>();
    headers['token'] = DataUtils.getAccessToken().toString();
    headers['userId'] = DataUtils.getUserId().toString();
    headers['factor'] = CommonUtil.getCurrentTime();
    headers['threshold'] = CommonUtil.calWorkKey();
    headers['requestVer'] = CommonUtil.getAppVersion();
    _dio.options.headers.addAll(headers);
    try{
      response = await _dio.get(
          url,
          cancelToken:cancelToken,
        queryParameters: queryParameters !=null ? queryParameters : {},
      );
    }on DioError catch(e){
      if(CancelToken.isCancel(e)){
        print('get请求取消! ' + e.message);
      }else{
        print('get请求发生错误：$e');
      }
    }
    return response.data;
  }

  // post请求封装
  postWithHeader(url,{ options, cancelToken, data}) async {
    print('post请求::: url：$url ,body: $data');
    Response response;
    var headers = Map<String, String>();
    headers['token'] = DataUtils.getAccessToken().toString();
    headers['userId'] = DataUtils.getUserId().toString();
    headers['factor'] = CommonUtil.getCurrentTime();
    headers['threshold'] = CommonUtil.calWorkKey();
    headers['requestVer'] = CommonUtil.getAppVersion();
    _dio.options.headers.addAll(headers);

    try{
      response = await _dio.post(
          url,
          data:data !=null ? data : {},
          cancelToken:cancelToken
      );
      print(response);
    }on DioError catch(e){
      if(CancelToken.isCancel(e)){
        print('get请求取消! ' + e.message);
      }else{
        print('get请求发生错误：$e');
      }
    }
    return response.data;
  }



  // get 请求封装 需要token验证
  Future<String> get(url,{ options, cancelToken, queryParameters}) async {
    print('get:::url：$url ,body: $queryParameters');
    Response response;
    try{
      response = await _dio.get(
        url,
       // cancelToken:cancelToken,
        options: Options(method:"GET"),
        queryParameters: queryParameters !=null ? queryParameters : {},
      );
    }on DioError catch(e){
      if(CancelToken.isCancel(e)){
        print('get请求取消! ' + e.message);
      }else{
        print('get请求发生错误：$e');
      }
    }
    return response.data;
  }

  // post请求封装
  post(url,{ options, cancelToken, data}) async {
    print('post请求::: url：$url ,body: $data');
    Response response;
    try{
      response = await _dio.post(
          url,
          data:data !=null ? data : {},
          cancelToken:cancelToken
      );
      print(response);
    }on DioError catch(e){
      if(CancelToken.isCancel(e)){
        print('get请求取消! ' + e.message);
      }else{
        print('get请求发生错误：$e');
      }
    }
    return response.data;
  }



}
