import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadCallBackClass {
  @pragma('vm:entry-point')
  static void downloadCallBack(String id, DownloadTaskStatus status, int progress){
    final SendPort? send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }
}


class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  /*TODO make sure file still exists */

  bool toDelete = false; //if user clicks on delete
  ReceivePort _receivePort = ReceivePort();
  int? _progress;
  DownloadTaskStatus? _status;

  // List<DownloadTask>? _downloadTasks;

  // @pragma('vm:entry-point')
  // static void downloadCallBack(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send!.send([id, status, progress]);
  // }

  Future<List<DownloadTask>?> _loadTasks() async {
    //load all the task from the database
    List<DownloadTask>? _downloadTasks = await FlutterDownloader.loadTasks();
    // _downloadTasks!.forEach((element) {
    //   FlutterDownloader.remove(taskId: element.taskId);
    // });
    return _downloadTasks;
    // print ("the task list is ${_downloadTasks!.length}");
  }

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'downloader_send_port');
    _receivePort.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {
        _progress = progress;
        _status = status;
      });
    });

    FlutterDownloader.registerCallback(DownloadCallBackClass.downloadCallBack);
    _loadTasks();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 10,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (toDelete)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                              value: toDelete,
                              onChanged: (value) {
                                setState(() {
                                  toDelete = value!;
                                });
                              }),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Downloads"),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  toDelete = true;
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: _loadTasks(),
                    builder: (ctx, asyncSnapShot) {
                      if (asyncSnapShot.hasData) {
                        List<DownloadTask>? _result =
                            asyncSnapShot.data as List<DownloadTask>?;

                        // print ("in list view the status is ${_result![0].status}");

                        return Expanded(
                          child: ListView.separated(
                              itemBuilder: (ctx, index) {
                                return Row(
                                  children: [
                                    ItemsCard(
                                      status: (_status == null) ? _result![index].status : _status!,
                                      progress: (_progress == null) ? _result![index].progress : _progress!,
                                      isDelete: toDelete,
                                      downloadTask: _result![index],
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (ctx, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: _result!.length),
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            )));
  }
}

class ItemsCard extends StatefulWidget {
  final bool isDelete;
  final DownloadTask downloadTask;
  final int progress;
  final DownloadTaskStatus status;

  //each row item
  const ItemsCard(
      {Key? key,
        required this.status,
        required this.isDelete, required this.downloadTask,required this.progress})
      : super(key: key);

  @override
  State<ItemsCard> createState() => _ItemsCardState();
}

class _ItemsCardState extends State<ItemsCard> {
  bool isSelected = false;
  IconData _icon = Icons.download;
  dynamic _action;
  String? id;

  @override
  void initState() {
    super.initState();
    id = widget.downloadTask.taskId;
    // setIconAndAction();
  }

  Future<IconButton> setIconAndAction() async {
    if (widget.status == DownloadTaskStatus.paused) {
      print ("the download has been paused");
      return IconButton(
        onPressed: () async {
          await FlutterDownloader.resume(taskId: id!);
        },
        icon: Icon(
          Icons.play_arrow,
          color: const Color(0xFF0D70C4),
          size: 30,
        ),
      );
    } else if (widget.status == DownloadTaskStatus.running) {
      return  IconButton(
        onPressed: () async {
          await FlutterDownloader.pause(taskId: id!);
        },
        icon: Icon(
          Icons.pause,
          color: const Color(0xFF0D70C4),
          size: 30,
        ),
      );

    } else if (widget.status == DownloadTaskStatus.canceled) {
      print ("the download was canceled");
      return  IconButton(
        onPressed: () async {
          print("resuming from canceled");
          await FlutterDownloader.retry(taskId: id!);
        },
        icon: Icon(
          Icons.rotate_left,
          color: const Color(0xFF0D70C4),
          size: 30,
        ),
      );
    } else if(widget.status == DownloadTaskStatus.complete){
      print ("Download complete");
      return IconButton(onPressed: () {}, icon: Icon(Icons.done));
    } else if (widget.status == DownloadTaskStatus.failed){
      print ("the download failed");
      return  IconButton(
        onPressed: () async {
          print("resuming from failed the id is $id");
          String _url = widget.downloadTask.url;
          // print ("the url is $_url");
          // await FlutterDownloader.remove(taskId: id!);
          id = await FlutterDownloader.enqueue(
              url: _url,
              savedDir: '/storage/emulated/0/Download',
              showNotification: true,
              saveInPublicStorage: true);
          setState((){});
          // await FlutterDownloader.retry(taskId: id!);
          // await FlutterDownloader.remove(taskId: id!);
        },
        icon: Icon(
          Icons.rotate_left,
          color: const Color(0xFF0D70C4),
          size: 30,
        ),
      );
    } else  {
      print ("the download status is ${widget.status}");
      return  IconButton(
        onPressed: () async {
          // print ("the id is ${widget.downloadTask.taskId}");
          String _url = widget.downloadTask.url;
          // print ("the url is $_url");
          await FlutterDownloader.remove(taskId: widget.downloadTask.taskId);
          await FlutterDownloader.enqueue(
              url: _url,
              savedDir: '/storage/emulated/0/Download',
              showNotification: true,
              saveInPublicStorage: true);
          // setState((){});
        },
        icon: Icon(
          Icons.waving_hand,
          color: const Color(0xFF0D70C4),
          size: 30,
        ),
      );
    }
    // setState(() {});
  }

  // @override
  // void initState() {
  //   super.initState();
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.black,
        child: Column(
          children: [
            Row(
              children: [
                if (widget.isDelete)
                  Checkbox(
                      value: isSelected,
                      onChanged: (value) {
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
                  child: Center(child: Text('${widget.progress}',style: TextStyle(color: Colors.red,fontSize: 50),)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text((widget.downloadTask.filename == null)
                            ? 'Movie Name'
                            : widget.downloadTask.filename!)),
                    Row(
                      children: [
                        const Icon(Icons.star),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("0.0")
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // IconButton(
                //   onPressed: _action,
                //   icon: Icon(
                //     _icon,
                //     color: const Color(0xFF0D70C4),
                //     size: 30,
                //   ),
                // ),
                FutureBuilder(
                    future: setIconAndAction(),
                    builder: (context,asyncSnapShot) {
                      if (asyncSnapShot.hasData){
                        IconButton _icon = asyncSnapShot.data as IconButton;
                        return _icon;
                }else{
                      return Container();
                }}
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            LinearProgressIndicator(
              value: widget.progress / 100,
            )
          ],
        ),
      ),
    );
  }
}
