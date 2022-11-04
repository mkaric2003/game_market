// ignore_for_file: use_key_in_widget_constructors, unused_local_variable, prefer_const_constructors, sized_box_for_whitespace, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:my_mob_shop/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late VideoPlayerController _controller;
  bool init = false;

  void _playVideo(init, String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((value) => _controller.play());
  }

  @override
  void didChangeDependencies() {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    _playVideo(init = true, loadedProduct.videoUrl);
    super.didChangeDependencies();
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = _controller.value.volume == 0;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 19, 65),
        title: Text(loadedProduct.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.indigo.withOpacity(0.5),
            //Colors.white.withOpacity(0.5),
            Colors.black.withOpacity(0.7),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 300,
                  // width: double.infinity,
                  child: buildVideoPlayer(context, isMuted)),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedProduct.price}',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 300,
                width: 350,
                child: Text(
                  loadedProduct.description,
                  style: TextStyle(color: Colors.white),
                  //textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVideoPlayer(BuildContext context, bool isMuted) {
    return Container(
      child: _controller.value.isInitialized
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play(),
                      child: SizedBox(
                        height: 270,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: Container(
                          child: _controller.value.isPlaying
                              ? Container()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    color: Colors.black26,
                                    child: IconButton(
                                      onPressed: () =>
                                          _controller.value.isPlaying
                                              ? _controller.pause()
                                              : _controller.play(),
                                      icon: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      left: 5,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 5,
                                  child: VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            leading: Container(
                              width: 160,
                              child: Row(
                                children: <Widget>[
                                  ValueListenableBuilder(
                                    valueListenable: _controller,
                                    builder: (context, VideoPlayerValue value,
                                        child) {
                                      return Text(
                                        '${_videoDuration(value.position)} /',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      );
                                    },
                                  ),
                                  Text(
                                    _videoDuration(_controller.value.duration),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _controller.setVolume(isMuted ? 1 : 0),
                                    icon: Icon(
                                      isMuted
                                          ? Icons.volume_mute
                                          : Icons.volume_up,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Center(
              child: SpinKitFadingCircle(
                itemBuilder: (context, index) {
                  final colors = [
                    Colors.white,
                    Colors.blue,
                    Colors.indigo,
                    Colors.deepOrange
                  ];
                  final color = colors[index % colors.length];
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  );
                },
                size: 100,
              ),
            ),
    );
  }
}
