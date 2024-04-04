import 'package:flutter/material.dart';
import 'package:prueba/Models/Episodio.dart';
import 'package:prueba/Provider/EpisodiosProvider.dart';

class EpisodeListPage extends StatefulWidget {
  final List<Episodio>? episodes;

  const EpisodeListPage({Key? key, this.episodes}) : super(key: key);

  @override
  State<EpisodeListPage> createState() => _EpisodeListPageState();
}

class _EpisodeListPageState extends State<EpisodeListPage> {
  late Future<List<Episodio>> episodesList;
  late ScrollController _scrollController;
  List<Episodio> _episodes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    episodesList = EpisodiosProvider.GetDataE();
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
        _loadMoreEpisodes();
      }
    }
  }

  Future<void> _loadMoreEpisodes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final additionalEpisodes = await EpisodiosProvider.GetDataE();
      setState(() {
        _episodes.addAll(additionalEpisodes);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading more episodes: $e');
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
          future: episodesList,
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
              _episodes = snapshot.data as List<Episodio>;
              return GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 2,
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,//aqui es para que se adapte a la pantalla
                ),
                itemCount: _episodes.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _episodes.length) {
                    final episodeParts = _episodes[index].episode!.split('E');
                    final season = episodeParts[0].substring(1);
                    final episodeNumber = episodeParts[1];

                    return Card(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nombre: ${_episodes[index].name}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Air date: ${_episodes[index].air_date}',
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
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
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
