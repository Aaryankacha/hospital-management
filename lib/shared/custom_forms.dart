import 'package:flutter/material.dart';

class CustomFormRoundedTxt extends StatelessWidget {
  final Stream? streamBloc;
  final TextEditingController? controllerName; 
  final bool? obscureTxt;
  final ValueChanged<String>? onChangeTxt; 
  final Widget? iconTxt; 
  final String? hintTxt;
  final String? labelTxt;

  const CustomFormRoundedTxt({
    Key? key,
    this.streamBloc,
    this.controllerName,
    this.obscureTxt,
    this.onChangeTxt,
    this.iconTxt,
    this.hintTxt,
    this.labelTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: streamBloc,
        builder: (context, snapshot) {
          return Container(
              width: 350.0,
              margin: const EdgeInsets.only(top: 24.0),
              child: TextField(
                controller: controllerName,
                cursorColor: cPrimaryBlue,
                maxLength: 50,
                obscureText: obscureTxt ?? false,
                onChanged: onChangeTxt,
                decoration: InputDecoration(
                  prefixIcon: iconTxt,
                  suffixIcon: snapshot.hasError 
                    ? const Icon(Icons.error_outline, color: Colors.redAccent)
                    : (snapshot.hasData ? const Icon(Icons.check_circle_outline, color: Colors.green) : null),
                  hintText: hintTxt,
                  labelText: labelTxt,
                  errorText: snapshot.error?.toString(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ));
        });
  }
}

class CustomFormTxt extends StatelessWidget {
  final Stream? streamBloc;
  final int? boxLength;
  final bool? obscureTxt;
  final ValueChanged<String>? onChangeTxt;
  final Widget? iconTxt;
  final String? hintTxt;
  final String? labelTxt;

  const CustomFormTxt({
    Key? key,
    this.streamBloc,
    this.boxLength,
    this.obscureTxt,
    this.onChangeTxt,
    this.iconTxt,
    this.hintTxt,
    this.labelTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: streamBloc,
        builder: (context, snapshot) {
          return Container(
              width: 350.0,
              margin: const EdgeInsets.only(top: 16.0),
              child: TextField(
                cursorColor: cPrimaryBlue,
                maxLength: boxLength,
                obscureText: obscureTxt ?? false,
                onChanged: onChangeTxt,
                decoration: InputDecoration(
                  prefixIcon: iconTxt,
                  hintText: hintTxt,
                  labelText: labelTxt,
                  errorText: snapshot.error?.toString(),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ));
        });
  }
}

class CustomFormDataTxt extends StatelessWidget {
  final String? dbData;
  final bool? isEnabled;
  final Stream? streamBloc;
  final int? boxLength;
  final bool? obscureTxt;
  final ValueChanged<String>? onChangeTxt;
  final Widget? iconTxt;
  final String? hintTxt;
  final String? labelTxt;

  const CustomFormDataTxt({
    Key? key,
    this.dbData,
    this.isEnabled,
    this.streamBloc,
    this.boxLength,
    this.obscureTxt,
    this.onChangeTxt,
    this.iconTxt,
    this.hintTxt,
    this.labelTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtData = TextEditingController(text: dbData ?? "");

    return StreamBuilder(
        stream: streamBloc,
        builder: (context, snapshot) {
          return Container(
              width: 350.0,
              margin: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: txtData,
                cursorColor: cPrimaryBlue,
                enabled: isEnabled,
                maxLength: boxLength,
                obscureText: obscureTxt ?? false,
                onChanged: onChangeTxt,
                decoration: InputDecoration(
                  prefixIcon: iconTxt,
                  hintText: hintTxt,
                  labelText: labelTxt,
                  errorText: snapshot.error?.toString(),
                ),
              ));
        });
  }
}

class CustomInput extends StatelessWidget {
  final String? dbData;
  final int? boxLength;
  final bool? isEnabled;
  final bool? obscureTxt;
  final Widget? iconTxt;
  final String? hintTxt;
  final String? labelTxt;

  const CustomInput({
    Key? key,
    this.dbData,
    this.boxLength,
    this.isEnabled,
    this.obscureTxt,
    this.iconTxt,
    this.hintTxt,
    this.labelTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fix: Using standard controller initialization for pre-filled data
    final txt = TextEditingController(text: dbData ?? "");

    return Container(
      width: 300.0,
      margin: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: txt,
        enabled: isEnabled,
        cursorColor: Colors.blueAccent,
        maxLength: boxLength,
        obscureText: obscureTxt ?? false,
        decoration: InputDecoration(
          icon: iconTxt,
          hintText: hintTxt,
          labelText: labelTxt,
        ),
      ),
    );
  }
}
