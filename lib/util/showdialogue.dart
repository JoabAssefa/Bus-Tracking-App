import 'textstyles.dart';
import 'package:flutter/material.dart';

class CustomizedDialog {
  customizedDialog(BuildContext context,
      {required String title,
      String? subTitle,
      String? subTitle1,
      Icon? icon,
      Color? color,
      double? height,
      double? width,
      List<Widget>? buttons,
      bool? barrierDismisal,
      Color? iconColor}) {
    return showDialog(
        context: context,
        barrierDismissible: barrierDismisal ?? true,
        builder: (context) {
          return Center(
            child: Container(
              height: height == null ? 350 : height + 50,
              width: width ?? 350,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: height ?? 300,
                      width: width ?? 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 25, left: 5, right: 5, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: MyTextStyle().title,
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Text(
                              subTitle ?? "",
                              style: MyTextStyle().subtitle1,
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Text(
                              subTitle1 ?? "",
                              style: MyTextStyle().subtitle2,
                            ),
                            Spacer(
                              flex: 4,
                            ),
                            Wrap(
                              spacing: 20,
                              runSpacing: 10,
                              children: buttons ?? [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: color ?? Color(0xFFFF9B37),
                          borderRadius: BorderRadius.circular(50)),
                      child: icon ??
                          Icon(
                            Icons.agriculture,
                            color: iconColor ?? Colors.blue,
                            size: 35,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
