import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movie_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget {

  final movieProvider = new MovieProvider();

  @override
  Widget build(BuildContext context) {
    movieProvider.getPopular();
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

              showSearch(context: context, delegate: Search(), query: 'Hola');
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _swiperTarjetas(),
            _footer(context)
          ],
        ),
      ) 
    );
  }


  Widget _swiperTarjetas(){


    return FutureBuilder(
      future: movieProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return MovieSwiper(
            peliculas: snapshot.data,
          );
        }
        else{
          return Container(
            height: 400.0,
            child: 
              Center(
                child: CircularProgressIndicator()
              )
          );
        }
      },
    );
    // moviesProvider.getNowPlaying();
  }

  Widget _footer(BuildContext context){
    return Container(
      width: double.infinity,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          Container(
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle1),
            padding: EdgeInsets.only(left: 20.0),
          ),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: movieProvider.popularesStream,
            // initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              // snapshot.data?.forEach((movie) => {
              //   print(movie.title)
              // });
              if(snapshot.hasData){
                return MovieHorizontal(
                  movies: snapshot.data,
                  siguientePagina: movieProvider.getPopular,
                );
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
  
}