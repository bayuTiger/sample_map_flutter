import 'package:latlong2/latlong.dart';

class CoolSpot {
  final String name;
  final String description;
  final LatLng location;
  final String imageUrl;
  final double rating;

  CoolSpot({
    required this.name,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.rating,
  });
}

// サンプルデータ
final List<CoolSpot> coolSpots = [
  CoolSpot(
    name: '緑豊かな公園',
    description: '木陰が多く、涼しい風が吹く広大な公園です。',
    location: LatLng(35.6812, 139.7671),
    imageUrl: 'assets/images/park.jpg',
    rating: 4.5,
  ),
  CoolSpot(
    name: '市立図書館',
    description: '静かで涼しい環境で読書を楽しめます。',
    location: LatLng(35.6897, 139.7054),
    imageUrl: 'assets/images/library.jpg',
    rating: 4.2,
  ),
  CoolSpot(
    name: 'アイスクリームパーラー',
    description: '美味しいアイスクリームで暑さを忘れられます。',
    location: LatLng(35.6645, 139.7121),
    imageUrl: 'assets/images/ice_cream.jpg',
    rating: 4.8,
  ),
];
