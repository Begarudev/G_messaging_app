import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';
import 'package:twitter_messaging_app/services/apis.dart';

final isGoogleSignedIn = StreamProvider((ref) => APIs.auth.userChanges());

final selectedIndexProvider = StateProvider((ref) => 4);

// final listOfUsersProvider = StateProvider<List<ChatUser>>((ref) => []);

final currentUserProvider = Provider<ChatUser>((ref) => APIs.me);
