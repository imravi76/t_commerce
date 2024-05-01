
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_action_bar.dart';
import '../widgets/product_card.dart';

class HomeTab extends StatefulWidget {

  HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<dynamic> products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://api.escuelajs.co/api/v1/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      // Failed to fetch products
      print('Failed to fetch products: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [

          ListView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.only(
                top: 108.0,
                bottom: 12.0
            ),
            itemBuilder: (context, index){
              final product = products[index];
              return ProductCard(
                productId: product['id'],
                title: product['title'],
                price: "₹${product['price']}",
                imageUrl: product['images'][0],
                imageList: product['images'],
                description: product['description'],
              );
            },
          ),

          CustomActionBar(
            hasBackArrow: false,
            hasTitle: true,
            hasBackground: true,
            title: "Home",
          )

        ],
      ),
    );
  }
}
