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
    _geminiTextResponse(partialText.text);
  }

  void _geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);

    // await Future.delayed(Duration(seconds: 2));
    final textResponse = await gemini.getResponse(prompt);

    _createTextMessage(textResponse, geminiUser);

    _setGeminiWritingStatus(false);
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
