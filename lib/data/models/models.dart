import 'package:cloud_firestore/cloud_firestore.dart';

// ─────────────────────────────────────────
// User Model
// ─────────────────────────────────────────
class UserModel {
  final String uid;
  final String name;
  final String? phone;
  final String? email;
  final String gender;
  final Timestamp birthday;
  final String? photoUrl;
  final Map<String, int> points; // {cafe: n, hotel: n, restaurant: n}
  final List<String> favorites; // spotId list
  final String? store; // spotId of owned store
  final List<String> notified; // activityId list

  const UserModel({
    required this.uid,
    required this.name,
    this.phone,
    this.email,
    required this.gender,
    required this.birthday,
    this.photoUrl,
    required this.points,
    required this.favorites,
    this.store,
    required this.notified,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] ?? '',
    name: map['name'] ?? '',
    phone: map['phone'],
    email: map['email'],
    gender: map['gender'] ?? '',
    birthday: map['birthday'] ?? Timestamp.now(),
    photoUrl: map['photoUrl'],
    points: Map<String, int>.from(map['points'] ?? {}),
    favorites: List<String>.from(map['favorites'] ?? []),
    store: map['store'],
    notified: List<String>.from(map['notified'] ?? []),
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'phone': phone,
    'email': email,
    'gender': gender,
    'birthday': birthday,
    'photoUrl': photoUrl,
    'points': points,
    'favorites': favorites,
    'store': store,
    'notified': notified,
  };
}

// ─────────────────────────────────────────
// Spot / Store Model
// ─────────────────────────────────────────
class SpotModel {
  final String spotId;
  final String type; // restaurant | cafe | hotel | attraction
  final String name;
  final String address;
  final String? phone;
  final GeoPoint location;
  final String description;
  final double rating;
  final List<String> tags;
  final List<String> images;
  final List<Map<String, dynamic>>? menu; // nullable for non-food
  final String? bookingUrl; // nullable for non-hotel
  final bool isPartner;
  final String? owner; // uid
  final int commentCount;

  const SpotModel({
    required this.spotId,
    required this.type,
    required this.name,
    required this.address,
    this.phone,
    required this.location,
    required this.description,
    required this.rating,
    required this.tags,
    required this.images,
    this.menu,
    this.bookingUrl,
    required this.isPartner,
    this.owner,
    required this.commentCount,
  });

  factory SpotModel.fromMap(String id, Map<String, dynamic> map) => SpotModel(
    spotId: id,
    type: map['type'] ?? '',
    name: map['name'] ?? '',
    address: map['address'] ?? '',
    phone: map['phone'],
    location: map['location'] ?? const GeoPoint(0, 0),
    description: map['description'] ?? '',
    rating: (map['rating'] ?? 0.0).toDouble(),
    tags: List<String>.from(map['tags'] ?? []),
    images: List<String>.from(map['images'] ?? []),
    menu: map['menu'] != null
        ? List<Map<String, dynamic>>.from(map['menu'])
        : null,
    bookingUrl: map['bookingUrl'],
    isPartner: map['isPartner'] ?? false,
    owner: map['owner'],
    commentCount: map['commentCount'] ?? 0,
  );
}

// ─────────────────────────────────────────
// Comment Model
// ─────────────────────────────────────────
class CommentModel {
  final String commentId;
  final String userUid;
  final String userName;
  final String? userPhotoUrl;
  final String content;
  final double rating;
  final Timestamp timestamp;
  final List<String> likes;
  final List<ReplyModel> replies;

  const CommentModel({
    required this.commentId,
    required this.userUid,
    required this.userName,
    this.userPhotoUrl,
    required this.content,
    required this.rating,
    required this.timestamp,
    required this.likes,
    required this.replies,
  });

  factory CommentModel.fromMap(String id, Map<String, dynamic> map) =>
      CommentModel(
        commentId: id,
        userUid: map['userUid'] ?? '',
        userName: map['userName'] ?? '',
        userPhotoUrl: map['userPhotoUrl'],
        content: map['content'] ?? '',
        rating: (map['rating'] ?? 0.0).toDouble(),
        timestamp: map['timestamp'] ?? Timestamp.now(),
        likes: List<String>.from(map['likes'] ?? []),
        replies: (map['replies'] as List<dynamic>? ?? [])
            .map((r) => ReplyModel.fromMap(r as Map<String, dynamic>))
            .toList(),
      );
}

class ReplyModel {
  final String userUid;
  final String userName;
  final String? userPhotoUrl;
  final String content;
  final Timestamp timestamp;

  const ReplyModel({
    required this.userUid,
    required this.userName,
    this.userPhotoUrl,
    required this.content,
    required this.timestamp,
  });

  factory ReplyModel.fromMap(Map<String, dynamic> map) => ReplyModel(
    userUid: map['userUid'] ?? '',
    userName: map['userName'] ?? '',
    userPhotoUrl: map['userPhotoUrl'],
    content: map['content'] ?? '',
    timestamp: map['timestamp'] ?? Timestamp.now(),
  );
}

// ─────────────────────────────────────────
// Activity Model
// ─────────────────────────────────────────
class ActivityModel {
  final String activityId;
  final String title;
  final String content;
  final Timestamp startTime;
  final Timestamp endTime;
  final String? image;
  final bool isSyncToCalendar;
  final List<String> tags;
  final String organizer;
  final String spotId;
  final String state; // upcoming | ongoing | ended

  const ActivityModel({
    required this.activityId,
    required this.title,
    required this.content,
    required this.startTime,
    required this.endTime,
    this.image,
    required this.isSyncToCalendar,
    required this.tags,
    required this.organizer,
    required this.spotId,
    required this.state,
  });

  factory ActivityModel.fromMap(String id, Map<String, dynamic> map) =>
      ActivityModel(
        activityId: id,
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        startTime: map['startTime'] ?? Timestamp.now(),
        endTime: map['endTime'] ?? Timestamp.now(),
        image: map['image'],
        isSyncToCalendar: map['isSyncToCalendar'] ?? false,
        tags: List<String>.from(map['tags'] ?? []),
        organizer: map['organizer'] ?? '',
        spotId: map['spotId'] ?? '',
        state: map['state'] ?? 'upcoming',
      );
}

// ─────────────────────────────────────────
// Train Station Model
// ─────────────────────────────────────────
class TrainStationModel {
  final String stationId;
  final String name;
  final String address;
  final GeoPoint location;
  final String? phone;
  // Dynamic fields (from TDX)
  final List<TrainScheduleModel> schedules;

  const TrainStationModel({
    required this.stationId,
    required this.name,
    required this.address,
    required this.location,
    this.phone,
    this.schedules = const [],
  });

  factory TrainStationModel.fromMap(String id, Map<String, dynamic> map) =>
      TrainStationModel(
        stationId: id,
        name: map['name'] ?? '',
        address: map['address'] ?? '',
        location: map['location'] ?? const GeoPoint(0, 0),
        phone: map['phone'],
      );
}

class TrainScheduleModel {
  final String trainType;
  final String trainNo;
  final DateTime arrivalTime;
  final String destination;
  final String direction;

  const TrainScheduleModel({
    required this.trainType,
    required this.trainNo,
    required this.arrivalTime,
    required this.destination,
    required this.direction,
  });
}

// ─────────────────────────────────────────
// Bus Stop Model
// ─────────────────────────────────────────
class BusStopModel {
  final String stopId;
  final String name;
  final GeoPoint location;
  // Dynamic fields (from TDX)
  final List<BusArrivalModel> arrivals;

  const BusStopModel({
    required this.stopId,
    required this.name,
    required this.location,
    this.arrivals = const [],
  });

  factory BusStopModel.fromMap(String id, Map<String, dynamic> map) =>
      BusStopModel(
        stopId: id,
        name: map['name'] ?? '',
        location: map['location'] ?? const GeoPoint(0, 0),
      );
}

class BusArrivalModel {
  final String busNumber;
  final int estimatedArrivalMinutes;
  final String direction;

  const BusArrivalModel({
    required this.busNumber,
    required this.estimatedArrivalMinutes,
    required this.direction,
  });
}

// ─────────────────────────────────────────
// Ubike Station Model
// ─────────────────────────────────────────
class UbikeStationModel {
  final String stationId;
  final String name;
  final GeoPoint location;
  final String address;
  // Dynamic fields
  final int availableBikes;
  final int availableEbikes;
  final int emptySlots;

  const UbikeStationModel({
    required this.stationId,
    required this.name,
    required this.location,
    required this.address,
    this.availableBikes = 0,
    this.availableEbikes = 0,
    this.emptySlots = 0,
  });

  factory UbikeStationModel.fromMap(String id, Map<String, dynamic> map) =>
      UbikeStationModel(
        stationId: id,
        name: map['name'] ?? '',
        location: map['location'] ?? const GeoPoint(0, 0),
        address: map['address'] ?? '',
        availableBikes: map['availableBikes'] ?? 0,
        availableEbikes: map['availableEbikes'] ?? 0,
        emptySlots: map['emptySlots'] ?? 0,
      );
}

// ─────────────────────────────────────────
// Coupon Model
// ─────────────────────────────────────────
class CouponModel {
  final String couponId;
  final String ownerUid;
  final String type; // stamp | birthday | activity
  final String content;
  final String state; // available | used | expired
  final Timestamp startTime;
  final Timestamp endTime;

  const CouponModel({
    required this.couponId,
    required this.ownerUid,
    required this.type,
    required this.content,
    required this.state,
    required this.startTime,
    required this.endTime,
  });

  factory CouponModel.fromMap(String id, Map<String, dynamic> map) =>
      CouponModel(
        couponId: id,
        ownerUid: map['ownerUid'] ?? '',
        type: map['type'] ?? '',
        content: map['content'] ?? '',
        state: map['state'] ?? 'available',
        startTime: map['startTime'] ?? Timestamp.now(),
        endTime: map['endTime'] ?? Timestamp.now(),
      );
}

// ─────────────────────────────────────────
// Stamp Record Model
// ─────────────────────────────────────────
class StampRecordModel {
  final String recordId;
  final String userUid;
  final String spotId;
  final int pointsEarned;
  final String category;
  final String merchantCode;
  final Timestamp timestamp;

  const StampRecordModel({
    required this.recordId,
    required this.userUid,
    required this.spotId,
    required this.pointsEarned,
    required this.category,
    required this.merchantCode,
    required this.timestamp,
  });
}

// ─────────────────────────────────────────
// Announcement Model
// ─────────────────────────────────────────
class AnnouncementModel {
  final String id;
  final String source; // chiayi_city | chiayi_county | system
  final String title;
  final Timestamp date;
  final String content;
  final String? images;

  const AnnouncementModel({
    required this.id,
    required this.source,
    required this.title,
    required this.date,
    required this.content,
    this.images,
  });

  factory AnnouncementModel.fromMap(String id, Map<String, dynamic> map) =>
      AnnouncementModel(
        id: id,
        source: map['source'] ?? '',
        title: map['title'] ?? '',
        date: map['date'] ?? Timestamp.now(),
        content: map['content'] ?? '',
        images: map['images'],
      );
}