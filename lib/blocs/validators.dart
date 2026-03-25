import 'dart:async';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    // Change: Use String instead of Pattern
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(email))
      sink.add(email);
    else
      sink.addError('Please enter a valid email');
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 4) {
      sink.add(password);
    } else {
      sink.addError('Invalid password, please enter more than 4 characters');
    }
  });

  final validateText =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 3) {
      sink.add(name);
    } else {
      sink.addError('Invalid Text, please enter minimum 4 characters');
    }
  });

  final validatePhone =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    String pattern = r'^\+?[0-9\-\(\)\s]{7,15}$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(phone))
      sink.add(phone);
    else
      sink.addError('Invalid phone number format');
  });

  bool validateFormText(String txt) {
    if (txt.isEmpty) return true;
    return false;
  }

  bool isValidEmail(String input) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  bool isValidPhoneNumber(String input) {
    final RegExp regex = RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }
}

// Change: Return type and parameter updated to String?
String? evalPassword(String? value) {
  String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty) {
    return "password is Required";
  } else if (!regex.hasMatch(value))
    return 'please enter 8 chars alphanumeric password';
  else
    return null;
}

String? evalEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty) {
    return "email is required";
  } else if (!regex.hasMatch(value))
    return 'please enter valid email';
  else
    return null;
}

String? evalName(String? value) {
  if (value == null || value.length < 2) {
    return "please enter min. 2 chars text";
  }
  return null;
}

String? evalChar(String? value) {
  if (value == null || value.isEmpty) {
    return "please enter min. 1 chars text";
  }
  return null;
}

String? evalPhone(String? value) {
  String pattern = r'^\+?[0-9\-\(\)\s]{7,15}$';
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty) {
    return "phone is required";
  } else if (!regex.hasMatch(value))
    return 'Invalid phone number format';
  else
    return null;
}

final validatorBloc = Validators();
