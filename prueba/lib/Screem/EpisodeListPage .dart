import 'package:flutter/material.dart';
import 'package:prueba/Models/Data.dart';
import 'package:prueba/Screem/EpisodeDetailPage%20.dart';

class EpisodeListPage extends StatelessWidget {
  final List<Episodio>? episodes;

  const EpisodeListPage({Key? key, this.episodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodios'),
      ),
      body: ListView.builder(
        itemCount: episodes?.length ?? 0,
        itemBuilder: (context, index) {
          final episode = episodes![index];
          return ListTile(
            title: Text(episode.name ?? ''),
            subtitle: Text(episode.episode ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EpisodeDetailPage(episode: episode),
                ),
              );
            },
          );
        },
      ),
    );
  }
}