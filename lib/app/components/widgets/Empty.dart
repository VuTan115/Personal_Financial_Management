import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/widgets.dart';

class MyEmptyWidget extends StatelessWidget {
  const MyEmptyWidget(
      {Key? key, this.message = 'Không có dữ liệu để hiện thị ròi!!!'})
      : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        child: EmptyWidget(
          image: null,
          packageImage: PackageImage.Image_1,
          title: message,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            color: Color(0xff9da9c7),
            fontWeight: FontWeight.w500,
          ),
          subtitleTextStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xffabb8d6),
          ),
        ),
      ),
    );
    ;
  }
}
