import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';


class MovieHorizontal extends StatelessWidget {

  final List<Movie> movies;
  final _pageController = new PageController( initialPage: 1,
          viewportFraction: 0.3);

  final Function siguientePagina;

  MovieHorizontal({@required this.movies, @required this.siguientePagina}){

  }

  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        // Cargar siguientes pelicular
        siguientePagina();
      }
    });
    
    return Container(
      height: _screenSize.height * 0.3,
      // Para poder deslizarnos, como un slider en ionic
      child: PageView.builder(  
        pageSnapping: false,
        controller:_pageController ,
        itemBuilder: (context, index) => _crearTarjeta(movies[index], context),
        itemCount: movies.length,
      ),
    );
  }
  

  List<Widget> _tarjetas(BuildContext context){
    return this.movies.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: SingleChildScrollView(
            child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                    height: 160.0,
                ),
              ),
              SizedBox(height: 5.0,),
              Text(
                pelicula.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,)
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _crearTarjeta(Movie movie, BuildContext context){
      movie.uniqueId = "${movie.id}-horizontal";
      final movieCard = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: SingleChildScrollView(
            child: Column(
            children: [
              Hero(
                  tag: movie.uniqueId,
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage(
                      image: NetworkImage(movie.getPosterImg()),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      fit: BoxFit.cover,
                      height: 160.0,
                  ),
                ),
              ),
              SizedBox(height: 5.0,),
              Text(
                movie.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,)
            ],
          ),
        ),
      );

      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, 'detail', arguments: movie);
        },
        child: movieCard,
      );
  }
}