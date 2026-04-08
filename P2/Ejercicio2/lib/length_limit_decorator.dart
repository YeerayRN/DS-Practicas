import 'secret_keeper_decorator.dart';

class LengthLimitDecorator extends SecretKeeperDecorator {
  final int maxLength = 200;

  LengthLimitDecorator(super.innerKeeper);

  @override
  Future<String> ask(String userMessage) async {
    final response = await super.ask(userMessage);

    if (response.length > maxLength) {
      return '${response.substring(0, maxLength)}... [El guardián se calla abruptamente]';
    }

    return response;
  }
}