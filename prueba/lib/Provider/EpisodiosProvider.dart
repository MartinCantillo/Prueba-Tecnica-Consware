//Provider , encargado de la peticion http
import 'dart:convert';

import 'package:prueba/Models/Data.dart';
import 'package:http/http.dart' as http;
import 'package:prueba/Models/Episodio.dart';

class EpisodiosProvider {
  static  String endpoint = "https://rickandmortyapi.com/api/episode/";

  static Future<List<Episodio>> GetDataE() async {
    try {
      final response = await http.get(Uri.parse(endpoint));
     
      if (response.statusCode == 200) {
       
        //Decodifico los datos de la api y los preparo a json
        final List<dynamic> LEpisodes = jsonDecode(response.body)["results"];
    
        //Descerializo los datos
        List<Episodio> dataList =
            LEpisodes.map((e) => Episodio.fromJson(e as Map<String, dynamic>)).toList();
        
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
