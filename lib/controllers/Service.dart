import 'dart:math';
import 'package:monitoring_app/controllers/Connection.dart';
import 'package:monitoring_app/models/ResponseGeneric.dart';
import 'package:monitoring_app/models/Session.dart';

class Service{
  final Connection _con = Connection();
  String getMedia(){
    return Connection.URL_MEDIA;
  }

  
  Future<Session> session(Map<dynamic, dynamic> map) async {
    
    ResponseGeneric rg = await _con.post("login", map); 
    
    Session s = Session();

    s.add(rg);
    if(rg.code == '200'){
      s.token = s.datos["token"];
      s.user = s.datos["user"];
    } 

    return s;
  }
}