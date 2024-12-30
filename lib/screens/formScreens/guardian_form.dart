import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc_app/models/guardian.dart';
import 'package:tcc_app/utils/validations.dart';

class GuardianForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSave;

  const GuardianForm({Key? key, this.initialData, required this.onSave})
      : super(key: key);

  @override
  _GuardianFormState createState() => _GuardianFormState();
}

class _GuardianFormState extends State<GuardianForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  GuardianType? _type;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'];
      _cpfController.text = widget.initialData!['cpf'];
      _phoneController.text = widget.initialData!['phone'];
      _emailController.text = widget.initialData!['email'];
      _type = GuardianType.values
          .firstWhere((e) => e.key == widget.initialData!['type']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            TextFormField(
              controller: _cpfController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                if (!isValidCPF(value)) {
                  return 'CPF inválido';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text;
                  if (text.length > 11) return oldValue;
                  String newText = '';
                  for (int i = 0; i < text.length; i++) {
                    if (i == 3 || i == 6) newText += '.';
                    if (i == 9) newText += '-';
                    newText += text[i];
                  }
                  return newValue.copyWith(
                    text: newText,
                    selection: TextSelection.collapsed(offset: newText.length),
                  );
                }),
              ],
              decoration: const InputDecoration(
                labelText: 'CPF',
              ),
            ),
            TextFormField(
              controller: _phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text;
                  if (text.length > 11) return oldValue;
                  String newText = '';
                  for (int i = 0; i < text.length; i++) {
                    if (i == 0) newText += '(';
                    if (i == 2) newText += ') ';
                    if (i == 7) newText += '-';
                    newText += text[i];
                  }
                  return newValue.copyWith(
                    text: newText,
                    selection: TextSelection.collapsed(offset: newText.length),
                  );
                }),
              ],
              decoration: const InputDecoration(
                labelText: 'Telefone',
              ),
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                if (!isValidEmail(value)) {
                  return 'Email inválido';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            DropdownButtonFormField<GuardianType>(
              value: _type,
              onChanged: (GuardianType? newValue) {
                setState(() {
                  _type = newValue;
                });
              },
              items: GuardianType.values
                  .map<DropdownMenuItem<GuardianType>>((GuardianType value) {
                return DropdownMenuItem<GuardianType>(
                  value: value,
                  child: Text(value.displayName),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Tipo',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSave({
                    'name': _nameController.text,
                    'cpf': _cpfController.text,
                    'phone': _phoneController.text,
                    'email': _emailController.text,
                    'type':
                        _type!.displayName, // Use displayName instead of key
                  });
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
