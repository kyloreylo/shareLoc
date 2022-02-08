import 'package:flutter/material.dart';
import 'package:mekancimapp/models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _address = [];

  List<Address> get address {
    return [..._address];
  }

  void deleteAddress() {
    _address.clear();
    notifyListeners();
  }

  void addAddress(Address address) {
    final newPost = Address(
      placeName: address.placeName,
      formattedAddress: address.formattedAddress,
      latitude: address.latitude,
      longitude: address.longitude,
      placeId: address.placeId,
    );
    _address.add(newPost);
    notifyListeners();
  }
}
