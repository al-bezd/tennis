import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenis/apps/player/formatters/uppercase.dart';
import 'package:tenis/apps/tenis/models/game.dart';

class PlayerRegister extends StatefulWidget {
  const PlayerRegister({super.key});

  @override
  State<PlayerRegister> createState() => _PlayerRegisterState();
}

class _PlayerRegisterState extends State<PlayerRegister> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  bool isDataValid = false;

  bool get isPlayer1 => context.read<bool>();
  bool get isFieldsNotEmpty =>
      surnameController.text != "" && nameController.text != "";
  TenisGame get gameManager => context.read<TenisGame>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  label: const Text('Name'),
                  hintText: 'Enter your name',
                  enabledBorder: isDataValid
                      ? const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))
                      : null,
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red))),
              validator: validates,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              onChanged: (value) {
                if (isFieldsNotEmpty) {
                  setState(() {});
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: surnameController,
              decoration: InputDecoration(
                  label: const Text('Surname'),
                  hintText: 'Enter your surname',
                  enabledBorder: isDataValid
                      ? const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))
                      : null,
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red))),
              validator: validates,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              onChanged: (value) {
                
                  setState(() {});
                
              },
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: isFieldsNotEmpty ? signUp : null,
              child: const Text("Start"),
            )
          ],
        ),
      ),
    );
  }

  String? validates(String? val) {
    if (val!.isEmpty) return 'field must not be empty';
    if (val.length < 4) return 'value must be at least 4 characters long';
    return null;
  }

  void signUp() {
    setState(() {
      isDataValid = _formKey.currentState!.validate();
      if (isDataValid) {
        gameManager.addPlayer(
            name: nameController.text,
            surename: surnameController.text,
            isPlayer1: isPlayer1);
      }
    });
  }
}
