import 'package:flutter/material.dart';
import 'package:prueba/Models/Data.dart';
import 'package:prueba/Models/Episodio.dart';
import 'package:prueba/Provider/EpisodiosProvider.dart';

class EpisodeListPage extends StatefulWidget {
  final List<Episodio>? episodes;

  const EpisodeListPage({Key? key, this.episodes}) : super(key: key);

  @override
  State<EpisodeListPage> createState() => _EpisodeListPageState();
}

class _EpisodeListPageState extends State<EpisodeListPage> {
  late Future<List<Episodio>> gifsList;
  late ScrollController _scrollController;
  List<Episodio> _gifs = [];
  List<Data> _filteredGifs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    gifsList = EpisodiosProvider.GetDataE();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Si no está cargando más datos actualmente, cargar más
      if (!_isLoading) {
        _loadMoreGifs();
      }
    }
  }

  Future<void> _loadMoreGifs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final additionalGifs = await EpisodiosProvider.GetDataE();
      setState(() {
        _gifs.addAll(additionalGifs);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading more gifs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Episodios",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
          future: gifsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              _gifs = snapshot.data as List<Episodio>;
              return GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 2,
                  crossAxisCount: 2,
                ),
                itemCount: _gifs.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _gifs.length) {
                    // Descompongo el atributo episode en temporada y número del episodio
                    final episodeParts = _gifs[index].episode!.split('E');
                    final season = episodeParts[0].substring(1); // Elimino el 'S' inicial
                    final episodeNumber = episodeParts[1];

                    return Card(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nombre: ${_gifs[index].name}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Air date: ${_gifs[index].air_date}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Temporada: $season',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Episodio: $episodeNumber',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
