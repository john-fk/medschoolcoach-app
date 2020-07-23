class Commercial {
  String id;
  String name;
  String action;
  String length;
  int seconds;
  String providerType;
  String providerId;
  String link;
  String resolutionLink360;
  String resolutionLink540;
  String resolutionLink720;
  int order;
  String coefficient;

  Commercial({
    this.id,
    this.name,
    this.action,
    this.length,
    this.seconds,
    this.providerType,
    this.providerId,
    this.link,
    this.resolutionLink360,
    this.resolutionLink540,
    this.resolutionLink720,
    this.order,
    this.coefficient,
  });

  factory Commercial.fromJson(Map<String, dynamic> json) => Commercial(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        action: json["action"] == null ? null : json["action"],
        length: json["length"] == null ? null : json["length"],
        seconds: json["seconds"] == null ? null : json["seconds"],
        providerType:
            json["provider_type"] == null ? null : json["provider_type"],
        providerId: json["provider_id"] == null ? null : json["provider_id"],
        link: json["link"] == null ? null : json["link"],
        resolutionLink360: json["resolution_link360"] == null
            ? null
            : json["resolution_link360"],
        resolutionLink540: json["resolution_link540"] == null
            ? null
            : json["resolution_link540"],
        resolutionLink720: json["resolution_link720"] == null
            ? null
            : json["resolution_link720"],
        order: json["order"] == null ? null : json["order"],
        coefficient: json["coefficient"] == null ? null : json["coefficient"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "action": action == null ? null : action,
        "length": length == null ? null : length,
        "seconds": seconds == null ? null : seconds,
        "provider_type": providerType == null ? null : providerType,
        "provider_id": providerId == null ? null : providerId,
        "link": link == null ? null : link,
        "resolution_link360":
            resolutionLink360 == null ? null : resolutionLink360,
        "resolution_link540":
            resolutionLink540 == null ? null : resolutionLink540,
        "resolution_link720":
            resolutionLink720 == null ? null : resolutionLink720,
        "order": order == null ? null : order,
        "coefficient": coefficient == null ? null : coefficient,
      };
}
