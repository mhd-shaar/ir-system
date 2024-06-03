import 'package:flutter/material.dart';
import 'package:ir_app/contstants.dart';
import 'package:ir_app/search.dart';
import 'package:ir_app/search2.dart';

class DropDownButton extends StatefulWidget {
  const DropDownButton({Key? key}) : super(key: key);

  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  List<String> datasets = ["life style", "writing"];
  String _selectedDataset = "life style";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedDataset.isNotEmpty) {
            if (_selectedDataset == "life style") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search()),
              );
            } else if (_selectedDataset == "writing") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchTwo()),
              );
            }
          }
        },
        icon: Icon(Icons.navigate_next_sharp),
        label: Text("Next"),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Information Retrieval",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: 700,
              child: Column(
                children: [
                  const SizedBox(
                    width: 700,
                  ),
                  const Text(
                    "Choose Dataset",
                    style: TextStyle(color: Colors.black45, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  DropdownButton(
                    isExpanded: true,
                    value: _selectedDataset,
                    items: datasets.map((dataset) {
                      return DropdownMenuItem(
                        child: Text(dataset),
                        value: dataset,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDataset = newValue.toString();
                      });
                      print("You selected: $_selectedDataset");
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: TextFormField(
                      initialValue: serverIp,
                      onChanged: (val) {
                        serverIp = val;
                      },
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        isDense: true,

                        filled: true,
                        fillColor: Colors.grey.shade50,
                        hintText: 'Server Ip Address',
                        //hintStyle: searchStyle,

                        prefixIcon: IconButton(
                          onPressed: () {
                            // controller.onSearchDoctors();
                            //    controller.search();
                          },
                          icon: const Icon(Icons.text_fields),
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
