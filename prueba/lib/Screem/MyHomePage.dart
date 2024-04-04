import 'package:flutter/material.dart';
import 'package:prueba/Models/Data.dart';
import 'package:prueba/Provider/DataProvider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//Inyecto la clase del servicio
  late Future<List<Data>> gifsList;
  late ScrollController _scrollController;
  List<Data> _gifs = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    gifsList = DataProvider.GetData();
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
      final additionalGifs = await DataProvider.GetData();
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
            "The Rick and Morty API",
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
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              _gifs = snapshot.data as List<Data>;
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
                    return Card(
                      color: Colors.black, 
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100, 
                              height:
                                  200, 
                              child: Column(
                                children: [
                                  const SizedBox(
                                      height:
                                          8), 
                                  Image.network(
                                    _gifs[index].image,
                                    fit: BoxFit
                                        .cover, 
                                        height: 170,
                                       // width: 2270,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
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
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Estado: ${_gifs[index].status}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  // Agrega más widgets aquí para mostrar más información
                                ],
                              ),
                            ),
                          ),
                        ],
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
