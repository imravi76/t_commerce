import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_commerce/widgets/custom_action_bar.dart';
import 'package:t_commerce/widgets/image_swipe.dart';

import 'constants.dart';

class ProductPage extends StatefulWidget {

  final int? productId;
  final String? title, price, description;
  final List? imageList;

  const ProductPage({Key? key, this.productId, this.title, this.price, this.description, this.imageList}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final SnackBar _cartSnackBar = const SnackBar(content: Text("Product added to the Cart"));
  final SnackBar _saveSnackBar = const SnackBar(content: Text("Product Saved!"));
  final SnackBar _removeSnackBar = const SnackBar(content: Text("Product removed"));

  bool savedAlready = false;
  bool cartAlready = false;

  @override
  void initState() {
    super.initState();
    checkSavedStatus();
    checkCartStatus();
  }

  Future<void> checkSavedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProductIds = prefs.getStringList('savedProductIds') ?? [];
    setState(() {
      savedAlready = savedProductIds.contains(widget.productId.toString());
    });
  }

  Future<void> checkCartStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final cartProductIds = prefs.getStringList('cartProductIds') ?? [];
    setState(() {
      cartAlready = cartProductIds.contains(widget.productId.toString());
    });
  }

  Future<void> _addToSaved() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedProductIds = prefs.getStringList('savedProductIds') ?? [];

    if (savedAlready) {
      savedProductIds.remove(widget.productId.toString());
    } else {
      savedProductIds.add(widget.productId.toString());
    }

    await prefs.setStringList('savedProductIds', savedProductIds);

    setState(() {
      savedAlready = !savedAlready;
    });
  }

  Future<void> _addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartProductIds = prefs.getStringList('cartProductIds') ?? [];

    if (cartAlready) {
      cartProductIds.remove(widget.productId.toString());
    } else {
      cartProductIds.add(widget.productId.toString());
    }

    await prefs.setStringList('cartProductIds', cartProductIds);

    setState(() {
      cartAlready = !cartAlready;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

      ListView(
      padding: const EdgeInsets.all(0),
      children: [

        ImageSwipe(imageList: widget.imageList),

        Padding(
          padding: const EdgeInsets.only(
              top: 24.0,
              left: 24.0,
              right: 24.0,
              bottom: 4.0
          ),
          child: Text(
            "${widget.title}",
            style: Constants.boldHeading,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 24.0,
          ),
          child: Text(
            "${widget.price}",
            style: const TextStyle(
                fontSize: 18.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.w600
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 24.0,
          ),
          child: Text(
            "${widget.description}",
            style: const TextStyle(
                fontSize: 16.0
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: savedAlready
                    ? () async{
                  ScaffoldMessenger.of(context).showSnackBar(_removeSnackBar);
                  await _addToSaved();
                }
                    : () async {
                  await _addToSaved();
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(_saveSnackBar);
                  });
                },

                child: Container(
                  width: 65.0,
                  height: 65.0,
                  decoration: BoxDecoration(
                    color: savedAlready ? Colors.black : const Color(0xFFDCDCDC),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.center,
                  child: Image(
                    image: const AssetImage(
                      "assets/images/tab_saved.png",
                    ),
                    color: savedAlready ? Colors.white : null,
                    height: 22.0,

                  ),
                ),
              ),
              Expanded(

                child: GestureDetector(
                  onTap: cartAlready
                      ? () async{
                    ScaffoldMessenger.of(context).showSnackBar(_removeSnackBar);
                    await _addToCart();
                  }
                      : () async {
                    await _addToCart();
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(_cartSnackBar);
                    });
                  },
                  child: Container(
                    height: 65.0,
                    margin: const EdgeInsets.only(
                      left: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cartAlready ? "Already added to Cart" : "Add to Cart",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

            ],
          ),
        )
      ],
    ),

          CustomActionBar(
            hasBackArrow: true,
          ),
        ],
      ),
    );
  }

}
