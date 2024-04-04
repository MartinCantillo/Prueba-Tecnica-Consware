import 'package:flutter/material.dart';
import 'package:prueba/Models/Data.dart';
import 'package:prueba/Screem/EpisodeListPage%20.dart';

class CharacterDetailPage extends StatelessWidget {
  final Data gif;

  const CharacterDetailPage({Key? key, required this.gif}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Personaje'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              gif.image,
              fit: BoxFit.cover,
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'Nombre: ${gif.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Estado: ${gif.status}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Especie: ${gif.species}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Origen: ${gif.origen}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Ubicacion: ${gif.location}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EpisodeListPage(episodes: gif.episodes),
                  ),
                );
              },
              child: Text('Ver Episodios'),
            ),
          ],
        ),
      ),
    );
  }
}