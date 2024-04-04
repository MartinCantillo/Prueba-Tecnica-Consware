import 'dart:convert';

import 'package:flutter/foundation.dart';

class Data {
  String? name;
  String? status;
  String? species;
  String? type;
  String? origen;
  String? location;
  Data({
    this.name,
    this.status,
    this.species,
    this.type,
    this.origen,
    this.location,
  });

//Descerializacion de datos de la api
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"] ?? "",
        status: json["status"] ?? "",
        species: json["species"] ?? "",
        type: json["type"],
        origen: json["origin"]["name"],
        location: json["location"]["name"],
      );

  //Serializacion

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'origen': origen,
      'location': location,
    };
  }

  String toJson() => json.encode(toMap());
}
