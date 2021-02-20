import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/dynamic_links_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/dynamic_links_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case/dynamic_links_use_case.dart';

final dynamicLinksUseCaseProvider =
    Provider.autoDispose.family<DynamicLinksUseCase, String>(
  (ref, id) {
    final dynamicLinksUseCase = DynamicLinksUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(dynamicLinksRepositoryProvider),
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
  );

  final String id;
  final AuthenticationRepository authenticationRepository;
  final DynamicLinksRepository dynamicLinksRepository;

  @override
  Future<void> setupDynamicLinks() async {
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
          final email = continueUri.queryParameters['email'];
          final password = continueUri.queryParameters['pw'];
          await authenticationRepository.loginWithEmailAndPassword(
            email: email,
            password: password,
          );
        }
      },
    );
  }

  @override
  Stream<Uri> getDynamicLinksStream() {
    return dynamicLinksRepository.getDynamicLinksStream();
  }

  Future<void> disposed() async {}
}
