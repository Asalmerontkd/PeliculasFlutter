import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion ='';
  final peliculasProvider = new PeliculasProvider();

  final peliculas =[
    'Spiderman',
    'Capitan America',
    'Aquaman',
    'Batman',
    'Ironman',
    'Shazam!',
    'Superman',
    'Ironman2',
    'Ironman3',
    'Ironman4',

  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
      // LAS ACCIONES DE NUESTRO APP BAR
      return [
        IconButton(
          icon: Icon( Icons.clear ), 
          onPressed: (){ 
            print('Click'); 
            query = '';
          }
        ),
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // ICONO A LA IZQUIERDA DEL APPBAR
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, 
          progress: transitionAnimation
        ), 
        onPressed: (){
          print('Leading press');
          close(context, null);
        }
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // CREA LOS RESULTADOS QUE SE VAN A MOSTRAR
      return Center(
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.blueAccent,
          child: Text(seleccion),
        ),
      );
    }

  @override
  Widget buildSuggestions(BuildContext context) {
    // SON LAS SUGERENCIAS QUE APARECEN CUANDO LA PERSONA ESCRIBE
    /*final listaSugerida = ( query.isEmpty )
                            ? peliculasRecientes
                            : peliculas.where(
                              (p) => p.toLowerCase().startsWith(query.toLowerCase())
                              ).toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon( Icons.movie ),
          title: Text(listaSugerida[i]),
          onTap: (){
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      }
    );*/

    if (query.isEmpty){
      return Container();
    }

    return FutureBuilder(
            future: peliculasProvider.buscarPelicula(query),
            builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
              if (snapshot.hasData){
                final peliculas = snapshot.data;

                return ListView(
                  children: peliculas.map(
                    (pelicula){
                      return ListTile(
                        leading: FadeInImage(
                          placeholder: AssetImage('assets/img/no-image.jpg'), 
                          image: NetworkImage(pelicula.getPosterImg()),
                          width: 50.0,
                          fit: BoxFit.contain,
                        ),
                        title: Text(pelicula.title),
                        subtitle: Text(pelicula.originalTitle),
                        onTap: (){
                          close(context, null);
                          pelicula.uniqueId = '';
                          Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                        },
                      );
                    }
                  ).toList()
                );
              } else{
                return Center(
                  child: CircularProgressIndicator()
                );
              }
            },
          );
    }
  

}