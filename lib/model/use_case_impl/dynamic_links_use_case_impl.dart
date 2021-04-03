import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/dynamic_links_repository.dart';
import 'package:oogiritaizen/model/repository/user_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/dynamic_links_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/user_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/dynamic_links_use_case.dart';

final dynamicLinksUseCaseProvider =
    Provider.autoDispose.family<DynamicLinksUseCase, String>(
  (ref, id) {
    final dynamicLinksUseCase = DynamicLinksUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(dynamicLinksRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(dynamicLinksUseCase.disposed);
    return dynamicLinksUseCase;
  },
);

class DynamicLinksUseCaseImpl implements DynamicLinksUseCase {
  DynamicLinksUseCaseImpl(
    this.id,
    this.authenticationRepository,
    this.dynamicLinksRepository,
    this.userRepository,
  );

  final String id;
  final AuthenticationRepository authenticationRepository;
  final DynamicLinksRepository dynamicLinksRepository;
  final UserRepository userRepository;

  @override
  Future<void> setupDynamicLinks() async {
    try {
      await dynamicLinksRepository.setupDynamicLinks();
      dynamicLinksRepository.getDynamicLinksStream().listen(
        (Uri uri) async {
          final apiKey = uri.queryParameters['apiKey'];
          final mode = uri.queryParameters['mode'];
          final oobCode = uri.queryParameters['oobCode'];
          final continueUrl = uri.queryParameters['continueUrl'];
          final lang = uri.queryParameters['lang'];

          if (oobCode != null) {
            await authenticationRepository.applyActionCode(
              actionCode: oobCode,
            );
          }
          if (mode == 'verifyEmail' && continueUrl != null) {
            final continueUri = Uri.parse(continueUrl);
            final token = continueUri.queryParameters['token'];
            await authenticationRepository.loginWithCustomToken(token: token);
            final user = authenticationRepository.getLoginUser();
            await userRepository.createUser(userId: user.id);
          }
        },
      );
    } on Exception catch (error) {}
  }

  @override
  Stream<Uri> getDynamicLinksStream() {
    return dynamicLinksRepository.getDynamicLinksStream();
  }

  Future<void> disposed() async {}
}
