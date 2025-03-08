import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';
import 'package:health_sync_client/features/appointment/data/service/DoctorService.dart';
import 'package:health_sync_client/features/medication/data/model/pillSchedule.dart';
import 'package:health_sync_client/features/medication/data/service/pillScheduleService.dart';

class DoctorRepo {
  final DoctorService _service = DoctorService();

  Future<List<DoctorModel>> getDoctors() async {
    return await _service.fetchDoctors();
  }
}
