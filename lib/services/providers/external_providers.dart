/// Future generative AI connection point. Stage 1 uses local rules only.
abstract class ExternalAiProvider {
  Future<String> assistSituationUnderstanding(String input);
}

class LocalStubAiProvider implements ExternalAiProvider {
  @override
  Future<String> assistSituationUnderstanding(String input) async {
    return '로컬 규칙 엔진이 처리합니다. 외부 생성형 AI는 아직 연결되지 않았습니다. 입력: $input';
  }
}

abstract class LocationProvider {
  Future<String?> currentLocationLabel();
}

class UnsupportedLocationProvider implements LocationProvider {
  @override
  Future<String?> currentLocationLabel() async => null;
}

abstract class WeatherProvider {
  Future<double?> currentTemperatureC();
}

class UnsupportedWeatherProvider implements WeatherProvider {
  @override
  Future<double?> currentTemperatureC() async => null;
}

abstract class SensorDataProvider {
  Future<Map<String, double>> readSensors();
}

class SampleSensorDataProvider implements SensorDataProvider {
  @override
  Future<Map<String, double>> readSensors() async => {
    'smoke': 0,
    'gas': 0,
    'current': 10,
  };
}

abstract class NotificationContactProvider {
  Future<bool> notifyGuardian(String message);
  Future<bool> requestOfficialRescue(String message);
}

class LocalNoOpNotificationProvider implements NotificationContactProvider {
  @override
  Future<bool> notifyGuardian(String message) async => false;

  @override
  Future<bool> requestOfficialRescue(String message) async => false;
}
