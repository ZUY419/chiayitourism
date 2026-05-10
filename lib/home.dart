import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:ui';

import 'map.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => MapPageData(),
    child: const App(),
  ),
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // 拆分出一個新的 Widget 確保 MediaQuery 正常
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late double sw;
  late double sh;
  late int loadingImage;
  late String mapLoadingState;
  late bool isMapLoadingFinish;

  String appIconImage = "assets/images/background.webp";

  @override
  void initState() {
    super.initState();
    loadingImage = Random().nextInt(3) + 1;

    // 使用 Future.microtask 確保在第一幀畫完後啟動
    Future.microtask(() {
      context.read<MapPageData>().getFinish();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 監聽進度變化
    mapLoadingState = context.watch<MapPageData>().mapLodingState;
    isMapLoadingFinish = context.watch<MapPageData>().loadingFinish;

    // 現在這裡可以安全使用 MediaQuery 了
    sw = MediaQuery.of(context).size.width;
    sh = MediaQuery.of(context).size.height;

    var homeBody = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 如果還沒載入完成，點擊任何地方都觸發 getImage
        if (isMapLoadingFinish) {
          print("進到 Login Page");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapPage())
            );
        }
      },
      child: Container(
        width: sw,
        height: sh,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/loading/loading_$loadingImage.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),

            // App Icon
            _buildAppIcon(),

            // 文字按鈕 & 載入畫面
            Positioned(
              bottom: isMapLoadingFinish ? sh * 0.1 : sh * 0.02,
              child: isMapLoadingFinish ? _buildHint() : _buildLoadingState()
            )
          ],
        ),
      )
    );

    return Scaffold(
      body: homeBody,
    );
  }

  Widget _buildAppIcon() {
    return Positioned(
      top: sh * 0.2,
      child: Container(
        width: sw,
        height: sh * 0.2,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // 設定形狀為圓形
          border: Border.all(color: Colors.white, width: 4), // 白色邊框
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
          image: DecorationImage(
            image: AssetImage("assets/images/appIcon.webp"),
            // fit: BoxFit.cover,
          ),
        ),
      )
    );
  }

  Widget _buildHint() {
    return Container(
      height: sh * 0.25,
      width: sw,
      child: Center(
        child: Stack(
          children: [
            Column(
              children: [
                _buildText("點擊開始", true),
                _buildText("探索嘉義吧!", true),
              ],
            ),
            Column(
              children: [
                _buildText("點擊開始", false),
                _buildText("探索嘉義吧!", false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
        height: sh * 0.1,
        width: sw,
        child: Center(
            child: Stack(
              children: [
                _buildText(mapLoadingState, true),
                _buildText(mapLoadingState, false),
              ],
            )
        )
    );
  }

  Widget _buildText(String content, bool isOutline) {
    return Text(
      content,
      style: TextStyle(
        fontFamily: 'JasonHandwriting1',
        fontSize: isMapLoadingFinish ? 60 : 20,
        fontWeight: isOutline ? FontWeight.w900 : FontWeight.w600, // 使用較粗的字體輪廓才明顯
        foreground: isOutline
            ? (Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6      // 輪廓的粗細
          ..color = Colors.white
          ..isAntiAlias = true // 關鍵：讓邊緣平滑
          ..strokeCap = StrokeCap.round // 讓筆畫轉折處圓潤一點
          ..strokeJoin = StrokeJoin.round // 讓轉角處不尖銳
        ) // 輪廓的顏色
            : null,
        color: isOutline ? null : Colors.black, // 如果不是外框，就顯示白色本體
      ),
    );
  }
}