import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  final _pageController = new PageController(
      initialPage: 1,
      viewportFraction: 0.3
    );

  MovieHorizontal({ @required this.peliculas, @required this.siguientePagina });

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    
    _pageController.addListener(() {
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 5){
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context , i){
          return _tarjeta(context, peliculas[i]);
        },
      )
      /*
      El PageView renderiza todos los elementos y para ser optimizado debe de usarse el builder
      PageView(
        pageSnapping: false,
        controller: _pageController,
        children: _tarjetas(context),
      )*/
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'), 
              image: NetworkImage(pelicula.getPosterImg()),
              fit: BoxFit.cover,
              height: 130.0,
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }

  List<Widget> _tarjetas(BuildContext context){
    return peliculas.map((pelicula){
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'), 
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 130.0,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}