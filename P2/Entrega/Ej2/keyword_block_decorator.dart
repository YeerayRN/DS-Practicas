import 'secret_keeper.dart';
import 'secret_keeper_decorator.dart';

class KeywordBlockDecorator extends SecretKeeperDecorator {

  final List<String> _blockedKeywords = ['ignora', 'actua como', 'actúa como', 'olvida', 'jailbreak',
  'acronimo', 'acrónimo', 'revela'];

  KeywordBlockDecorator(SecretKeeper secretKeeper) : super(secretKeeper);

  @override
  Future<String> ask(String userMessage) async{
    String textoAChequear = userMessage.toLowerCase();

    for(final word in _blockedKeywords){
      if(textoAChequear.contains(word)){
        return 'Ja! Te pillé tramposo, ¿intentas manipularme?. No vayas de listo la próxima vez.';
      }
    }
    //El texto es seguro si llega aquí, lo pasamos al siguiente nivel
    return await super.ask(userMessage);
  }

}