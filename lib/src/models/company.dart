class Company {
  final String id;
  final String registryId;
  final String name;
  final String address1;
  final String address2;
  final String state;
  final String city;
  final String postcode;
  final String country;

  Company(this.id, this.registryId, this.address1, this.address2, this.state,
      this.city, this.country, this.postcode, this.name);

  Company.fromJson(Map<String, dynamic> json)
      : name = json['Name'] ?? null,
        id = json['Id'] ?? null,
        registryId = json['RegistryId'] ?? null,
        address1 = json['Address1'] ?? null,
        address2 = json['Address2'] ?? null,
        state = json['State'] ?? null,
        city = json['City'] ?? null,
        postcode = json['Postcode'] ?? null,
        country = json['Country'] ?? null;

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Id': id,
        'RegistryId': registryId,
        'Address1': address1,
        'Address2': address2,
        'State': state,
        'City': city,
        'Postcode': postcode,
        'Country': country
      };
}
