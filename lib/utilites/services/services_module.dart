import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/generated/l10n.dart';

@module
abstract class ServiceModule {
  @Singleton()
  S get s => S();
}
