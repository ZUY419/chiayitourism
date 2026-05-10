import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class MapPageData extends ChangeNotifier {
  bool loadingFinish = false;
  int totalStep = 1;
  int step = 0;
  String mapLodingState = "0/1";

  Future<void> getFinish() async {
    await Future.delayed(Duration(seconds: 1));

    loadingFinish = true;
    notifyListeners();
  }
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late double sw, sh;

  @override
  Widget build(BuildContext context) {
    // 現在這裡可以安全使用 MediaQuery 了
    sw = MediaQuery.of(context).size.width;
    sh = MediaQuery.of(context).size.height;

    var homeBody = Container(
      width: sw,
      height: sh,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.webp"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // 模糊背景
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          // title
          Container(
            width: sw,
            height: sh * 0.11,
            decoration: BoxDecoration(
              color: const Color(0xFF9AB17A),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF313E17),
                    blurRadius: 10,
                  spreadRadius: 2
                ),
              ],
            ),
            child: Stack(
              children: [

              ],
            ),
          ),

          // Map
          Positioned(
            bottom: sh * 0.02,
            left: sh * 0.02,
            right: sh * 0.02,
            child:  Container(
              height: sh * 0.80,
              decoration: BoxDecoration(
                // color: const Color(0xFF9AB17A),
                border: Border.all(
                  color: const Color(0xFF2F6B3F),
                  width: 5
                ), // 白色邊框
              ),
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(23.4920, 120.4550), // 預設顯示嘉義市中心
                  initialZoom: 12.4,
                  interactionOptions: InteractionOptions(
                    // 允許大部分互動，但禁用旋轉功能以保持地圖北向上
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    // 務必設定自定義 User-Agent 以符合規範
                    userAgentPackageName: 'com.your_app.name',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(23.4920, 120.4550),
                        width: 80,
                        height: 80,
                        child: Icon(Icons.location_on, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              )
            ),
          )
        ],
      ),
    );

    return Scaffold(
      body: homeBody,
    );
  }
}