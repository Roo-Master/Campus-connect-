class BuildingModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final List<String> facilities;
  final String openingTime;
  final String closingTime;
  final bool isAccessible;
  final int floors;
  final List<RoomModel> rooms;
  final BuildingCategory category;

  BuildingModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.facilities,
    required this.openingTime,
    required this.closingTime,
    required this.isAccessible,
    required this.floors,
    required this.rooms,
    required this.category,
  });

  static List<BuildingModel> getMockBuildings() {
    return [
      BuildingModel(
        id: 'b001',
        name: 'School of Law',
        code: 'SOL',
        description: 'Law School Lecture Halls Location',
        imageUrl: '',
        latitude: -0.6908169223533418,
        longitude: 34.78589423810216,
        facilities: ['Classrooms', 'Labs', 'Faculty Offices', 'Washrooms'],
        openingTime: '7:00 AM',
        closingTime: '9:00 PM',
        isAccessible: true,
        floors: 4,
        category: BuildingCategory.academic,
        rooms: [
          RoomModel(
              id: 'LH27',
              number: '27',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 60),
          RoomModel(
              id: 'LH20',
              number: '20',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 30),
          RoomModel(
              id: 'LH26',
              number: '26',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 100),
          RoomModel(
              id: 'LH25',
              number: '25',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 15),
        ],
      ),
      BuildingModel(
        id: 'b002',
        name: 'Tuition Complex',
        code: 'TC',
        description: 'The TC building Block Lecture Halls',
        imageUrl: '',
        latitude: -0.693835608542582,
        longitude: 34.78438381326505,
        facilities: [
          'Practical Labs',
          'Lecture Halls',
          'Student Meeting Areas'
        ],
        openingTime: '7:00 AM',
        closingTime: '10:00 PM',
        isAccessible: true,
        floors: 4,
        category: BuildingCategory.academic,
        rooms: [
          RoomModel(
              id: 'TCG1',
              number: 'TCG1',
              floor: 0,
              type: 'Chemistry Lab',
              capacity: 50),
          RoomModel(
              id: 'TCG2',
              number: 'TCG2',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 40),
          RoomModel(
              id: 'TCG3',
              number: 'TCG3',
              floor: 0,
              type: 'Chemistry Lab',
              capacity: 80),
          RoomModel(
              id: 'TCG4',
              number: 'TCG4',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 50),
          RoomModel(
              id: 'TCG5',
              number: 'TCG5',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 40),
          RoomModel(
              id: 'TC11',
              number: 'TC11',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'TC12',
              number: 'TC12',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 50),
          RoomModel(
              id: 'TC13',
              number: 'TC13',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 40),
          RoomModel(
              id: 'TC14',
              number: 'TC14',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'TC15',
              number: 'TC15',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 50),
          RoomModel(
              id: 'TC21',
              number: 'TC21',
              floor: 2,
              type: 'Lecture Hall',
              capacity: 40),
          RoomModel(
              id: 'TC22',
              number: 'TC22',
              floor: 2,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'TC23',
              number: 'TC23',
              floor: 2,
              type: 'Lecture Hall',
              capacity: 50),
          RoomModel(
              id: 'TC24',
              number: 'TC24',
              floor: 2,
              type: 'Lecture Hall',
              capacity: 40),
          RoomModel(
              id: 'TC25',
              number: 'TC25',
              floor: 2,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'TC31',
              number: 'TC31',
              floor: 3,
              type: 'Lecture Hall',
              capacity: 50),
          RoomModel(
              id: 'TC32',
              number: 'TC32',
              floor: 3,
              type: 'Lecture Hall',
              capacity: 40),
          RoomModel(
              id: 'TC33',
              number: 'TC33',
              floor: 3,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'TC34',
              number: 'TC34',
              floor: 3,
              type: 'Lecture Hall',
              capacity: 50),
          RoomModel(
              id: 'TC35',
              number: 'TC35',
              floor: 3,
              type: 'Lecture Hall',
              capacity: 40),
          RoomModel(
              id: 'TC41',
              number: 'TC41',
              floor: 4,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'TC42',
              number: 'TC42',
              floor: 4,
              type: 'Lecture Hall',
              capacity: 50),
          RoomModel(
              id: 'TC43',
              number: 'TC43',
              floor: 4,
              type: 'Lecture Hall',
              capacity: 40),
          RoomModel(
              id: 'TC44',
              number: 'TC44',
              floor: 4,
              type: 'Lecture Hall',
              capacity: 80),
        ],
      ),
      BuildingModel(
        id: 'b003',
        name: 'Main Library',
        code: 'Library',
        description:
            'Main university library with digital and physical resources',
        imageUrl: '',
        latitude: -0.6910255431911482,
        longitude: 34.78559340741842,
        facilities: [
          'Reading Rooms',
          'Digital Library',
          'Discussion Rooms',
          'Cafe'
        ],
        openingTime: '8:00 AM',
        closingTime: '11:00 PM',
        isAccessible: true,
        floors: 3,
        category: BuildingCategory.academic,
        rooms: [],
      ),
      BuildingModel(
        id: 'b004',
        name: 'Chancellors Pavilion',
        code: 'PV',
        description: 'Chancellors Kisii University stadium view point',
        imageUrl: '',
        latitude: -0.6931191626919239,
        longitude: 34.781756306682,
        facilities: ['Lectures', 'Event Hosting', 'Sports Viewing'],
        openingTime: '6:00 AM',
        closingTime: '10:00 PM',
        isAccessible: true,
        floors: 3,
        category: BuildingCategory.sports,
        rooms: [
          RoomModel(
              id: 'PVG',
              number: 'PVG',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 100),
          RoomModel(
              id: 'PV1',
              number: 'PV1',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 100),
          RoomModel(
              id: 'PV2',
              number: 'PV2',
              floor: 2,
              type: 'Lecture Hall',
              capacity: 100),
        ],
      ),
      BuildingModel(
        id: 'b005',
        name: 'ICT Block A',
        code: 'Block A',
        description:
            'ICT block for School of Information Science and Technology (SIST)',
        imageUrl: '',
        latitude: -0.6911967259847902,
        longitude: 34.78667860557033,
        facilities: [
          'Lecture Halls',
          'COD Office (SIST)',
          'Lecture Lounge',
          'Student Meetings'
        ],
        openingTime: '8:00 AM',
        closingTime: '10:00 PM',
        isAccessible: true,
        floors: 3,
        category: BuildingCategory.academic,
        rooms: [
          RoomModel(
              id: 'ICT22',
              number: '22',
              floor: 2,
              type: 'Computer Lab',
              capacity: 60),
          RoomModel(
              id: 'ICTA_G',
              number: 'G',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 100),
          RoomModel(
              id: 'ICTA_1',
              number: '1',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 100),
          RoomModel(
              id: 'ICTA_2',
              number: '2',
              floor: 2,
              type: 'Lecture Hall',
              capacity: 100),
        ],
      ),
      BuildingModel(
        id: 'b006',
        name: 'Sakagwa Block',
        code: 'SAK',
        description: 'Sakagwa academic block with lecture halls',
        imageUrl: '',
        latitude: -0.6935888634046808,
        longitude: 34.78482369551909,
        facilities: ['Lecture Halls', 'Faculty Offices', 'Washrooms'],
        openingTime: '7:00 AM',
        closingTime: '9:00 PM',
        isAccessible: true,
        floors: 3,
        category: BuildingCategory.academic,
        rooms: [
          RoomModel(
              id: 'SAK_G1',
              number: 'G1',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'SAK_G2',
              number: 'G2',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'SAK_11',
              number: '11',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 60),
          RoomModel(
              id: 'SAK_12',
              number: '12',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 60),
        ],
      ),
      BuildingModel(
        id: 'b007',
        name: 'Science Complex',
        code: 'SCI',
        description:
            'Science faculty complex with laboratories and lecture halls',
        imageUrl: '',
        latitude: -0.6934514822039993,
        longitude: 34.784233541798905,
        facilities: [
          'Science Labs',
          'Lecture Halls',
          'Research Rooms',
          'Faculty Offices'
        ],
        openingTime: '7:00 AM',
        closingTime: '9:00 PM',
        isAccessible: true,
        floors: 4,
        category: BuildingCategory.academic,
        rooms: [
          RoomModel(
              id: 'SCI_G1', number: 'G1', floor: 0, type: 'Lab', capacity: 50),
          RoomModel(
              id: 'SCI_G2',
              number: 'G2',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'SCI_11', number: '11', floor: 1, type: 'Lab', capacity: 50),
          RoomModel(
              id: 'SCI_12',
              number: '12',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 80),
        ],
      ),
      BuildingModel(
        id: 'b008',
        name: 'Admin Block',
        code: 'ADMIN',
        description: 'University administration offices and registry',
        imageUrl: '',
        latitude: -0.6772589027123002,
        longitude: 34.78015016693769,
        facilities: [
          'Registry',
          'Finance Office',
          'VC Office',
          'Student Affairs'
        ],
        openingTime: '8:00 AM',
        closingTime: '5:00 PM',
        isAccessible: true,
        floors: 3,
        category: BuildingCategory.admin,
        rooms: [
          RoomModel(
              id: 'ADM_REG',
              number: 'Registry',
              floor: 0,
              type: 'Office',
              capacity: 20),
          RoomModel(
              id: 'ADM_FIN',
              number: 'Finance',
              floor: 1,
              type: 'Office',
              capacity: 20),
          RoomModel(
              id: 'ADM_VC',
              number: 'VC Office',
              floor: 2,
              type: 'Office',
              capacity: 10),
        ],
      ),
      BuildingModel(
        id: 'b009',
        name: 'Twin Towers Complex',
        code: 'TTC',
        description: 'Twin towers multi-purpose academic complex',
        imageUrl: '',
        latitude: -0.6733631531426383,
        longitude: 34.7701561227603,
        facilities: ['Lecture Halls', 'Seminar Rooms', 'Faculty Offices'],
        openingTime: '7:00 AM',
        closingTime: '9:00 PM',
        isAccessible: true,
        floors: 5,
        category: BuildingCategory.academic,
        rooms: [
          RoomModel(
              id: 'TTC_G1',
              number: 'G1',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 100),
          RoomModel(
              id: 'TTC_G2',
              number: 'G2',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 100),
          RoomModel(
              id: 'TTC_11',
              number: '11',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'TTC_12',
              number: '12',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 80),
        ],
      ),
      BuildingModel(
        id: 'b010',
        name: 'Medical Annex',
        code: 'MED',
        description: 'Medical school annex with clinical facilities',
        imageUrl: '',
        latitude: -0.6908982056007581,
        longitude: 34.78267786065657,
        facilities: ['Clinical Labs', 'Lecture Halls', 'Simulation Rooms'],
        openingTime: '7:00 AM',
        closingTime: '9:00 PM',
        isAccessible: true,
        floors: 3,
        category: BuildingCategory.health,
        rooms: [
          RoomModel(
              id: 'MED_G1',
              number: 'G1',
              floor: 0,
              type: 'Clinical Lab',
              capacity: 40),
          RoomModel(
              id: 'MED_11',
              number: '11',
              floor: 1,
              type: 'Lecture Hall',
              capacity: 60),
          RoomModel(
              id: 'MED_12',
              number: '12',
              floor: 1,
              type: 'Simulation Room',
              capacity: 30),
        ],
      ),
      BuildingModel(
        id: 'b011',
        name: 'Dr. Sagini Block',
        code: 'DSB',
        description: 'Dr. Sagini academic block',
        imageUrl: '',
        latitude: -0.6947083664056224,
        longitude: 34.78252181111525,
        facilities: ['Lecture Halls', 'Faculty Offices', 'Seminar Rooms'],
        openingTime: '7:00 AM',
        closingTime: '9:00 PM',
        isAccessible: true,
        floors: 3,
        category: BuildingCategory.academic,
        rooms: [
          RoomModel(
              id: 'DSB_G1',
              number: 'G1',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'DSB_G2',
              number: 'G2',
              floor: 0,
              type: 'Lecture Hall',
              capacity: 80),
          RoomModel(
              id: 'DSB_11',
              number: '11',
              floor: 1,
              type: 'Seminar Room',
              capacity: 40),
        ],
      ),
      BuildingModel(
        id: 'b012',
        name: 'Amphitheatre',
        code: 'AMPH',
        description: 'Open air amphitheatre for events and lectures',
        imageUrl: '',
        latitude: -0.6912,
        longitude: 34.7853,
        facilities: ['Open Air Seating', 'Stage', 'Event Space'],
        openingTime: '6:00 AM',
        closingTime: '10:00 PM',
        isAccessible: true,
        floors: 1,
        category: BuildingCategory.sports,
        rooms: [
          RoomModel(
              id: 'AMPH_MAIN',
              number: 'Main',
              floor: 0,
              type: 'Amphitheatre',
              capacity: 500),
        ],
      ),
      BuildingModel(
        id: 'b013',
        name: 'Old Moot Court',
        code: 'OMC',
        description: 'Old moot court for law school proceedings and practice',
        imageUrl: '',
        latitude: -0.6936,
        longitude: 34.7845,
        facilities: ['Moot Court', 'Law Library', 'Meeting Rooms'],
        openingTime: '8:00 AM',
        closingTime: '6:00 PM',
        isAccessible: true,
        floors: 2,
        category: BuildingCategory.academic,
        rooms: [
          RoomModel(
              id: 'OMC_COURT',
              number: 'Court',
              floor: 0,
              type: 'Moot Court',
              capacity: 60),
          RoomModel(
              id: 'OMC_LIB',
              number: 'Library',
              floor: 1,
              type: 'Law Library',
              capacity: 40),
        ],
      ),
    ];
  }
}

enum BuildingCategory {
  academic,
  admin,
  health,
  food,
  sports,
  hostel,
  other;

  String get label {
    switch (this) {
      case BuildingCategory.academic:
        return 'Academic';
      case BuildingCategory.admin:
        return 'Admin';
      case BuildingCategory.health:
        return 'Health';
      case BuildingCategory.food:
        return 'Food';
      case BuildingCategory.sports:
        return 'Sports';
      case BuildingCategory.hostel:
        return 'Hostel';
      case BuildingCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case BuildingCategory.academic:
        return '🎓';
      case BuildingCategory.admin:
        return '🏦';
      case BuildingCategory.health:
        return '🏥';
      case BuildingCategory.food:
        return '🍽️';
      case BuildingCategory.sports:
        return '⚽';
      case BuildingCategory.hostel:
        return '🏠';
      case BuildingCategory.other:
        return '📍';
    }
  }
}

class RoomModel {
  final String id;
  final String number;
  final int floor;
  final String type;
  final int capacity;

  RoomModel({
    required this.id,
    required this.number,
    required this.floor,
    required this.type,
    required this.capacity,
  });

}
