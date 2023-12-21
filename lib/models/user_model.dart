class UserModel {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? countryShortCode;
  String? countryCode;
  String? mobile;
  String? profileImage;
  String? referCode;
  String? notificationFlag;
  int? tradeCount;
  String? token;
  int? socialLogin;

  UserModel(
      {this.id,
      this.name,
      this.firstName,
      this.lastName,
      this.email,
      this.countryShortCode,
      this.countryCode,
      this.mobile,
      this.profileImage,
      this.referCode,
      this.notificationFlag,
      this.tradeCount,
      this.token,
      this.socialLogin});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    String name = json['name'];
    String firstName = json['first_name'];
    String lastName = json['last_name'];
    String email = json['email'];
    String countryShortCode = json['country_short_code'];
    String countryCode = json['country_code'];
    String mobile = json['mobile'];
    String profileImage = json['profile_image'];
    String referCode = json['refer_code'];
    String notificationFlag = json['notification_flag'];
    int tradeCount = json['trade_count'];
    String token = json['token'];
    int socialLogin = json['social_login'];

    return UserModel(
        id: id,
        name: name,
        firstName: firstName,
        lastName: lastName,
        email: email,
        countryShortCode: countryShortCode,
        countryCode: countryCode,
        mobile: mobile,
        profileImage: profileImage,
        referCode: referCode,
        notificationFlag: notificationFlag,
        tradeCount: tradeCount,
        token: token,
        socialLogin: socialLogin);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['country_short_code'] = countryShortCode;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    data['profile_image'] = profileImage;
    data['refer_code'] = referCode;
    data['notification_flag'] = notificationFlag;
    data['trade_count'] = tradeCount;
    data['token'] = token;
    data['social_login'] = socialLogin;
    return data;
  }
}
