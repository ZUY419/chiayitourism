class AppConstants {
  // Map
  static const double chiaYiLat = 23.4801;
  static const double chiaYiLng = 120.4491;
  static const double defaultZoom = 14.0;

  // Spot types
  static const String typeRestaurant = 'restaurant';
  static const String typeCafe = 'cafe';
  static const String typeHotel = 'hotel';
  static const String typeAttraction = 'attraction';
  static const String typeBusStop = 'bus_stop';
  static const String typeTrainStation = 'train_station';
  static const String typeUbike = 'ubike';

  // Stamp rules
  static const int cafePointsPerRedemption = 20;
  static const int cafeRewardAmount = 100;
  static const int hotelPointsPerRedemption = 10;
  static const int hotelRewardAmount = 500;
  static const int restaurantPointsPerRedemption = 20;
  static const int restaurantRewardAmount = 100;

  // Coupon states
  static const String couponAvailable = 'available';
  static const String couponUsed = 'used';
  static const String couponExpired = 'expired';

  // Coupon types
  static const String couponTypeStamp = 'stamp';
  static const String couponTypeBirthday = 'birthday';
  static const String couponTypeActivity = 'activity';

  // Activity states
  static const String activityUpcoming = 'upcoming';
  static const String activityOngoing = 'ongoing';
  static const String activityEnded = 'ended';

  // Direction
  static const String directionNorthbound = 'northbound';
  static const String directionSouthbound = 'southbound';

  // Announcement sources
  static const String announcementChiayiCity = 'chiayi_city';
  static const String announcementChiayiCounty = 'chiayi_county';
  static const String announcementSystem = 'system';

  // Firestore collections
  static const String colUsers = 'users';
  static const String colSpots = 'spots';
  static const String colComments = 'comments';
  static const String colActivities = 'activities';
  static const String colTrainStations = 'train_stations';
  static const String colBusStops = 'bus_stops';
  static const String colUbikeStations = 'ubike_stations';
  static const String colCoupons = 'coupons';
  static const String colStampRecords = 'stamp_records';
  static const String colAnnouncements = 'announcements';

  // TDX API
  static const String tdxBaseUrl = 'https://tdx.transportdata.tw/api/basic';
}