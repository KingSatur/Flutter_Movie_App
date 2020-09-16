import 'package:flutter/material.dart';


class Search extends SearchDelegate {

  final movies = ['Spiderman', 'Batman', 'Superman'];
  final recentMovies = ['Spiderman', 'Capitan America']; 
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
      return Center(
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.blueAccent,
          child: Text(
            this.seleccion
          ),
        ),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // TODO: Son las sugerencias que aparecen cuando la persona escribe

      final listaFiltrada = this.query.isEmpty ? recentMovies :
      movies.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();

      return ListView.builder(
        itemCount: listaFiltrada.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.movie),
            title:Text(listaFiltrada[index]),
            onTap: () {
              this.seleccion = listaFiltrada[index];
              showResults(context);
            },
          );
        },
      );
    }



}
