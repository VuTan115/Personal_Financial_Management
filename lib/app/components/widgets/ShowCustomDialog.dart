import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_financial_management/app/components/colors/my_colors.dart';

class ShowCustomDialog extends StatefulWidget {
  const ShowCustomDialog(
      {Key? key,
      this.customDialogKey,
      required this.child,
      required this.bottomButton,
      required this.onSave})
      : super(key: key);
  final customDialogKey;
  final Widget child;
  final Widget bottomButton;
  final Function onSave;
  @override
  State<ShowCustomDialog> createState() => _ShowCustomDialogState();
}

class _ShowCustomDialogState extends State<ShowCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: MyAppColors.accent700,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1, color: MyAppColors.accent800)),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: widget.customDialogKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(child: widget.child),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 4,
                                primary: MyAppColors.accent800,
                                alignment: Alignment.center),
                            onPressed: () {
                              widget.onSave();
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.bottomButton,
                                ],
                              ),
                            ),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }


}
