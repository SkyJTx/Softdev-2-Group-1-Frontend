import 'package:flutter/material.dart';

class BlogBox extends StatelessWidget {
  const BlogBox({
    super.key,
    required this.title,
    this.category,
    required this.name,
    required this.like,
    required this.image,
    required this.onPressed,
  });
  final void Function()? onPressed;
  final ImageProvider<Object> image;
  final String title;
  final String? category;
  final String name;
  final String like;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            blurStyle: BlurStyle.normal,
            color: const Color.fromRGBO(0, 48, 73, 1).withOpacity(0.2),
            spreadRadius: 0.05,
            offset: const Offset(4, 4),
          )
        ],
      ),
      width: size.width * 0.4,
      child: RawMaterialButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: Colors.white,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            // IntrinsicHeight(
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(10),
            //       topRight: Radius.circular(10),
            //     ),
            //     child: Image(
            //       image: image,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              height: 35,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 48, 73, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        constraints: BoxConstraints(
                          maxWidth: size.width * 0.23,
                        ),
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            "#category",
                            style: TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.2,
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.1,
                        child: Text(
                          like,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
