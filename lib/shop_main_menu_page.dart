import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopping/Product.dart';
import 'package:shopping/description.dart';
import 'package:shopping/post.dart';
import 'package:shopping/shop_bottom_navigator.dart';

class Store extends StatefulWidget {
  const Store({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  List<Post> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black45,
            fontFamily: 'Vazir',
          ),
        ),
        centerTitle: true,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black45,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_basket,
              color: Colors.black45,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          children: List.generate(
              // 15
              _items.length, (int position) {
            return generateItem(context, _items[position]);
          }),
        ),
      ),
      bottomNavigationBar: const ShopBottomNavigator(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[900],
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      // locaation floatingActionButton
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // after from tarif function fetchItem
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchItem();
  }

// after from add http in yaml
  void fetchItem() async {
    var url = Uri.parse("https://yasii76.000webhostapp.com/");
    Response res = await get(url);

    setState(() {
      var itemJson = jsonDecode(utf8.decode(res.bodyBytes));
      for (var item in itemJson) {
        var post = Post.fromJson(item);
        var product = Product(int.parse(item['id']), item['title'],
            item['content'], item['cost'], item['img_url']);
        _items.add(post);
        print(post.id);
      }
    });
    print(res.body);
  }
}

Card generateItem(context, Post post) {
  return Card(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    elevation: 8,
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Description(post: post)));
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 130,
              height: 130,
              child: Image.network(
                  // "https://res.cloudinary.com/atoms-shoes/image/upload/c_scale,w_1400,q_auto,f_auto/v1622733115/products/shoes/model000/black-white_profile")
                  post.imgUrl),
            ),
            Text(
              // "2000",
              post.cost,
              style: TextStyle(
                  fontFamily: "Vazir", color: Colors.red[700], fontSize: 16.0),
            ),
            Text(
              // "shoess ",
              post.title,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: 'Vazir',
                color: Color(0xFF575E67),
                fontSize: 14.0,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
