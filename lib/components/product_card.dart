//import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//
//class ProductCard extends StatelessWidget {
//  const ProductCard({
//    Key key,
//    this.width = 140,
//    this.aspectRetio = 1.02,
//    @required this.goods,
//  }) : super(key: key);
//
//  final double width, aspectRetio;
//  final Goods goods;
//
//  getMoney(int pay) {
//    FlutterMoneyFormatter fmt = FlutterMoneyFormatter(amount: pay + .0);
//    return fmt.output.withoutFractionDigits;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return InkWell(
//      onTap: (){
//        print(goods.title + " 클릭해부렸당");
//        AppConfig.userRead().then((value) {
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) {
//                return ProductPage(goods, value);
//              })
//          ).then((val) => val ? Navigator.pushReplacement(context,
//              MaterialPageRoute(builder: (context) {
//                return ProductPage(goods, value);
//              })
//          ) : null);
//        });
//      },
//        child: Padding(
//      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
//      child: SizedBox(
//        width: getProportionateScreenWidth(width),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: [
//            AspectRatio(
//              aspectRatio: 1.02,
//              child: Container(
//                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
//                decoration: BoxDecoration(
//                  color: kSecondaryColor.withOpacity(0.1),
//                  borderRadius: BorderRadius.circular(10),
//                ),
//                child: Image.network(goods.imageUrl),
//              ),
//            ),
//            const SizedBox(height: 10),
//            Text(
//              goods.title,
//              style: TextStyle(color: Colors.black),
//              maxLines: 2,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Text(
//                  "${getMoney(goods.price)}원",
//                  style: TextStyle(
//                    fontSize: getProportionateScreenWidth(18),
//                    fontWeight: FontWeight.w600,
//                    color: kPrimaryColor,
//                  ),
//                ),
//                InkWell(
//                  borderRadius: BorderRadius.circular(50),
//                  onTap: () {
//                    print(goods.title + " 클릭");
//                  },
//                  child: Container(
//                    padding: EdgeInsets.all(getProportionateScreenWidth(8)),
//                    height: getProportionateScreenWidth(28),
//                    width: getProportionateScreenWidth(28),
//                    decoration: BoxDecoration(
//                      color: true
//                          ? kPrimaryColor.withOpacity(0.15)
//                          : kSecondaryColor.withOpacity(0.1),
//                      shape: BoxShape.circle,
//                    ),
//                    child: SvgPicture.asset(
//                      "assets/icons/Heart Icon_2.svg",
//                      color: true ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
//                    ),
//                  ),
//                ),
//              ],
//            )
//          ],
//        ),
//      ),
//    ));
//  }
//}
