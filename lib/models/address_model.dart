class Address {
  final String id;
  final String name;
  final String mobile;
  final String pincode;
  final String houseNumber;
  final String address;
  final String locality;
  final String city;
  final String state;
  final AddressType type;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.mobile,
    required this.pincode,
    required this.houseNumber,
    required this.address,
    required this.locality,
    required this.city,
    required this.state,
    this.type = AddressType.home,
    this.isDefault = false,
  });

  String get fullAddress {
    return '$houseNumber, $address, $locality, $city, $state - $pincode';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'pincode': pincode,
      'houseNumber': houseNumber,
      'address': address,
      'locality': locality,
      'city': city,
      'state': state,
      'type': type.name,
      'isDefault': isDefault,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      pincode: json['pincode'] ?? '',
      houseNumber: json['houseNumber'] ?? '',
      address: json['address'] ?? '',
      locality: json['locality'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      type: AddressType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AddressType.home,
      ),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Address copyWith({
    String? id,
    String? name,
    String? mobile,
    String? pincode,
    String? houseNumber,
    String? address,
    String? locality,
    String? city,
    String? state,
    AddressType? type,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      pincode: pincode ?? this.pincode,
      houseNumber: houseNumber ?? this.houseNumber,
      address: address ?? this.address,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      state: state ?? this.state,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

enum AddressType {
  home,
  office,
}

extension AddressTypeExtension on AddressType {
  String get displayName {
    switch (this) {
      case AddressType.home:
        return 'Home';
      case AddressType.office:
        return 'Office';
    }
  }
}