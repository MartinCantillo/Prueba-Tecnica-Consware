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
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
                      child: Image.network(
                        _gifs[index].image,
                        fit: BoxFit.fill,
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