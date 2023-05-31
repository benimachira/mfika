import 'dart:convert';

const sampleDataJsonString = '''
{
  "children": [
    {
      "id": "1",
      "image":"assets/images/child_image2.jpg",
      "name": "John Doe",
      "grade": "4"
    },
    {
      "id": "2",
      "name": "Jane Doe",
      "image":"assets/images/child_image.jpg",
      "grade": "6"
    }
  ],
 "attendance": [
  {
    "id": "1",
    "childId": "1",
    "childName": "John Doe",
    "grade": "3A",
    "absenceDetails": [
      {
        "date": "2023-01-03",
        "reason": "Sick"
      },
      {
        "date": "2023-04-03",
        "reason": "Fever"
      },
      {
        "date": "2023-04-10",
        "reason": "Fever"
      }
    ]
  },
  {
    "id": "2",
    "childId": "2",
    "childName": "Jane Doe",
    "grade": "1B",
    "absenceDetails": [
      {
        "date": "2023-01-05",
        "reason": "Vacation"
      }
    ]
  }
],
  "termTrips": [
    {
      "id": "1",
      "childId": "1",
      "destination": "Museum",
      "teacher": "Mr. Smith",
      "phoneNumber": "123-456-7890",
      "tripDate": "2023-04-20",
      "departureTime": "08:00",
      "returnTime": "16:00",
      "amount": 20,
      "status": "Paid"
    },
    {
      "id": "2",
      "childId": "2",
      "destination": "Zoo",
      "teacher": "Mrs. Johnson",
      "phoneNumber": "234-567-8901",
      "tripDate": "2023-04-22",
      "departureTime": "09:00",
      "returnTime": "17:00",
      "amount": 25,
      "status": "Unpaid"
    }
  ],
  "notifications": [
    {
      "id": "1",
      "title": "Parent-Teacher Meeting",
      "message": "A parent-teacher meeting is scheduled for next week.",
      "date": "2023-05-01"
    },
    {
      "id": "2",
      "title": "School Trip",
      "message": "The school trip to the local museum is on Friday.",
      "date": "2023-05-05"
    },
    {
      "id": "3",
      "title": "Sports Day",
      "message": "Get ready for our annual sports day next month!",
      "date": "2023-06-10"
    },
    {
      "id": "4",
      "title": "Exam Schedule",
      "message": "The exam schedule for this term has been published.",
      "date": "2023-04-20"
    }
  ],
  "termEvents": [
    {
      "id": "1",
      "eventName": "Science Fair",
      "eventLocation": "School Auditorium",
      "eventDate": "2023-04-30",
      "eventStartTime": "10:00",
      "eventEndTime": "16:00"
    },
    {
      "id": "2",
      "eventName": "Art Exhibition",
      "eventLocation": "School Gym",
      "eventDate": "2023-05-05",
      "eventStartTime":"14:00",
"eventEndTime": "18:00"
}
],
"termDates": [
{
  "id": "1",
  "term": "1",
  "start_date": "2023-01-03",
  "end_date": "2023-04-07",
  "mid_term_start": "2023-02-20",
  "mid_term_end": "2023-02-24",
  "holidays": [
    {
      "holiday_name": "New Year's Day",
      "holiday_date": "2023-01-01"
    },
    {
      "holiday_name": "Good Friday",
      "holiday_date": "2023-04-14"
    }
  ]
},
{
  "id": "2",
  "term": "2",
  "start_date": "2023-04-24",
  "end_date": "2023-07-14",
  "mid_term_start": "2023-06-05",
  "mid_term_end": "2023-06-09",
  "holidays": [
    {
      "holiday_name": "Easter Monday",
      "holiday_date": "2023-04-17"
    },
    {
      "holiday_name": "Labor Day",
      "holiday_date": "2023-05-01"
    }
  ]
},
{
  "id": "3",
  "term": "3",
  "start_date": "2023-08-28",
  "end_date": "2023-12-08",
  "mid_term_start": "2023-10-23",
  "mid_term_end": "2023-10-27",
  "holidays": [
    {
      "holiday_name": "Thanksgiving Day",
      "holiday_date": "2023-11-23"
    },
    {
      "holiday_name": "Christmas Day",
      "holiday_date": "2023-12-25"
    }
  ]
}
]
}
''';

final sampleData = jsonDecode(sampleDataJsonString);