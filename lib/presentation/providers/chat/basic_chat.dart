import 'package:flutter_chat_types/flutter_chat_types.dart'
    show Message, PartialText, User, TextMessage;
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

// estamos utilizando riverpod generador de código
// se le añade esto para poder generar el código automáticamente
part 'basic_chat.g.dart';

final uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {
  final gemini = GeminiImpl();
  // asi evitamos leer el provider en cada mensaje
  late User geminiUser;

  //estado de listado de mensajes
  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    return [];
  }

  void addMessage({required PartialText partialText, required User user}) {
    // TODO: agregar condicion cuando vengan imágines
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    _createTextMessage(partialText.text, author);
    // se llama a geminiimpl
    // _geminiTextResponse(partialText.text);
    _geminiTextResponseStream(partialText.text);
  }

  void _geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);

    // await Future.delayed(Duration(seconds: 2));
    final textResponse = await gemini.getResponse(prompt);

    _createTextMessage(textResponse, geminiUser);

    _setGeminiWritingStatus(false);
  }

  void _geminiTextResponseStream(String prompt) async {
    // este seria el loader por ello elimiamos el que cambia el estado
    _createTextMessage('Gemini está pensando...', geminiUser);

    // Escuchar el stream de respuesta
    gemini.getResponseStream(prompt).listen((responseChunk) {
      if (responseChunk.isEmpty) return;

      // updatedmessages es una copia del estado actual
      final updatedMessages = [...state];
      // obtenemos el ultimo mensaje que es el de gemini
      // con el copywith tomamos el ultomo mensaje y le actualizamos el texto
      final updatedMessage = (updatedMessages.first as TextMessage).copyWith(
        text: responseChunk,
      );
      // actualizamos el primer mensaje
      // sin volver a crear uno nuevo
      updatedMessages[0] = updatedMessage;
      // atualizamos el state de un golpe
      state = updatedMessages;
    });

    // _createTextMessage(textResponse, geminiUser);
  }
  // Helper methods

  void _setGeminiWritingStatus(bool isWriting) {
    final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
    isWriting
        ? isGeminiWriting.setIsWriting()
        : isGeminiWriting.setIsNotWriting();
  }

  void _createTextMessage(String text, User author) {
    final message = TextMessage(
      id: uuid.v4(),
      author: author,
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [message, ...state];
  }
}
