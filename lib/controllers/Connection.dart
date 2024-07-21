import 'dart:convert';
import 'dart:developer';
import 'package:monitoring_app/models/ResponseGeneric.dart';
import 'package:http/http.dart' as http;

class Connection {
  final String URL = "http://localhost:5000/";
  static String URL_MEDIA = "http://localhost/media/";
  
  Future<ResponseGeneric> get (String resource, {String key = ''}) async {
    final String _url = URL+resource;
    Map<String, String> headers = {'Content-Type':'application/json'};
    if(key != ''){
      headers = {'Content-Type':'application/json', 'X-Access-Token': key};
    }
    final uri = Uri.parse(_url);
    final response = await http.get(uri, headers:headers);

    //if(response.statusCode == 200 ){
    Map<dynamic, dynamic> _body = jsonDecode(response.body);
    return _response(_body["code"], _body["msg"], _body["datos"]);
  //  }
  }

  Future<ResponseGeneric> post (String resource, Map<dynamic,dynamic> map, {String key = ''}) async {
    print('antes error');
    final String _url = URL+resource;
    Map<String, String> headers = {'Content-Type':'application/json'};
    if(key != ''){
      headers = {'Content-Type':'application/json', 'X-Access-Token': key};
    }
    
    final uri = Uri.parse(_url);
    final response = await http.post(uri, headers:headers, body: jsonEncode(map));
    print('RESPONSE');
    print(response.body.toString());

    //if(response.statusCode == 200 ){
    Map<dynamic, dynamic> _body = jsonDecode(response.body);
  
    return _response(_body["code"].toString(), _body["msg"], _body["datos"]);
  //  }
  }

  ResponseGeneric _response (String code, String msg, dynamic map){
    var response = ResponseGeneric();
    response.msg = msg;
    response.code = code;
    response.datos = map;
    return response;
  }
}