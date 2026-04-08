import 'secret_keeper.dart';

abstract class SecretKeeperDecorator implements SecretKeeper{

    final SecretKeeper innerKeeper;

    SecretKeeperDecorator(this.innerKeeper);

    @override
    String get secretWord => innerKeeper.secretWord;
    
    @override
    Future<String> ask(String userMessage) async{
        return await innerKeeper.ask(userMessage);
    }
}