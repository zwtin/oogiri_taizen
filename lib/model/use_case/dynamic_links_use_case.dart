abstract class DynamicLinksUseCase {
  Future<void> setupDynamicLinks();
  Stream<Uri> getDynamicLinksStream();
}
