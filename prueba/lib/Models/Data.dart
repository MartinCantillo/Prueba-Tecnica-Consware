import 'dart:convert';

class Episodio {
  String? name;
  String? air_date;
  String? episode;
  Episodio({
    this.name,
    this.air_date,
    this.episode,
  });

  //Descerializacion de datos de la api
  factory Episodio.fromJson(Map<String, dynamic> json) => Episodio(
        name: json["name"] ?? "",
        air_date: json["air_date"] ?? "",
        episode: json["episode"] ?? "",
      );
      Map<String, dynamic> toJson() {
    return {
      'name': name,
      'air_date': air_date,
      'episode': episode,
    };
  }

}

class Data {
  String? name;
  String? status;
  String? species;
  String? type;
  String? origen;
  String? location;
  String image;
  List<Episodio>? episodes; // Lista de episodios
  Data({
    this.name,
    this.status,
    this.species,
    this.type,
    this.origen,
    this.location,
    required this.image,
    this.episodes, // Incluye la lista de episodios en el constructor
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
        episodes: json["episodes"] != null
            ? List<Episodio>.from(
                json["episodes"].map((x) => Episodio.fromJson(x)))
            : [], // Mapea la lista de episodios desde JSON si existe
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
      'episodes': episodes != null
          ? episodes!.map((episodio) => episodio.toJson()).toList()
          : [], // Convierte la lista de episodios a JSON si existe
    };
  }

  String toJson() => json.encode(toMap());
}
