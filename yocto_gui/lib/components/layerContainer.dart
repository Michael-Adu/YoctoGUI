import 'package:flutter/material.dart';
import 'package:yocto_gui/global.dart' as global;

class LayerContainer extends StatefulWidget {
  @required
  global.OpenEmbeddedLayers? layer;
  LayerContainer({this.layer, Key? key}) : super(key: key);

  @override
  _LayerContainerState createState() => _LayerContainerState();
}

class _LayerContainerState extends State<LayerContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Color(0xffD9D9D9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(5)),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.layer!.layerName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ElevatedButton(onPressed: () {}, child: Text("Add Layer"))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.layer!.description)),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.layer!.layerType,
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  )),
            ],
          )
        ]));
  }
}
