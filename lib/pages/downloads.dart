import 'package:flutter/material.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  bool toDelete = false; //if user clicks on delete
  // final double width = MediaQuery.of(context).size.width;
  // final double height = MediaQuery.of(context).size.height;


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Colors.black,
      body:
          Padding(padding: EdgeInsets.only(
            right: 10,
            left: 10,
            top: 10,
            bottom: 10,

          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (toDelete) ? Padding(

            padding: EdgeInsets.only(top: 10),
            child: Transform.scale(
              scale: 1.3,
              child: Checkbox(

                  value: toDelete, onChanged: (value){
                setState(() {
                  toDelete = value!;
                });
              }),
            ),
          ):

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Downloads"),
              IconButton(onPressed:() {
                setState((){
                  toDelete = true;
                });
              }, icon: Icon(Icons.delete,color: Colors.red,))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.separated(itemBuilder: (ctx,index) {
              return Row(
                children: [
                   ItemsCard(isDelete: toDelete),
                ],
              );
            }, separatorBuilder: (ctx,index){
              return SizedBox(
                height: 10,
              );
            }, itemCount: 2),
          )
        ],
    )
          )

    );
  }
}


class ItemsCard extends StatefulWidget {
  final bool isDelete;
  //each row item
  const ItemsCard({Key? key,required this.isDelete}) : super(key: key);

  @override
  State<ItemsCard> createState() => _ItemsCardState();
}

class _ItemsCardState extends State<ItemsCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.black,
        child: Row(
          children: [

          if  (widget.isDelete)  Checkbox(value: isSelected, onChanged: (value){
            setState(() {
              isSelected = value!;
            });
          }),

            Container(
              width: 150,
              height: 100,
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
                    child: Text("Movie Name")
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
      ),
    );
  }
}
