import 'package:flutter/material.dart';


class EmptySection extends StatelessWidget {
  final String? emptyImg, emptyMsg;
  const EmptySection({
    Key? key,
    this.emptyImg,
    this.emptyMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(emptyImg!),
            height: 150.0,
          ),
          Text(
            emptyMsg!,
            
          ),
        ],
      ),
    );
  }
}
