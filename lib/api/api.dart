import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  //change to a corresponding IP of the device trying to connect to or to 10.0.2.2
  // final String _url = "http://10.0.2.2:8888/api/";

  //url when communicating with local machine
  final String _url = "http://localhost:8000/api/";

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('bigStore.jwt');
    return token;
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl, headers: _setHeaders());
  }

  updateData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.put(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $getToken()',
      };
}
