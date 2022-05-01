import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    Widget temp = Card(
      color: Colors.black,
      child: Row(
        children: [
          Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,

            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Movie Name",style: Theme.of(context).textTheme.bodyText2,),
              ),
              Row(
                children: [
                  Icon(Icons.star),
                  SizedBox(
                    width: 10,
                  ),
                  Text("0.0")
                ],
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.download_sharp,color: Color(0xFF0D70C4),size: 30,),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25,top: 20),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Horror",style: Theme.of(context).textTheme.bodyText1,),
                      const Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: width,
                    height: 300,
                    child: GridView.builder(
                        itemCount: 20,
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: (width)/(height/0.59)
                    ), itemBuilder: (ctx,index) {
                      return temp;
                    }),
                  )
            ],
          ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Comedy",style: Theme.of(context).textTheme.bodyText1,),
                      const Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: width,
                    height: 300,
                    child: GridView.builder(
                        itemCount: 20,
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: (width)/(height/0.59)
                        ), itemBuilder: (ctx,index) {
                      return temp;
                    }),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Action",style: Theme.of(context).textTheme.bodyText1,),
                          const Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: width,
                        height: 300,
                        child: GridView.builder(
                            itemCount: 20,
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                childAspectRatio: (width)/(height/0.59)
                            ), itemBuilder: (ctx,index) {
                          return temp;
                        }),
                      )
                    ],
                  ),
                ],
              ),
        ]),

      ),
    ));
  }
}
