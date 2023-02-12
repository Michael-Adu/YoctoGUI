import 'package:flutter/material.dart';

class YoctoOverlay extends StatefulWidget {
  @required
  bool overlayEnabled;
  @required
  Widget? overLay;
  Function? closeOverlay;
  YoctoOverlay(
      {this.overlayEnabled = false, this.overLay, this.closeOverlay, Key? key})
      : super(key: key);

  @override
  _YoctoOverlayState createState() => _YoctoOverlayState();
}

class _YoctoOverlayState extends State<YoctoOverlay> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Size windowSize = Size(constraints.maxWidth, constraints.maxHeight);
      return Container(
          width: windowSize.width,
          height: windowSize.height,
          decoration: BoxDecoration(
              color: widget.overlayEnabled
                  ? Colors.black.withOpacity(0.5)
                  : Colors.transparent),
          child: Stack(
            children: [
              InkWell(
                  onTap: () {
                    widget.closeOverlay!();
                  },
                  child: SizedBox(
                    width: windowSize.width,
                    height: windowSize.height,
                  )),
              widget.overlayEnabled ? widget.overLay! : Container()
            ],
          ));
    });
  }
}
