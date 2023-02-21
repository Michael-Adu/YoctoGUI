import 'package:flutter/material.dart';
import 'package:yocto_gui/components/layerContainer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:yocto_gui/global.dart' as global;

class OpenEmbeddedLayerSelector extends StatefulWidget {
  const OpenEmbeddedLayerSelector({Key? key}) : super(key: key);

  @override
  _OpenEmbeddedLayerSelectorState createState() =>
      _OpenEmbeddedLayerSelectorState();
}

class _OpenEmbeddedLayerSelectorState extends State<OpenEmbeddedLayerSelector> {
  global.LayerBranches selectedBranch = global.LayerBranches("", Uri(), []);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: global.layersLoaded,
        builder: (context, value, widget) {
          if (global.layersLoaded.value) {
            if (selectedBranch.branchName == "") {
              selectedBranch = global.allLayers.first;
            }
          }
          return Container(
              width: MediaQuery.of(context).size.width * 0.732291667,
              color: Color(0xff181818),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  fillColor:
                                      Color(0xffD9D9D9).withOpacity(0.14),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  )),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.filter_alt_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () {}))
                      ]),
                  Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height * 0.111111111,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          items: global.layersLoaded.value
                              ? global.allLayers
                                  .map((e) => DropdownMenuItem<String>(
                                      value: e.branchName,
                                      child: Text(e.branchName)))
                                  .toList()
                              : [
                                  DropdownMenuItem<String>(
                                      child: Text("Loading..."),
                                      value: "Loading...")
                                ],
                          hint: Text('Branch: ${selectedBranch.branchName}',
                              style: TextStyle(color: Colors.white)),
                          dropdownDecoration:
                              BoxDecoration(color: Color(0xff373737)),
                          alignment: Alignment.centerLeft,
                          value: global.layersLoaded.value
                              ? selectedBranch.branchName
                              : "Loading...",
                          style: TextStyle(color: Colors.white),
                          onChanged: (value) {
                            if (global.layersLoaded.value) {
                              setState(() {
                                selectedBranch = global.allLayers[
                                    global.allLayers.indexWhere((element) =>
                                        element.branchName == value)];
                              });
                            }
                          },
                        ),
                      )),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: global.layersLoaded.value
                                  ? selectedBranch.layers
                                      .map((e) => Container(
                                          padding: EdgeInsets.all(20),
                                          child: LayerContainer(layer: e)))
                                      .toList()
                                  : [])))
                ],
              ));
        });
  }
}
