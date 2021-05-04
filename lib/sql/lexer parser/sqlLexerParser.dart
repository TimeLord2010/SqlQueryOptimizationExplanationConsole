import 'package:http/http.dart' as http;
import 'dart:convert';

var dbmetadata_url = 'https://8n242oo4sj.execute-api.sa-east-1.amazonaws.com/prod/mysql/getmetadata';

void getDatabaseMetaData () async {
  var response = await http.post(Uri.parse(dbmetadata_url));
  if (response.statusCode != 200) {
    var message = response.body;
    throw Exception('Failed to get database meta data. Body: $message');
  }
  return json.decode(response.body);
}

