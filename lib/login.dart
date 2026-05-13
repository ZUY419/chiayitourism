import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:io';

List<File> loadedImages = [];

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class LoginPageData extends ChangeNotifier {
  bool loadingFinish = false;
  int totalStep = 1;
  int step = 0;
  String loginLodingState = "0/1";
  Future<void> getImage() async {
    step = step + 1;
    loginLodingState = "$step/$totalStep 讀取圖片資訊";
    List<String> imagePath = ['assets/images/background.webp'];

    for(int i = 0;i < imagePath.length;i++) {
      File img = File(imagePath[i]);
      if (await img.exists()) {
        loadedImages.add(img);
      }
    }
    notifyListeners();
  }

  Future<void> getFinish() async {
    await Future.delayed(Duration(seconds: 1));

    loadingFinish = true;
    notifyListeners();
  }
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late int loadingImage;
  late double sw, sh;

  String appIconImage = "assets/images/background.webp";

  @override
  Widget build(BuildContext context) {
    // 現在這裡可以安全使用 MediaQuery 了
    sw = MediaQuery.of(context).size.width;
    sh = MediaQuery.of(context).size.height;
    loadingImage = Random().nextInt(3) + 1;

    var homeBody = Container(
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

          // 文字按鈕
          Positioned(
              bottom: sh * 0.1,
              child: Stack(
                children: [
                  _buildTextButton(true),
                  _buildTextButton(false),
                ],
              )
          )
        ],
      ),
    );

    return Scaffold(
      body: homeBody,
    );
  }

  Widget _buildTextButton(bool isOutline) {
    return Container(
      height: sh * 0.25,
      width: sw,
      child: Center(
        child: TextButton(
            onPressed: () {
              print("點擊了探索按鈕");
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,      // 移除預設內距，避免影響你原本的排版
              splashFactory: NoSplash.splashFactory, // 核心：取消水波紋
            ),
            child: Column(
              children: [
                _buildText("點擊開始", isOutline),
                _buildText("探索嘉義吧!", isOutline),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildText(String content, bool isOutline) {
    return Text(
      content,
      style: TextStyle(
        fontFamily: 'JasonHandwriting1',
        fontSize: 60,
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