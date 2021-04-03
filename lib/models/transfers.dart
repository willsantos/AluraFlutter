class transfer {
  final double value;
  final int accountNumber;

  transfer(
    this.value,
    this.accountNumber,
  );

  @override
  String toString() {
    return 'Transferencia{valor: $value, numeroConta: $accountNumber}';
  }
}
