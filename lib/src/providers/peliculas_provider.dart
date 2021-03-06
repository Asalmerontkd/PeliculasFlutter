import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'dart:convert';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = '1306ed7d104106200a12eba3d9b98443';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Pelicula> _populares = new List();
  int _popularesPage = 0;
  bool _cargando = false;

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarResupeusta(Uri url) async{
    final respuesta = await http.get(url);
    final decodedData = json.decode(respuesta.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    //print(peliculas.items[0].title);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async{
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language' : _language
    });
    return await _procesarResupeusta(url);
  }

  Future<List<Pelicula>> getPopulares() async{
    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    print('Cargando pagina $_popularesPage');

    final url = Uri.http(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : _popularesPage.toString()
    });

    final resp = await _procesarResupeusta(url);
    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast( String peliId ) async{
    final url = Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key' : _apiKey,
      'language' : _language
    });

    final resp = await http.get(url);
    final encodedData = json.decode(resp.body);

    final cast = new Cast.fronJsonList(encodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async{
    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apiKey,
      'language' : _language,
      'query': query
    });
    return await _procesarResupeusta(url);
  }
}