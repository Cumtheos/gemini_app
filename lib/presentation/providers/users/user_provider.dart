import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

// se usa para genear el codigo con el comando del readme
part 'user_provider.g.dart';

@riverpod
//ref referencia al provider scop
//funcion que retorna una piesa del estado que quiero que sea global o alguna parte de la app
User geminiUser(Ref ref) {
  final geminiUser = User(
    id: Uuid().v4(),
    firstName: 'Gemini',
    imageUrl: 'https://i.pravatar.cc/200?img=33',
  );
  return geminiUser;
}

@riverpod
User user(Ref ref) {
  final user = User(
    id: Uuid().v4(),
    firstName: 'Juan',
    imageUrl: 'https://i.pravatar.cc/200?img=12',
  );

  return user;
}
