class Contact {
  final int id;
  final String name;
  final int account;

  Contact(
    this.id,
    this.name,
    this.account,
  );

  @override
  String toString() {
    return 'Contact{id:$id,name: $name, account: $account}';
  }

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        account = json['accountNumber'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'accountNumber': account,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          account == other.account;

  @override
  int get hashCode => name.hashCode ^ account.hashCode;
}
