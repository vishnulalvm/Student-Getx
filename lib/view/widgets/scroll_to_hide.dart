import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHide extends StatefulWidget {
  const ScrollToHide({
    super.key,
    required this.child,
    required this.scrollController,
    this.duration = const Duration(milliseconds: 300),
    required this.hideDirection,
    this.width,
    this.height,
  });
  final Widget child;
  final ScrollController scrollController;
  final Duration duration;
  final double? height;
  final Axis hideDirection;
  final double? width;

  @override
  State<ScrollToHide> createState() => _ScrollToHideState();
}

class _ScrollToHideState extends State<ScrollToHide> {
  bool isShown = true;

  @override
  void initState() {
    widget.scrollController.addListener(listen);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      opacity: isShown ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: widget.duration,
        height: widget.hideDirection == Axis.vertical
            ? (isShown ? widget.height : 0)
            : widget.height,
        width: widget.hideDirection == Axis.horizontal
            ? (isShown ? widget.width : 0)
            : widget.width,
        curve: Curves.linear,
        clipBehavior: Clip.none,
        child: Wrap(
          children: [
            widget.child,
          ],
        ),
      ),
    );
  }

  void show() {
    if (!isShown && mounted) {
      setState(() => isShown = true);
    }
  }

  void hide() {
    if (isShown && mounted) {
      setState(
        () => isShown = false,
      );
    }
  }

  void listen() {
    final direction = widget.scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }
}
