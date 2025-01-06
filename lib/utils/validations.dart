bool isValidCPF(String cpf) {
  print("ENTROU");
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  if (cpf.length != 11) {
    return false;
  }

  if (RegExp(r'^(.)\1*\$').hasMatch(cpf)) {
    return false;
  }

  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(cpf[i]) * (10 - i);
  }

  int firstCheckDigit = 11 - (sum % 11);
  if (firstCheckDigit >= 10) {
    firstCheckDigit = 0;
  }

  if (firstCheckDigit != int.parse(cpf[9])) {
    return false;
  }

  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(cpf[i]) * (11 - i);
  }

  int secondCheckDigit = 11 - (sum % 11);
  if (secondCheckDigit >= 10) {
    secondCheckDigit = 0;
  }

  if (secondCheckDigit != int.parse(cpf[10])) {
    return false;
  }
  print("SAIU");
  return true;
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}
