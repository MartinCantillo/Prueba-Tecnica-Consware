//Provider , encargado de la peticion http
import 'dart:convert';

import 'package:prueba/Models/Data.dart';
import 'package:http/http.dart' as http;

class DataProvider {
  static final String endpoint = "https://rickandmortyapi.com/";

  static Future<List<Data>> GetData() async {
    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        //Decodifico los datos de la api y los preparo a json
        final List<dynamic> LData = jsonDecode(response.body);
        //Descerializo los datos
        List<Data> dataList =
            LData.map((e) => Data.fromJson(e as Map<String, dynamic>)).toList();

        return dataList;
      } else {
        throw Exception('Error del servidor ${response.statusCode}');
      }
    } catch (e) {
      print('Error al hacer la solicitud HTTP: $e');
      throw Exception('Error en la solicitud HTTP: $e');
    }
  }
}
