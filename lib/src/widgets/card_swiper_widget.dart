import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';

class CardSwiper extends StatelessWidget {

  final List<dynamic> peliculas;
  
  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context,int index){
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                "https://picsum.photos/seed/2020/200/300",
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: peliculas.length,
          pagination: new SwiperPagination(),
          //control: new SwiperControl(),
        ),
    );
  }
}