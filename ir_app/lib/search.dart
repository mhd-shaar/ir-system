import 'package:flutter/material.dart';
import 'package:ir_app/api_service.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _isLoading = false;

  set isLoading(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  TextEditingController id = TextEditingController();
  TextEditingController query = TextEditingController();
  List<dynamic> searchResults = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Information Retrieval System",
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
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      hintText: 'Id',
                      //hintStyle: searchStyle,
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
          ElevatedButton(
            onPressed: () async {
              isLoading = true;
              final idText = id.text;
              final queryText = query.text;
              final results = await ApiService.search(idText, queryText);
              print(results);
              if (results != null && results.isNotEmpty) {
                // Check if results is not empty
                setState(() {
                  searchResults = results[1];
                });
              }
              isLoading = false;
            },
            child: Text('Search',style: TextStyle(color: Colors.black),),
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
                    itemCount: searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
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
                            Text(searchResults[index][0]),
                            const SizedBox(height: 10),
                            Text(searchResults[index][1].toString()),
                            const SizedBox(height: 10),
                            Text(searchResults[index].asMap().containsKey(2)
                                ? searchResults[index][2].toString()
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
}
