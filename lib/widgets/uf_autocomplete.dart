import 'package:flutter/material.dart';

class UFAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final String label;

   const UFAutocomplete({
    super.key,
    required this.controller,
    required this.label,
  });

  static const List<String> _estadosBrasil = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG',
    'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') return const Iterable<String>.empty();
        return _estadosBrasil.where((String option) {
          return option.contains(textEditingValue.text.toUpperCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
        // Sincroniza o valor inicial se estiver editando
        if (fieldController.text != controller.text) {
          fieldController.text = controller.text;
        }

        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: label),
          onChanged: (value) => controller.text = value.toUpperCase(),
          validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
        );
      },
    );
  }
}