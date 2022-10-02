import 'dart:convert';

import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/book_list_response.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.isbn});
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookDetailResponse? detailBook;

  fetchDetailBookApi() async {
    print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/books/${widget.isbn}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    //print(await http.read(Uri.https('example.com', 'foobar.txt')));

    if (response.statusCode == 200) {
      final jsonDetail =
          jsonDecode(response.body); // dari string body menjadi sebuah json
      detailBook = BookDetailResponse.fromJson(
          jsonDetail); // melakukan parsing ke model dari json
      setState(() {});
      fetchSimiliarBookApi(detailBook!.title!);
    }
  }

  BookListResponse? similiarBooks;
  fetchSimiliarBookApi(String title) async {
    //print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/search/${title}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    //print(await http.read(Uri.https('example.com', 'foobar.txt')));

    if (response.statusCode == 200) {
      final jsonDetail =
          jsonDecode(response.body); // dari string body menjadi sebuah json
      similiarBooks = BookListResponse.fromJson(
          jsonDetail); // melakukan parsing ke model dari json
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetailBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail"),
        ),
        body: detailBook == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewScreen(
                                    imageUrl: detailBook!.image!),
                              ),
                            );
                          },
                          child: Image.network(
                            detailBook!.image!,
                            height: 150,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detailBook!.title!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  detailBook!.authors!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(Icons.star,
                                        color: index <
                                                int.parse(detailBook!.rating!)
                                            ? Colors.yellow
                                            : Colors.grey),
                                  ), //List.generate ini adalah fungsi perulangan
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  detailBook!.subtitle!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  detailBook!.price!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double
                          .infinity, // double.infinity itu lebarnya sepanjang layar
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            //fixedSize: Size(double.infinity, 50),
                            ),
                        onPressed: () {},
                        child: Text("BUY"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(detailBook!.desc!),
                    SizedBox(
                      height: 20,
                    ),
                    //OutlinedButton(onPressed: onPressed, child: child),
                    //TextButton(onPressed: onPressed, child: child),
                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Year: " + detailBook!.year!),
                        Text("ISBN " +
                            detailBook!.isbn13!), // tanda + untuk interpolasi
                        Text(detailBook!.pages! + " Pages"),
                        Text("Publisher: " + detailBook!.publisher!),
                        Text("Language: " + detailBook!.language!),
                        //Text(detailBook!.rating!),
                      ],
                    ),
                    Divider(),
                    similiarBooks == null
                        ? CircularProgressIndicator()
                        : Container(
                            height: 180,
                            child: ListView.builder(
                              // karena disini adalah sebuah listview dalam widget column tanpa mendefinisikan panjangnya maka digunakan shrinkWrap
                              shrinkWrap: true,
                              scrollDirection: Axis
                                  .horizontal, // ini untuk mengganti arah scroll Axis. horizontal or vertical
                              itemCount: similiarBooks!.books!.length,
                              //physics:NeverScrollableScrollPhysics(), ini fungsinya agar tidak muncul layar kosong, dan ini tidak memperbolehkan Axis untuk scroll jadi harus di comment
                              itemBuilder: ((context, index) {
                                final current = similiarBooks!.books![index];
                                return Container(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        current.image!,
                                        height: 100,
                                      ),
                                      Text(
                                        current.title!,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                  ],
                ),
              ));
  }
}
