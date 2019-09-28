library flutter_math_widget;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'dart:ui';
import 'package:intl/intl.dart' as intl;

const String cdot = '\u22C5';
const String plus = '\u002B';
const String minus= '\u2212';
const String plusminus = '\u2213';

// Greek Letters
const String alpha = '\u03B1';
const String beta = '\u03B2';
const String gamma = '\u03B3';
const String Gamma = '\u0393';
const String delta = '\u03B4';
const String Delta = '\u0394';
const String epsilon = '\u03B5';
// const String varepsilon = '\u03B2';
const String zeta = '\u03B6';
const String eta = '\u03B7';
const String theta = '\u03B8';
const String Theta = '\u0398';
const String vartheta = '\u03D1';
const String iota = '\u03B9';
const String kappa = '\u03BA';
const String lambda = '\u03BB';
const String Lambda = '\u039B';
const String mu = '\u03BC';
const String nu = '\u03BD';
const String xi = '\u03BE';
const String Xi = '\u039E';
const String pi = '\u03C0';
const String Pi = '\u03A0';
const String rho = '\u03C1';
const String sigma = '\u03C3';
const String Sigma = '\u03A3';
const String tau = '\u03C4';
const String upsilon = '\u03C5';
const String phi = '\u03C6';
const String Phi = '\u03A6';
const String varphi = '\u03D5';
const String chi = '\u03C7';
const String psi = '\u03C8';
const String Psi = '\u03A8';
const String omega = '\u03C9';
const String Omega = '\u03A9';

class MathWidget extends SingleChildRenderObjectWidget {
  const MathWidget(
    this.formular, {
    this.color,
    this.size,
    this.weight,
    this.variant,
    this.alignment: Alignment.center,
    key,
  }) : super(
          key: key,
        );

  final MathRenderBox formular;
  final Alignment alignment;
  final FontWeight weight;
  final FontStyle variant;
  final Color color;
  final double size;

  @override
  RenderPositionedBox createRenderObject(BuildContext context) =>
      RenderMathWidget(formular,
          color: color,
          size: size,
          weight: weight,
          variant: variant,
          alignment: alignment);
}

class RenderMathWidget extends RenderPositionedBox with MathRenderBox {
  RenderMathWidget(
    child, {
    Color color,
    double size,
    FontWeight weight,
    FontStyle variant,
    Alignment alignment,
  }) : super(child: child, alignment: alignment) {
    init(color, size, weight, variant);
  }
}

mixin MathRenderBox on RenderBox {
  double _fontSize;
  set fontSize(double value) {
    _fontSize = value;
  }

  get fontSize {
    return _fontSize ?? 22.0;
  }

  Color _color;
  set color(Color value) {
    _color = value;
  }

  get color {
    return _color ?? Colors.black;
  }

  FontWeight _fontWeight;
  set fontWeight(FontWeight value) {
    _fontWeight = value;
  }

  get fontWeight {
    return _fontWeight ?? FontWeight.normal;
  }

  FontStyle _fontVariant;
  set fontVariant(FontStyle value) {
    _fontVariant = value;
  }

  get fontVariant {
    return _fontVariant ?? FontStyle.normal;
  }

  @protected
  void init(Color color, double size, FontWeight weight, FontStyle variant) {
    this.color = color;
    this.fontSize = size;
    this.fontWeight = weight;
    this.fontVariant = variant;
  }

  @protected
  MathRenderBox getParent() {
    return parent;
  }

  @protected
  void _performLayout() {
    MathRenderBox parent = getParent();

    if (parent != null) {
      color = _color ?? parent.color;
      fontSize = _fontSize ?? parent.fontSize;
      fontWeight = _fontWeight ?? parent.fontWeight;
      fontVariant = _fontVariant ?? parent.fontVariant;
    }
  }
}

// The MathML <msup> element is used to attach a superscript to an expression.
// It uses the following syntax: <msup> base superscript </msup>.
class MSup extends RenderWrap with MathRenderBox {
  MSup(
    RenderBox child,
    RenderBox superscript, {
    Color color,
    double size,
    FontWeight weight,
    FontStyle variant,
  }) : super(children: [child, superscript], direction: Axis.horizontal) {
    init(color, size, weight, variant);
  }

  @override
  void performLayout() {
    _performLayout();

    final MathRenderBox rb = lastChild;
    rb.fontSize = fontSize * 0.7;

    firstChild.layout(BoxConstraints.tightForFinite(), parentUsesSize: true);
    lastChild.layout(BoxConstraints.tightForFinite(), parentUsesSize: true);

    size = Size(firstChild.size.width + 1 + lastChild.size.width,
        firstChild.size.height + 3);

    final BoxParentData firstChildParentData = firstChild.parentData;
    firstChildParentData.offset = Offset.zero;

    final BoxParentData lastChildParentData = lastChild.parentData;
    lastChildParentData.offset = Offset(size.width - lastChild.size.width, -3);
  }
}

// The MathML <mi> element indicates that the content should be rendered as an
// identifier such as function names, variables or symbolic constants. You can
// also have arbitrary text in it to mark up terms.
class MI extends RenderShiftedBox with MathRenderBox {
  MI(
    value, {
    Color color,
    double size,
    FontWeight weight,
    FontStyle variant = FontStyle.italic,
  }) : super(null) {
    init(color, size, weight, variant);
    prepare(value);
  }

  String value;
  TextPainter _textPainter;

  @protected
  void prepare(value) {
    this.value = value;
  }

  @override
  void performLayout() {
    _performLayout();
    _textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: fontVariant,
            fontFamily: 'stix'),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPainter.layout();

    size = _textPainter.size;
  }

  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(context.canvas, offset);
    super.paint(context, offset);
  }
}

class MN extends MI {
  final intl.NumberFormat formatter =
      intl.NumberFormat.decimalPattern(window.locale.toString());
  MN(
    num value, {
    Color color,
    double size,
    FontWeight weight,
    FontStyle variant = FontStyle.normal,
  }) : super(value, color: color, size: size, weight: weight, variant: variant);

  @protected
  void prepare(value) {
    this.value = formatter.format(value);
  }
}

class MO extends MI {
  MO(
    String value, {
    Color color,
    double size,
    FontWeight weight,
    FontStyle variant = FontStyle.normal,
  }) : super(value, color: color, size: size, weight: weight, variant: variant);

  @protected
  void prepare(dynamic value) {
    this.value = value.toString();
  }
}

class MRow extends RenderWrap with MathRenderBox {
  MRow(
    children, {
    Color color,
    double size,
    FontWeight weight,
    FontStyle variant = FontStyle.normal,
  }) : super(children: children, direction: Axis.horizontal, runSpacing: 2.0) {
    init(color, size, weight, variant);
  }

  @override
  void performLayout() {
    _performLayout();

    double height = 0.0;
    double width = 0.0;
    size = Size.zero;

    RenderBox child = firstChild;
    while (child != null) {
      child.layout(BoxConstraints.tightForFinite(), parentUsesSize: true);
      width += child.size.width;
      height = max(child.size.height, height);
      child = childAfter(child);
    }
    size = Size(width + (childCount - 1) * 4, height);

    child = firstChild;
    double dx = 0.0;
    while (child != null) {
      final BoxParentData childParentData = child.parentData;
      childParentData.offset =
          Offset(dx, size.height / 2 - child.size.height / 2);
      dx += child.size.width + 4;
      child = childAfter(child);
    }
  }
}

// The MathML <mfrac> element is used to display fractions.
class MFrac extends RenderWrap with MathRenderBox {
  MFrac(
    MathRenderBox numerator,
    MathRenderBox denominator, {
    Color color,
    double size,
    FontWeight weight,
    FontStyle variant = FontStyle.italic,
  }) : super(children: [numerator, denominator], direction: Axis.vertical) {
    init(color, size, weight, variant);
  }

  @override
  void performLayout() {
    _performLayout();
    firstChild.layout(BoxConstraints.tightForFinite(), parentUsesSize: true);
    lastChild.layout(BoxConstraints.tightForFinite(), parentUsesSize: true);

    size = Size(max(firstChild.size.width, lastChild.size.width),
        firstChild.size.height + lastChild.size.height);

    final BoxParentData firstChildParentData = firstChild.parentData;
    firstChildParentData.offset =
        Offset(size.width / 2 - firstChild.size.width / 2, 0);

    final BoxParentData lastChildParentData = lastChild.parentData;
    lastChildParentData.offset = Offset(
        size.width / 2 - lastChild.size.width / 2,
        size.height - lastChild.size.height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawLine(
        offset.translate(0, firstChild.size.height),
        offset.translate(size.width, firstChild.size.height),
        Paint()
          ..color = color
          ..strokeWidth = fontSize / 22);
    super.paint(context, offset);
  }
}

// The MathML <mfenced> element provides the possibility to add
// custom opening and closing parentheses (such as brackets)
class MFenced extends RenderShiftedBox with MathRenderBox {
  MFenced(
    child, {
    Color color,
    double size,
    FontWeight weight,
    FontStyle variant,
    this.open = '(',
    this.close = ')',
  }) : super(child) {
    init(color, size, weight, variant);
  }

  final String open;
  final String close;
  TextPainter _textPainterOpen;
  TextPainter _textPainterClose;

  @override
  void performLayout() {
    _performLayout();
    child.layout(BoxConstraints.tightForFinite(), parentUsesSize: true);

    _textPainterOpen = TextPainter(
      text: TextSpan(
        text: open,
        style: TextStyle(
          color: color,
          height: .9,
          fontSize: fontSize,
          fontFamily: 'stix',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPainterOpen.layout();

    _textPainterClose = TextPainter(
      text: TextSpan(
        text: close,
        style: TextStyle(
          color: color,
          height: .9,
          fontSize: fontSize,
          fontFamily: 'stix',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPainterClose.layout();

    size = Size(
        child.size.width +
            _textPainterOpen.size.width +
            0 +
            _textPainterClose.size.width +
            0,
        child.size.height);
    final BoxParentData childParentData = child.parentData;
    childParentData.offset = Offset(size.width / 2 - child.size.width / 2, 4);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.pushTransform(needsCompositing, offset,
        Matrix4.diagonal3Values(1, (child.size.height / fontSize), 1),
        (PaintingContext context, Offset offset) {
      _textPainterOpen.paint(context.canvas, offset);

      _textPainterClose.paint(
          context.canvas, Offset(offset.dx + size.width - _textPainterOpen.width, offset.dy));
    });
    super.paint(context, offset);
  }
}

// The MathML <msqrt> element is used to display square roots (no index is displayed).
class MSqrt extends RenderShiftedBox with MathRenderBox {
  MSqrt(child,
      {Color color,
      double size,
      FontWeight weight,
      FontStyle variant,
      int index = 0})
      : super(child) {
    init(color, size, weight, variant);
  }

  TextPainter _textPainter;

  @override
  void performLayout() {
    _performLayout();
    child.layout(BoxConstraints.tightForFinite(), parentUsesSize: true);

    _textPainter = TextPainter(
      text: TextSpan(
        text: '\u221A',
        style: TextStyle(
          color: color,
          height: 1.05,
          fontSize: fontSize + fontSize/5,
          fontFamily: 'stix',
          fontFeatures: [
            FontFeature('ss07'),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPainter.layout();

    size =
        Size(child.size.width + _textPainter.size.width, child.size.height + fontSize/5);
    final BoxParentData childParentData = child.parentData;
    childParentData.offset = Offset(_textPainter.size.width, size.height/2-child.size.height/2);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.pushTransform(needsCompositing, offset,
        Matrix4.diagonal3Values(.9, (child.size.height / fontSize), 1),
        (PaintingContext context, Offset offset) {
      _textPainter.paint(context.canvas, offset);
    });
    context.canvas.drawLine(
      Offset(offset.dx+_textPainter.size.width - (fontSize / 10 - fontSize / 100), offset.dy),
      Offset(offset.dx+size.width, offset.dy), 
        Paint()
          ..color = color
          ..strokeWidth = fontSize / 22);
    super.paint(context, offset);
  }
}