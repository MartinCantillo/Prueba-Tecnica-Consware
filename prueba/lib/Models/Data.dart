import 'dart:convert';


class Data {
  String? name;
  String? status;
  String? species;
  String? type;
  String? origen;
  String? location;
  String image;

  Data({
    this.name,
    this.status,
    this.species,
    this.type,
    this.origen,
    this.location,
    required this.image,
 
  });

  //Descerializacion de datos de la api
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"] ?? "",
        status: json["status"] ?? "",
        species: json["species"] ?? "",
        type: json["type"],
        origen: json["origin"]["name"],
        location: json["location"]["name"],
        image: json["image"],
    
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
