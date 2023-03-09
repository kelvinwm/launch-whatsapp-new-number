import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool err = false;
  String msgErr = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'KE';
  PhoneNumber number = PhoneNumber(isoCode: 'KE');

  @override
  void initState() {
    super.initState();
  }

  void whatsAppOpen() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var whatsappUrl = "whatsapp://send?phone=${number.phoneNumber}" "&text=${Uri.encodeComponent("Hello")}";
    try {
      final Uri _url = Uri.parse(whatsappUrl);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('New Number'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Container(
                  color: Colors.black.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      this.number = number;
                      // print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: true,
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    // inputBorder: const OutlineInputBorder(),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        whatsAppOpen();
                      }
                    },
                    child: const Text('Chat On WhatsApp'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
