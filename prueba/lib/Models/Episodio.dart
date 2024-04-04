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
