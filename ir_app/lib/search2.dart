import 'package:flutter/material.dart';
import 'package:ir_app/api_service2.dart';

class SearchTwo extends StatefulWidget {
  const SearchTwo({Key? key}) : super(key: key);

  @override
  State<SearchTwo> createState() => _SearchTwoState();
}

class _SearchTwoState extends State<SearchTwo> {
  TextEditingController id = TextEditingController();
  TextEditingController query = TextEditingController();
  List<dynamic> searchResultsTwo = [];

  bool _isLoading = false;

  set isLoading(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Information Retrieval",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: 700,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: TextFormField(
                    controller: id,
                    onChanged: (val) {
                      print(val);
                    },
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      hintText: 'Id',
                      //hintStyle: searchStyle,
                      isDense: true,
                      prefixIcon: IconButton(
                        onPressed: () {
                          // controller.onSearchDoctors();
                          //    controller.search();
                        },
                        icon: Icon(Icons.numbers),
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: TextFormField(
                    controller: query,
                    onChanged: (val) {
                      print(val);
                    },
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      hintText: 'Query',
                      prefixIcon: IconButton(
                        onPressed: () {
                          // controller.onSearchDoctors();
                          //    controller.search();
                        },
                        icon: Icon(Icons.text_fields),
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /* ElevatedButton(
            onPressed: () async {

              final idText = id.text;
              final queryText = query.text;
              final results = await ApiService.search_two(idText, queryText);
              print(results);
              if (results != null && results.isNotEmpty) { // Check if results is not empty
                setState(() {
                  searchResults = results[1];
                });
              }

            },
            child: Text('Search'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
            ),
          ),*/

          ElevatedButton(
            onPressed: () async {
              searchAya(id.text, query.text);
            }, // searchAya(id.text,query.text),
            child: Text(
              'Search',
              style: TextStyle(color: Colors.black),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: searchResultsTwo.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                          // Center(
                          //   child: ListTile(
                          //     title: Text(searchResultsTwo[index][0]),
                          //     subtitle: Text(searchResultsTwo[index][1].toString()),
                          //   ),
                          // );

                          Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(searchResultsTwo[index][0]),
                            const SizedBox(height: 10),
                            Text(searchResultsTwo[index][1].toString()),
                            const SizedBox(height: 10),
                            Text(searchResultsTwo[index].asMap().containsKey(2)
                                ? searchResultsTwo[index][2].toString()
                                : "Document content is not available"),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future searchAya(id, query) async {
    isLoading = true;
    final results = await ApiService2.searchSecond(id, query);
    print(results);
    if (results != null && results.isNotEmpty) {
      // Check if results is not empty
      setState(() {
        searchResultsTwo = results[1];
      });
    }
    isLoading = false;
    return;
  }
}
