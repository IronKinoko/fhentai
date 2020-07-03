// To parse this JSON data, do
//
//     final tagDb = tagDbFromJson(jsonString);

import 'dart:convert';

class TagDb {
  TagDb({
    this.head,
    this.version,
    this.repo,
    this.data,
  });

  Head head;
  int version;
  String repo;
  List<DatumElement> data;

  factory TagDb.fromRawJson(String str) => TagDb.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TagDb.fromJson(Map<String, dynamic> json) => TagDb(
        head: Head.fromJson(json["head"]),
        version: json["version"],
        repo: json["repo"],
        data: List<DatumElement>.from(
            json["data"].map((x) => DatumElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "head": head.toJson(),
        "version": version,
        "repo": repo,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumElement {
  DatumElement({
    this.namespace,
    this.frontMatters,
    this.count,
    this.data,
  });

  String namespace;
  FrontMatters frontMatters;
  int count;
  Map<String, DatumValue> data;

  factory DatumElement.fromRawJson(String str) =>
      DatumElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumElement.fromJson(Map<String, dynamic> json) => DatumElement(
        namespace: json["namespace"],
        frontMatters: FrontMatters.fromJson(json["frontMatters"]),
        count: json["count"],
        data: Map.from(json["data"]).map(
            (k, v) => MapEntry<String, DatumValue>(k, DatumValue.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "namespace": namespace,
        "frontMatters": frontMatters.toJson(),
        "count": count,
        "data": Map.from(data)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class DatumValue {
  DatumValue({
    this.name,
    this.intro,
    this.links,
    this.raw,
  });

  String name;
  String intro;
  String links;
  String raw;

  factory DatumValue.fromRawJson(String str) =>
      DatumValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumValue.fromJson(Map<String, dynamic> json) => DatumValue(
        name: json["name"],
        intro: json["intro"],
        links: json["links"],
        raw: json["raw"] == null ? null : json["raw"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "intro": intro,
        "links": links,
        "raw": raw == null ? null : raw,
      };
}

class FrontMatters {
  FrontMatters({
    this.key,
    this.name,
    this.description,
    this.copyright,
    this.rules,
    this.example,
  });

  String key;
  String name;
  String description;
  String copyright;
  List<String> rules;
  DatumValue example;

  factory FrontMatters.fromRawJson(String str) =>
      FrontMatters.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FrontMatters.fromJson(Map<String, dynamic> json) => FrontMatters(
        key: json["key"],
        name: json["name"],
        description: json["description"],
        copyright: json["copyright"] == null ? null : json["copyright"],
        rules: json["rules"] == null
            ? null
            : List<String>.from(json["rules"].map((x) => x)),
        example: json["example"] == null
            ? null
            : DatumValue.fromJson(json["example"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "description": description,
        "copyright": copyright == null ? null : copyright,
        "rules": rules == null ? null : List<dynamic>.from(rules.map((x) => x)),
        "example": example == null ? null : example.toJson(),
      };
}

class Head {
  Head({
    this.author,
    this.committer,
    this.sha,
    this.message,
  });

  Author author;
  Author committer;
  String sha;
  String message;

  factory Head.fromRawJson(String str) => Head.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        author: Author.fromJson(json["author"]),
        committer: Author.fromJson(json["committer"]),
        sha: json["sha"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "author": author.toJson(),
        "committer": committer.toJson(),
        "sha": sha,
        "message": message,
      };
}

class Author {
  Author({
    this.name,
    this.email,
    this.when,
  });

  String name;
  String email;
  DateTime when;

  factory Author.fromRawJson(String str) => Author.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json["name"],
        email: json["email"],
        when: DateTime.parse(json["when"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "when": when.toIso8601String(),
      };
}
