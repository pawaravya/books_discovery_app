import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomInputText extends StatefulWidget {
  String labelText;
  String hintText;
  bool? isSuffixIcon;
  bool? isPrefixIcon;
  final TextEditingController? textEditingController;
  bool isSecure;

  bool isFlag;

  TextInputType keyboardType;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  String errorText;
  String prefixIconPath = "";
  int? maxLength = 50;
  bool? enable;
  bool isBgTransperant;
  final Function? onChanged;
  double? cornerRadius;
  double? height = 41;
  List<TextInputFormatter>? inputFormatters;
  bool readOnly;
  String? disableTextFieldColor ;
  String? disableTextColor ;
  bool isMandatory;
  bool isErrorBorder;
  Function()? onSuffixIconTap;
  Function(String)? onSubmitted;
  bool isFirstLetterCapital;
  bool isForSearch;
  EdgeInsets? contentPadding;
  String suffixIconPath;

  CustomInputText({
    super.key,
    required this.labelText,
    required this.hintText,
    this.isSuffixIcon,
    this.keyboardType = TextInputType.text,
    this.textEditingController,
    required this.isSecure,
    this.onEditingComplete,
    this.textInputAction,
    this.focusNode,
    this.errorText = "",
    this.isPrefixIcon,
    this.prefixIconPath = "",
    this.isFlag = false,
    this.maxLength,
    this.enable = true,
    this.onChanged,
    this.isBgTransperant = false,
    this.cornerRadius = 10,
    this.inputFormatters,
    this.readOnly = false,
    this.height = 41,
    this.disableTextFieldColor ,
    this.isMandatory = false,
    this.isErrorBorder = false,
    this.onSuffixIconTap,
    this.onSubmitted,
    this.isFirstLetterCapital = false,
    this.isForSearch = false,
    this.contentPadding,
    this.suffixIconPath = "",
    this.disableTextColor 
  });

  @override
  State<CustomInputText> createState() => _GetTextFieldState();
}

class _GetTextFieldState extends State<CustomInputText> {
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      setState(() {
        isFocused = widget.focusNode!.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // bool showLabel =
    //     isFocused || (widget.textEditingController?.text.isNotEmpty == true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != "")
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RichText(
              text: TextSpan(
                text: widget.labelText,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                 
                  color: HexColor(ColorConstants.blackColor),
                ),
                
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: HexColor(ColorConstants.whiteColor) ,
            borderRadius: BorderRadius.circular(widget.cornerRadius! ),
          ),
          height: widget.height,
          child: TextField(
            style: TextStyle(
              // fontFamily: Constants.interFontFamily,
              fontSize: 14,
              color: HexColor(ColorConstants.blackColor)
            ),
            textCapitalization:
                widget.keyboardType == TextInputType.emailAddress
                    ? TextCapitalization.none
                    : TextCapitalization.sentences,
            inputFormatters: widget.inputFormatters ?? [],
            onChanged: (value) {
              setState(() {});
              if (widget.onChanged != null) {
                // widget.onChanged!();
              }
            },
            onSubmitted: (val) {
              if (widget.onSubmitted != null) {
                widget.onSubmitted!(val);
              }
            },

            onEditingComplete: widget.onEditingComplete,
            // If isFlag => forcibly readOnly, but visually "regular" style
            // readOnly: widget.isFlag
            //     ? true
            //     : (widget.enable == false ? true : widget.readOnly),
            maxLength: widget.maxLength,
            focusNode: widget.focusNode,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            controller: widget.textEditingController,
            cursorColor: Colors.black,
            obscureText: widget.isSecure,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                // fontFamily: Constants.interFontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 13,
                letterSpacing: 0,
                color:
                    HexColor(ColorConstants.blackColor),
              ),
              counterText: "",
              suffixIcon: widget.isSuffixIcon != null
                  ? widget.suffixIconPath != ""
                      ? IconButton(
                          onPressed: () {
                            if (widget.onSuffixIconTap != null) {
                              widget.onSuffixIconTap!();
                            }
                          },
                          icon: SvgPicture.asset(
                            widget.suffixIconPath,
                            color: widget.isForSearch
                                ? HexColor(ColorConstants.blackColor)
                                : null,
                          ))
                      : IconButton(
                          iconSize: 16,
                          icon: widget.isSecure
                              ? SvgPicture.asset(
                                  ImageConstants.eyeOffImage,
                                  color: widget.isErrorBorder
                                      ? Colors.red
                                      : null,
                                )
                              : SvgPicture.asset(
                                  ImageConstants.eyeImage,
                                  color: widget.isErrorBorder
                                      ? Colors.red
                                      : null,
                                ),
                          onPressed: () {
                            if (widget.onSuffixIconTap != null) {
                              widget.onSuffixIconTap!();
                            }
                          },
                        )
                  : null,
              border:
                  widget.enable == true && !widget.isFlag ? getBorder() : null,
              focusedBorder: getBorder(),
              enabledBorder: getBorder(),
              errorBorder: getBorder(),
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.only(left: 10, top: 0, bottom: 0),
            ),
          ),
        ),
        Visibility(
          visible: widget.errorText.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              widget.errorText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 4, // Restrict to a single line
            ),
          ),
        )
      ],
    );
  }

  InputBorder getBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      widget.cornerRadius !
    ),
    borderSide: const BorderSide(
      color: Colors.black, // 👈 Black border
      width: 1.0,
    ),
  );
}

}
