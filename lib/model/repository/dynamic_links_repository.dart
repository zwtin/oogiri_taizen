abstract class DynamicLinksRepository {
  Future<void> setupDynamicLinks();
  Stream<Uri> getDynamicLinksStream();
}
