//main imports
import 'package:flutter/material.dart';
//pubsecyaml imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
//doc imports
import 'package:mekancimapp/helpers/requestAssistants.dart';
import 'package:mekancimapp/models/address_model.dart';
import 'package:mekancimapp/models/placePredictions.dart';
import 'package:mekancimapp/providers/address_data_provider.dart';
import 'package:mekancimapp/helpers/location.helper.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController placeTextEditingController =
      new TextEditingController();
  List<PlacePredictions> placePredictonList = [];
  String selectedPlaceId;
  var _newAddress = Address(
    formattedAddress: '',
    latitude: 0,
    longitude: 0,
    placeId: '',
    placeName: '',
  );
  void findPlace(String placeName) async {
    LatLng currentLocation = await LocationHelper.getCurrentLocation();

    double lat = currentLocation.latitude;

    double lng = currentLocation.longitude;

    if (placeName.length > 1) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&location=$lat%2C$lng&radius=50 &key=$GOOGLE_API_KEY';

      var res = await LocationHelper.getRequest(autoCompleteUrl);

      if (res == 'failed') {
        return;
      }
      if (res['status'] == 'OK') {
        var predictions = res['predictions'];

        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictonList = placesList;
        });
      } else {}

      print('Places Prediction Response');
      print(res);
      print(autoCompleteUrl);
    }
  }

  void getPlaceAddressDetails(String placeId) async {
    Provider.of<AddressProvider>(context, listen: false).deleteAddress();
    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeId&key=$GOOGLE_API_KEY';

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    if (res == 'failed') {
      return;
    }
    if (res['status'] == 'OK') {
      double lat = res['result']['geometry']['location']['lat'];
      double lng = res['result']['geometry']['location']['lng'];

      // Address address = new Address();
      _newAddress.placeName = res['result']['name'];
      _newAddress.placeId = placeId;
      _newAddress.latitude = res['result']['geometry']['location']['lat'];
      _newAddress.longitude = res['result']['geometry']['location']['lng'];
      // final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      //   latitude: address.latitude,
      //   longitude: address.longitude,
      // );
      LatLng selectedPlace = LatLng(lat, lng);
      setState(() {
        selectedPlaceId = placeId;
      });
      // print('map url $staticMapImageUrl');
      // print('address lat ${address.latitude}');
      // print('address lng ${address.longitude}');
      print('double lat $lat');
      print('double lng $lng');
      print(placeId);
      print(placeDetailsUrl);
      setState(() {
        _newAddress.placeName = res['result']['name'];
        _newAddress.placeId = placeId;
        _newAddress.latitude = res['result']['geometry']['location']['lat'];
        _newAddress.longitude = res['result']['geometry']['location']['lng'];
        _newAddress.formattedAddress = res['result']['formatted_address'];
      });
      print('provider çalışıyor ${_newAddress.placeName}');
      Provider.of<AddressProvider>(context, listen: false)
          .addAddress(_newAddress);
      Navigator.of(context).pop(selectedPlaceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            padding: EdgeInsets.only(left: 10),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          title: Text(
            'Mekan Seç',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(
                            width: 7,
                          ),
                          Container(
                            child: Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: TextField(
                                  onChanged: (val) {
                                    findPlace(val);
                                  },
                                  controller: placeTextEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Mekan Ara!',
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 11, top: 8, bottom: 8),
                                  ),
                                ),
                              ),
                            )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              (placePredictonList.length > 0)
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: placePredictonList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        itemBuilder: (ctx, i) {
                          return predictionTile(
                            placePredictonList[i],
                          );
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }

  Widget predictionTile(PlacePredictions placePredictions) {
    return InkWell(
      onTap: () {
        getPlaceAddressDetails(placePredictions.placeId);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placePredictions.mainText,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16)),
                      SizedBox(
                        height: 3,
                      ),
                      placePredictions.secondText == null
                          ? Container()
                          : Text(placePredictions.secondText,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
