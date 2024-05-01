
import 'package:flutter/material.dart';

import '../constants.dart';
import '../product_page.dart';

class ProductCard extends StatelessWidget {

  final String? imageUrl, title, price, description;
  final Function? onPressed;
  final int? productId;
  final List? imageList;

  const ProductCard({Key? key, this.productId, this.imageUrl, this.title, this.price, this.onPressed, this.imageList, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final truncatedTitle =
    _truncateTitle(title, maxChars: 20);

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ProductPage(productId: productId,
            title: title,
            price: price,
            description: description,
            imageList: imageList,)
        )
        );
      },
      child: Container(

        child: Stack(
          children: [

            Container(
              height: 350.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      truncatedTitle!,
                      style: Constants.regularHeading,
                    ),
                    Text(
                      price!,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrange
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),

        height: 350.0,
        margin: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0
        ),

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0)
        ),

      ),
    );
  }
}

String _truncateTitle(String? title, {int maxChars = 20}) {
  if (title!.length <= maxChars) {
    return title;
  } else {
    return title.substring(0, maxChars) + '...';
  }
}
