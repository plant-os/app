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
      : name = json['Name'],
        id = json['Id'],
        registryId = json['RegistryId'],
        address1 = json['Address1'],
        address2 = json['Address2'],
        state = json['State'],
        city = json['City'],
        postcode = json['Postcode'],
        country = json['Country'];

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
