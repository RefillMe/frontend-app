// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    Login({
        this.id,
        this.username,
        this.roles,
        this.expiration,
        this.tokenType,
        this.accessToken,
    });

    int id;
    String username;
    List<String> roles;
    int expiration;
    String tokenType;
    String accessToken;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        id: json["id"],
        username: json["username"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        expiration: json["expiration"],
        tokenType: json["tokenType"],
        accessToken: json["accessToken"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "expiration": expiration,
        "tokenType": tokenType,
        "accessToken": accessToken,
    };
}
