mixin LoggerMixin {
  void logAction(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    print('   [LOG $timestamp]: $message');
  }
}

abstract class Schedulable {
  String getDetails();
}

class Appointment extends Schedulable with LoggerMixin {
  final String appointmentId;
  final String patientName;
  final String date;
  final String timeSlot;

  Appointment({
    required this.appointmentId,
    required this.patientName,
    required this.date,
    required this.timeSlot,
  });

  @override
  String getDetails() {
    return 'ID: $appointmentId | Patient: $patientName | Date: $date | Time: $timeSlot';
  }
}

class GeneralCheckup extends Appointment {
  final String clinicRoom;

  GeneralCheckup({
    required String appointmentId,
    required String patientName,
    required String date,
    required String timeSlot,
    required this.clinicRoom,
  }) : super(
          appointmentId: appointmentId,
          patientName: patientName,
          date: date,
          timeSlot: timeSlot,
        );

  @override
  String getDetails() {
    return '${super.getDetails()} | Type: General Checkup | Room: $clinicRoom';
  }
}

class SpecialistConsultation extends Appointment {
  final String specialistName;
  final String medicalSpecialty;

  SpecialistConsultation({
    required String appointmentId,
    required String patientName,
    required String date,
    required String timeSlot,
    required this.specialistName,
    required this.medicalSpecialty,
  }) : super(
          appointmentId: appointmentId,
          patientName: patientName,
          date: date,
          timeSlot: timeSlot,
        );

  @override
  String getDetails() {
    return '${super.getDetails()} | Type: $medicalSpecialty | Doctor: Dr. $specialistName';
  }
}

class ClinicAppointmentTracker with LoggerMixin {
  final List<Appointment> _appointments = [];

  Future<void> fetchAppointmentsFromDatabase() async {
    print('\n🔄 Connecting to Clinic Database... Please wait.');
    logAction('Fetching records from cloud database...');
    
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    _appointments.addAll([
      GeneralCheckup(
        appointmentId: 'APT-101',
        patientName: 'Juan Dela Cruz',
        date: '2026-11-02',
        timeSlot: '09:00 AM',
        clinicRoom: 'Room 102',
      ),
      SpecialistConsultation(
        appointmentId: 'APT-102',
        patientName: 'Maria Clara',
        date: '2026-11-02',
        timeSlot: '11:30 AM',
        specialistName: 'Santos',
        medicalSpecialty: 'Cardiology',
      ),
    ]);

    logAction('Successfully retrieved ${_appointments.length} appointment records.');
  }

  Future<void> bookAppointment(Appointment appointment) async {
    print('\n⏳ Processing booking for ${appointment.patientName}...');
    await Future.delayed(Duration(milliseconds: 1500));

    // Simple validation check
    if (appointment.patientName.trim().isEmpty) {
      throw FormatException('Patient name cannot be empty.');
    }

    _appointments.add(appointment);
    logAction('Appointment ${appointment.appointmentId} booked successfully!');
  }

  void displayAllAppointments() {
    print('\n==================================================');
    print('               CLINIC APPOINTMENT SCHEDULE        ');
    print('==================================================');
    if (_appointments.isEmpty) {
      print('No appointments scheduled.');
      return;
    }

    for (var i = 0; i < _appointments.length; i++) {
      print('${i + 1}. ${_appointments[i].getDetails()}');
    }
    print('==================================================\n');
  }
}

Future<void> main() async {
  print('==================================================');
  print('     WELCOME TO THE CLINIC APPOINTMENT TRACKER    ');
  print('==================================================');

  final tracker = ClinicAppointmentTracker();

  try {
    await tracker.fetchAppointmentsFromDatabase();
    tracker.displayAllAppointments();

    final newCheckup = GeneralCheckup(
      appointmentId: 'APT-103',
      patientName: 'Jose Rizal',
      date: '2026-11-03',
      timeSlot: '02:00 PM',
      clinicRoom: 'Room 205',
    );
    await tracker.bookAppointment(newCheckup);

    final newSpecialist = SpecialistConsultation(
      appointmentId: 'APT-104',
      patientName: 'Andres Bonifacio',
      date: '2026-11-04',
      timeSlot: '04:00 PM',
      specialistName: 'Dizon',
      medicalSpecialty: 'Dermatology',
    );
    await tracker.bookAppointment(newSpecialist);

    tracker.displayAllAppointments();

    print('\n⚠️ Simulating invalid input scenario...');
    final invalidAppt = GeneralCheckup(
      appointmentId: 'APT-999',
      patientName: '', 
      date: '2026-11-05',
      timeSlot: '10:00 AM',
      clinicRoom: 'Room 101',
    );
    await tracker.bookAppointment(invalidAppt);

  } catch (e) {
    print('\n❌ ERROR CAUGHT IN MAIN: $e');
  } finally {
    print('\n==================================================');
    print('       SYSTEM EXECUTED AND TERMINATED CLEANLY     ');
    print('==================================================');
  }
}
