import 'package:flutter/material.dart';
import 'package:prueba/Models/Data.dart';

class EpisodeDetailPage extends StatelessWidget {
  final Episodio episode;

  const EpisodeDetailPage({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Episodio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nombre del Episodio: ${episode.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Fecha de Emisión: ${episode.air_date}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Número del Episodio: ${episode.episode}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
