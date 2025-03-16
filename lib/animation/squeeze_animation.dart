import 'package:flutter/material.dart';

class SqueezeAnimation extends StatefulWidget {
  final double normalHeight;
  final double squeezedHeight;
  final Widget child;

  const SqueezeAnimation({
    super.key,
    this.normalHeight = 350, // Normal (default) height
    this.squeezedHeight = 100, // Height when squeezed
    required this.child,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SqueezeAnimationState createState() => _SqueezeAnimationState();
}

class _SqueezeAnimationState extends State<SqueezeAnimation> {
  bool _isSqueezed = true;

  @override
  void initState() {
    super.initState();
    // Wait 700ms, then trigger the animation from squeezed to normal
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isSqueezed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      height: _isSqueezed ? widget.squeezedHeight : widget.normalHeight,
      width: double.infinity,
      child: widget.child,
    );
  }
}
