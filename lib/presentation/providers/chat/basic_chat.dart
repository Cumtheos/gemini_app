import 'package:flutter_chat_types/flutter_chat_types.dart'
    show Message, PartialText, User, TextMessage;
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'basic_chat.g.dart';

final uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {

  final gemini = GeminiImpl();

  //estado de listado de mensajes
  @override
  List<Message> build() {
    return [];
  }

  void addMessage({required PartialText partialText, required User user}) {
    // TODO: agregar condicion cuando vengan imágines
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    final message = TextMessage(
      id: uuid.v4(),
      author: author,
      text: partialText.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    //añade el mensaje al inicio de la lista
    state = [message, ...state];
    // se llama a geminiimpl
    _geminiTextResponse(partialText.text);
  }

  void _geminiTextResponse(String prompt) async {
    final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
    final geminiUser = ref.read(geminiUserProvider);

    isGeminiWriting.setIsWriting();
    // await Future.delayed(Duration(seconds: 2));
    final textResponse = await gemini.getResponse(prompt);

    final message = TextMessage(
      id: uuid.v4(),
      author: geminiUser,
      // text: 'Hola Mundo desde geminini: $prompt',
      text: textResponse,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    //añade el mensaje al inicio de la lista
    state = [message, ...state];

    isGeminiWriting.setIsNotWriting();
  }
}
