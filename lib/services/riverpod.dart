import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';
import 'package:twitter_messaging_app/services/apis.dart';

final isGoogleSignedIn = StreamProvider((ref) => APIs.auth.userChanges());

final selectedIndexProvider = StateProvider((ref) => 4);

// final listOfUsersProvider = StateProvider<List<ChatUser>>((ref) => []);

final currentUserProvider = StateProvider<ChatUser>((ref) => APIs.me);

final emojiSelectorStateProvider = StateProvider((ref) => false);
final imageUploadStateProvider = StateProvider((ref) => false);

final userExistProvider = StreamProvider((ref) => APIs.auth.authStateChanges());
