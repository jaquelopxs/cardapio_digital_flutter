import 'package:flutter/services.dart';

class PhoneMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Se estiver vazio, retorna vazio
    if (text.isEmpty) {
      return newValue;
    }

    // Remove tudo que não é dígito
    final cleanText = text.replaceAll(RegExp(r'\D'), '');
    
    // Limita a 11 dígitos (padrão celular brasileiro)
    final limitedText = cleanText.length > 11 
        ? cleanText.substring(0, 11) 
        : cleanText;

    final buffer = StringBuffer();
    
    for (int i = 0; i < limitedText.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      
      // Posição do hífen muda se for celular (11 dígitos) ou fixo (10 dígitos)
      if (limitedText.length == 11) {
        if (i == 7) buffer.write('-');
      } else {
        if (i == 6 && limitedText.length > 6) buffer.write('-');
      }
      
      buffer.write(limitedText[i]);
    }

    final string = buffer.toString();
    
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
