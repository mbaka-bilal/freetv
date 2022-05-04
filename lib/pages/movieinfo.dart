import 'package:flutter/material.dart';

class MovieInfo extends StatefulWidget {
  const MovieInfo({Key? key}) : super(key: key);

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    Widget rateBottomSheet() {
      return Column(
        children: [
          Text("Rate this movie"),

        ],
      );
    }


    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height / 1.7,
            child: Stack(
              children: [
                Container(
                  height: height / 1.7,

                  color: Colors.red,

                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0,left: 40),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30,left: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Movie Name",style: Theme.of(context).textTheme.bodyText1,),
                        Text("Year",style: Theme.of(context).textTheme.bodyText1,),
                      ],
                    )
                  ),
                ),

              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: IconButton(
                  onPressed: null,

                  icon: Icon(Icons.favorite,size: 30,color: Colors.white,),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)
                        ),
                        context: context, builder: (ctx) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Rate this movie",style: Theme.of(context).textTheme.bodyText1,),


                        ],
                      );
                    } );
                  },

                  icon: Icon(Icons.star,size: 30,color: Colors.white,),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: IconButton(
                  onPressed: null,

                  icon: Icon(Icons.download,size: 30,color: Colors.white,),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Description",style: Theme.of(context).textTheme.bodyText1,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(
                width: width / 1.2,

                child: Text("sdfsdfsdfsfdsdfsdfsdfsdfsdfsfdsfdsdfsfdsdfsdfsdfsdfsdfsdfsfsdf",style: Theme.of(context).textTheme.bodyText1,)),
          )
        ],
      ),
    );
  }
}



