import 'dart:async';
import 'dart:convert';

import 'package:movies/src/models/actores_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:http/http.dart' as http;


class MovieProvider {


  String _apikey = '6a12938be1dc8c3a9f4a0cc5a032bdbc';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;

  List<Movie> _populares = new List();

// Broadcast es para que varios widgets puedan escuchar el stream
  final _popularesStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Movie>> get popularesStream => _popularesStreamController.stream;


  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Actor>> getCast(String movieId) async{
      final url = Uri.https(_url, '3/movie/$movieId/credits', {
      "api_key":_apikey,
      "language":_lenguage,
    });


    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final Cast casting = new Cast.fromJsonList(decodedData['cast']);

    return casting.actores;
  }

  Future<List<Movie>> _procesarRespuesta(Uri url) async{
    final resp = await http.get( url );
    // Obtengo el body de la respuesta, lo transforma en un mapa
    final decodedData = json.decode(resp.body);

    final peliculas = new Movies.fromJsonList(decodedData['results']);

    print(peliculas.items);
    return peliculas.items;
  }

  Future<List<Movie>> getNowPlaying() async{
    final url = Uri.https(_url, '3/movie/now_playing', {
      "api_key":_apikey,
      "language":_lenguage
    });

    return await _procesarRespuesta(url);

  // Obtengo la respuesta

  }

  Future<List<Movie>> getPopular() async{
      
    if(_cargando) return [];
    _cargando = true;
    _popularesPage ++;    
    final url = Uri.https(_url, '3/movie/popular', {
      "api_key":_apikey,
      "language":_lenguage,
      "page":_popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;

    return resp;
  }
  

}