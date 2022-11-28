import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

void predict(List<String> data) async {
  try {
    Dio().get('http://192.168.35.31:8000/predict', queryParameters: {
      'data': data.toString()
    }).then((value) => print("\n\n\n" + value.data + "\n"));
  } catch (e) {
    print("object");
  }
}

Future<String> insertToDatabase(String uid, List<String> data) async {
  // print(data.toString());
  // print("\n\n");
  // print("$data");
  print("$data");

  try {
    var res = await Dio().get('http://192.168.240.36:8000/updatedatabase',
        queryParameters: {'uid': uid, 'data': "$data"});
    return res.data.toString();
  } catch (e) {
    return '0';
  }
}
