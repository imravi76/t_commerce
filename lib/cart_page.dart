
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:t_commerce/product_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  List<int> cartProductIds = [];
  List<Product> cartProducts = [];

  @override
  void initState() {
    super.initState();
    fetchCartProducts();
  }

  Future<void> fetchCartProducts() async {

    final savedIds = await SharedPreferences.getInstance().then((prefs) => prefs.getStringList('cartProductIds') ?? []);
    setState(() {
      cartProductIds = savedIds.map((id) => int.parse(id)).toList(); // Convert strings to integers
    });

    final List<Product> products = [];
    for (final productId in cartProductIds) {
      final product = await fetchProductDetails(productId);
      if (product != null) {
        products.add(product);
      }
    }

    setState(() {
      cartProducts = products;
    });
  }

  Future<Product?> fetchProductDetails(int productId) async {
    final url = 'https://api.escuelajs.co/api/v1/products/$productId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Product.fromJson(json);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartProducts.isEmpty
          ? Center(child: Text('No products'))
          : ListView.builder(
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          final product = cartProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                    productId: product.id,
                    imageList: product.imageList,
                    title: product.title,
                    description: product.description,
                    price: "₹${product.price}",
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        product.imageList[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '₹${product.price}',
                            style: TextStyle(fontSize: 16.0, color: Colors.deepOrange, fontWeight: FontWeight.w600),
                          ),
                        ),

                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      deleteProduct(index);
                    },
                    child: Icon(
                      Icons.delete,
                      size: 40.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> deleteProduct(int index) async {

    final productId = cartProducts[index].id;

    setState(() {
      cartProducts.removeAt(index);
    });

    cartProducts.remove(productId);

    final List<String> stringProductIds = cartProducts.map((id) => id.toString()).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cartProductIds', stringProductIds);
  }
}

class Product {
  final int id;
  final String title;
  final int price;
  final String description;
  final List imageList;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageList,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      imageList: json['images'], // Use the first image URL for simplicity
    );
  }
}
