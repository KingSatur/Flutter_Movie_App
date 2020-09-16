import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movie_provider.dart';


class Search extends SearchDelegate {

  final movies = ['Spiderman', 'Batman', 'Superman'];
  final recentMovies = ['Spiderman', 'Capitan America']; 
  final movieProvider = new MovieProvider();
  String seleccion = '';


  @override
  List<Widget> buildActions(BuildContext context) {
      // TODO: Acciones de nuestro appbar, por ejemplo, icono para limpiar el texto
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          this.query = '';
        },
      )
    ];   
  }
  
    @override
    Widget buildLeading(BuildContext context) {
      // TODO: Icono a la izquierda del app bar+
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, []);
        },
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // TODO: Crea los resultados que vamos a mostrar
      // return Center(
      //   child: Container(
      //     height: 100.0,
      //     width: 100.0,
      //     color: Colors.blueAccent,
      //     child: Text(
      //       this.seleccion
      //     ),
      //   ),
      // );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // TODO: Son las sugerencias que aparecen cuando la persona escribe

      // final listaFiltrada = this.query.isEmpty ? recentMovies :
      // movies.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();

      // return ListView.builder(
      //   itemCount: listaFiltrada.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       leading: Icon(Icons.movie),
      //       title:Text(listaFiltrada[index]),
      //       onTap: () {
      //         this.seleccion = listaFiltrada[index];
      //         showResults(context);
      //       },
      //     );
      //   },
      // );
      if(this.query.isEmpty){
        return Container();
      }
      else{
        return FutureBuilder(
          future: movieProvider.getPeliculaByQuery(this.query),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if(snapshot.hasData){
              
              final movies = snapshot.data;

              return ListView(
                children: movies.map((movie)  {
                  return ListTile(
                    leading: FadeInImage(
                      image: NetworkImage(movie.getPosterImg()),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                    title: Text(movie.title),
                    subtitle: Text(movie.originalTitle),
                    onTap: () {
                      close(context,null);
                      movie.uniqueId = '';
                      Navigator.pushNamed(context, 'detail', arguments: movie);
                    },
                  ); 
                }).toList(),
              );
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      }

    }



}
