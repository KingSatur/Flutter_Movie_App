import 'package:flutter/material.dart';
import 'package:movies/src/models/actores_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movie_provider.dart';

class MovieDetail extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _crearAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 20.0,),
                _posterTitulo(context,movie),
                _descripcion(movie),
                _descripcion(movie),
                _descripcion(movie),
                _descripcion(movie),
                _crearCasting(movie)
              ]
            ),
          )
        ],
      ),
    );
  }

  Widget _crearCasting(Movie movie){
    final movieProvider = new MovieProvider();

    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }

  Widget _crearActoresPageView(List<Actor> actores){
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, index) {
          return _actorTarjeta(actores[index]);
        },
      ),
    );
  }

  Widget _actorTarjeta(Actor actor){
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,  
          )
        ],
      ),
    );
  }

  Widget _crearAppBar(Movie movie){
    return SliverAppBar(
      elevation: 10.0,
      backgroundColor: Colors.indigo,
      expandedHeight:  200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),  
        ),
        background: FadeInImage(
          image: NetworkImage(movie.getBackgroundImage()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _descripcion(Movie movie){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _posterTitulo(BuildContext context,Movie movie){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.subtitle2, overflow: TextOverflow.ellipsis,),
                Row(
                  children: [
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString())
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}