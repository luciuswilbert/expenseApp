import 'package:flutter/material.dart';

/// A reusable widget that creates a container with a curved bottom.
class CurvedBottomContainer extends StatelessWidget {
  /// The height of the container.
  final double height;

  /// The gradient used for the container background.
  final Gradient? gradient;

  /// Any child widget to display inside the container.
  final Widget? child;

  final Color? color; // ✅ Allow solid color

  const CurvedBottomContainer({
    super.key,
    this.height = 300, // default height
    this.gradient,
    this.color, // ✅ Accept color input
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedBottomClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color, // ✅ Use color if provided (default is null)
          gradient:
              color == null
                  ? gradient ??
                      const LinearGradient(
                        colors: [Color(0xFFF0E68C), Color(0xFFDAA520)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                  : null, // ✅ If color is set, disable gradient
        ),
        child: child, // No extra ClipPath inside!
      ),
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 1️⃣ 从左上角开始
    path.moveTo(0, 0);

    // 2️⃣ 右上角
    path.lineTo(size.width, 0);

    // 3️⃣ 右侧边缘向下到曲线起点
    double curveHeight = size.height * 0.08; // 控制曲线深度
    path.lineTo(size.width, size.height - curveHeight);

    // 4️⃣ 绘制底部的平滑弧形
    path.quadraticBezierTo(
      size.width / 2,
      size.height + curveHeight * 0.6, // 控制点（微微突出）
      0,
      size.height - curveHeight, // 终点回到左侧
    );

    // 5️⃣ 左侧边缘向上回到起点
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
