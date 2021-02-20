import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/repository/dynamic_links_repository.dart';
import 'package:oogiritaizen/model/repository_impl/dynamic_links_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/dynamic_links_use_case.dart';

final dynamicLinksUseCaseProvider =
    Provider.autoDispose.family<DynamicLinksUseCase, String>(
  (ref, id) {
    final dynamicLinksUseCase = DynamicLinksUseCaseImpl(
      id,
      ref.watch(dynamicLinksRepositoryProvider),
    );
    ref.onDispose(dynamicLinksUseCase.disposed);
    return dynamicLinksUseCase;
  },
);

class DynamicLinksUseCaseImpl implements DynamicLinksUseCase {
  DynamicLinksUseCaseImpl(
    this.id,
    this.dynamicLinksRepository,
  );

  final String id;
  final DynamicLinksRepository dynamicLinksRepository;

  @override
  Future<void> setupDynamicLinks() async {
    await dynamicLinksRepository.setupDynamicLinks();
  }

  @override
  Stream<Uri> getDynamicLinksStream() {
    return dynamicLinksRepository.getDynamicLinksStream();
  }

  Future<void> disposed() async {}
}
