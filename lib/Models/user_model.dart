class UserModel {
  final int id;
  final String email;
  final String password;
  final String name;
  final String avatar;
  final int amount;

  UserModel(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.avatar,
      this.amount});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        name: json['name'],
        amount: json['amount'],
        avatar: json['avatar']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['amount'] = this.amount;
    return data;
  }
}
