import 'package:flutter/material.dart';

class LatestMovies extends StatefulWidget {
  const LatestMovies({Key? key}) : super(key: key);

  @override
  State<LatestMovies> createState() => _LatestMoviesState();
}

class _LatestMoviesState extends State<LatestMovies> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(

            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("High rated",style: Theme.of(context).textTheme.bodyText1,),
                            const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(

                          height: 150,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (index,ctx) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                );
                              }, separatorBuilder: (index,ctx) => const SizedBox(
                            width: 10,
                          ), itemCount: 10),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Latest",style: Theme.of(context).textTheme.bodyText1,),
                            const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(

                          height: 150,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (index,ctx) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                );
                              }, separatorBuilder: (index,ctx) => const SizedBox(
                            width: 10,
                          ), itemCount: 10),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Most Popular",style: Theme.of(context).textTheme.bodyText1,),
                            const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 150,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (index,ctx) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                );
                              }, separatorBuilder: (index,ctx) => const SizedBox(
                            width: 10,
                          ), itemCount: 10),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        )
      ],

    );

  }
}
