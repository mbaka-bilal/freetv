import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0; //which page are we displaying

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.search)),
          IconButton(onPressed: null,icon: Icon(Icons.notifications_outlined))


        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPageIndex,
        selectedLabelStyle: TextStyle(
          fontSize: 0
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 0
        ),
        items: [
          BottomNavigationBarItem(
              activeIcon: Container(
      width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFF155672),

            borderRadius: BorderRadius.circular(8)

        ),
        child: Icon(Icons.home),
      ),
              icon: Icon(Icons.home),
          label: ""
          ),

          BottomNavigationBarItem(
              activeIcon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xFF155672),

                    borderRadius: BorderRadius.circular(8)

                ),
                child: Icon(Icons.category),
              ),
              icon: Icon(Icons.category),
              label: ""
          ),
          BottomNavigationBarItem(
              activeIcon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xFF155672),

                    borderRadius: BorderRadius.circular(8)

                ),
                child: Icon(Icons.favorite),
              ),
              icon: Icon(Icons.favorite),
              label: ""
          ),
          BottomNavigationBarItem(
              activeIcon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xFF155672),

                    borderRadius: BorderRadius.circular(8)

                ),
                child: Icon(Icons.person),
              ),
              icon: Icon(Icons.person),
              label: ""
          ),
        ],
      ),
      body: CustomScrollView(
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
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                          SizedBox(
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
                                }, separatorBuilder: (index,ctx) => SizedBox(
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
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                          SizedBox(
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
                                }, separatorBuilder: (index,ctx) => SizedBox(
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
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                          SizedBox(
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
                                }, separatorBuilder: (index,ctx) => SizedBox(
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

      ),
    );
  }
}
