import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = '1306ed7d104106200a12eba3d9b98443';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

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
    final url = Uri.http(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language' : _language
    });

    return await _procesarResupeusta(url);
  }
}