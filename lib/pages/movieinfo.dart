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

    // Widget rateBottomSheet() {
    //   return Column(
    //     children: [
    //       Text("Rate this movie"),
    //       RatingsRow(),
    //     ],
    //   );
    // }


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
                        icon: const Icon(Icons.arrow_back),
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
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: IconButton(
                  onPressed: null,

                  icon: const Icon(Icons.favorite,size: 30,color: Colors.white,),
                ),
              ),
              const SizedBox(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Rate this movie",style: Theme.of(context).textTheme.bodyText1,),
                          const SizedBox(
                            height: 20,
                          ),

                          const RatingsRow(),

                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                              fixedSize: MaterialStateProperty.all(const Size(300,50)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ))
                            ),
                            onPressed: null,
                            child: Text("Submit",style: Theme.of(context).textTheme.bodyText1,),
                          )


                        ],
                      );
                    } );
                  },

                  icon: const Icon(Icons.star,size: 30,color: Colors.white,),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: const IconButton(
                  onPressed: null,

                  icon: Icon(Icons.download,size: 30,color: Colors.white,),
                ),
              ),
            ],
          ),
          const SizedBox(
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

class RatingsRow extends StatefulWidget {
  /* widget to handle draggable ratings */
  const RatingsRow({Key? key}) : super(key: key);

  @override
  State<RatingsRow> createState() => _RatingsRowState();
}

class _RatingsRowState extends State<RatingsRow> {
  int ratingLevel = 0;
  int currentPosition = 0;

  @override
  Widget build(BuildContext context) {
    // print ("in here");
    return GestureDetector(
      onHorizontalDragStart: (dragStartDetails) {
        /* store the value of the starting position based on local value of the Row */
        currentPosition = dragStartDetails.localPosition.dx.toInt();

      },
      onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails){
        // print ("the chage is ${dragUpdateDetails.localPosition.dx.toInt() - currentPosition}");
        if ((dragUpdateDetails.localPosition.dx.toInt() - currentPosition) > 10 ){
          /* update the rating level everytime we move 10 positions from the localPosition */
          currentPosition = dragUpdateDetails.localPosition.dx.toInt();
          setState(() {
            ratingLevel++;
          });
        }
        if (( currentPosition - dragUpdateDetails.localPosition.dx.toInt()) > 10 ){
          /* handle the reverse drag direction */
          currentPosition = dragUpdateDetails.localPosition.dx.toInt();
          setState(() {
            ratingLevel--;
          });
        }
      },
      onHorizontalDragEnd: (DragEndDetails dragEndDetails){
        //update the users ratings
        print ("the rating level is  ${ratingLevel}");
        currentPosition = 0;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          if (index < ratingLevel){
            /* build the ratings */
            return const Icon(Icons.star,color: Colors.yellow,);
          }else{
            return const Icon(Icons.star,color: Colors.white,);
          }
        } ),
      ),
    );
  }
}


