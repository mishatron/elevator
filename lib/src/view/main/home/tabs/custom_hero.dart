import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomHero extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final Object tag;
  final bool isRotate;
  final bool isScale;
  final HeroFlightShuttleBuilder flightShuttleBuilder;
  final CreateRectTween createRectTween;
  final TransitionBuilder placeholderBuilder;

  CustomHero(
      {this.isRotate = false,
        this.isScale = false,
        this.child,
        this.tag,
        this.flightShuttleBuilder,
        this.createRectTween,
        this.placeholderBuilder,
        this.onTap})
      : assert(child != null);

  @override
  _CustomHeroState createState() => _CustomHeroState();
}

class _CustomHeroState extends State<CustomHero>
    with SingleTickerProviderStateMixin {
  static RectTween _createRectTween(Rect begin, Rect end) {
    return QuadraticRectTweenCustom(begin: begin, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: _customHeroUI,
    );
  }

  Widget get _customHeroUI {
    return Hero(
      flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
          ) {
        final Hero toHero = toHeroContext.widget;

        if (widget.isRotate == true) {
          return RotationTransition(
            turns: animation,
            child: toHero.child,
          );
        } else if (widget.isScale == true) {
          return ScaleTransition(
            scale: animation.drive(
              Tween<double>(begin: 0.0, end: 1.0).chain(
                CurveTween(
                  curve: Interval(0.0, 1.0, curve: PeakQuadraticCurve()),
                ),
              ),
            ),
            child: toHero.child,
          );
        } else {
          return FadeTransition(
            opacity: animation.drive(
              Tween<double>(begin: 0.0, end: 1.0).chain(
                CurveTween(
                  curve: Interval(0.0, 1.0, curve: ValleyQuadraticCurve()),
                ),
              ),
            ),
            child: toHero.child,
          );
        }
      },
      placeholderBuilder: (context,size, child) {
        return Opacity(opacity: 0.1, child: child);
      },
      createRectTween: _createRectTween,
      tag: widget.tag,
      child: widget.child,

    );
  }
}

class PeakQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);

    return -15 * math.pow(t, 2) + 15 * t + 1;
  }
}

class ValleyQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);

    return 4 * math.pow(t - 0.5, 2);
  }
}

class QuadraticRectTweenCustom extends RectTween {
  /// Creates a [Tween] for animating [Rect]s along a circular arc.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is
  /// first used, but the arguments can be null if the values are going to be
  /// filled in later.
  QuadraticRectTweenCustom({
    Rect begin,
    Rect end,
  }) : super(begin: begin, end: end);

  bool _dirty = true;

  void _initialize() {
    assert(begin != null);
    assert(end != null);
    _centerArc = QuadraticOffsetTween(
      begin: begin.center,
      end: end.center,
    );
    _dirty = false;
  }

  /// If [begin] and [end] are non-null, returns a tween that interpolates along
  /// a circular arc between [begin]'s [Rect.center] and [end]'s [Rect.center].
  QuadraticOffsetTween get centerArc {
    if (begin == null || end == null) return null;
    if (_dirty) _initialize();
    return _centerArc;
  }

  QuadraticOffsetTween _centerArc;

  double lerpDouble(num a, num b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }

  @override
  set begin(Rect value) {
    if (value != begin) {
      super.begin = value;
      _dirty = true;
    }
  }

  @override
  set end(Rect value) {
    if (value != end) {
      super.end = value;
      _dirty = true;
    }
  }

  @override
  Rect lerp(double t) {
    if (_dirty) _initialize();
    if (t == 0.0) return begin;
    if (t == 1.0) return end;
    final Offset center = _centerArc.lerp(t);
    final double width = lerpDouble(begin.width, end.width, t);
    final double height = lerpDouble(begin.height, end.height, t);
    return Rect.fromLTWH(
        center.dx - width / 2.0, center.dy - height / 2.0, width, height);
  }

  @override
  String toString() {
    return '$runtimeType($begin \u2192 $end; centerArc=$centerArc)';
  }
}

class QuadraticOffsetTween extends Tween<Offset> {
  QuadraticOffsetTween({
    Offset begin,
    Offset end,
  }) : super(begin: begin, end: end);

  @override
  Offset lerp(double t) {
    if (t == 0.0) return begin;

    if (t == 1.0) return end;

    final double x = -11 * begin.dx * math.pow(t, 2) +
        (end.dx + 10 * begin.dx) * t +
        begin.dx;

    final double y =
        -2 * begin.dy * math.pow(t, 2) + (end.dy + 1 * begin.dy) * t + begin.dy;

    return Offset(x, y);
  }
}
