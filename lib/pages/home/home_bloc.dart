import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'home_event.dart';
import 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<HomeUserActionChoosed>((event, emit) async {
      switch (event.action) {
        case UserAction.uploadFiles:
          _uploadFiles(event, emit);
          break;
        default:
          break;
      }
    });

    on<HomePageOpened>((event, emit) async {
      getApplicationDocumentsDirectory().then((value) {
        Hive.init(value.path);
        print('Hive initialized');
      });
    });
  }

  var _loadController = getIt<LoadController>();

  Future<void> _uploadFiles(
    HomeUserActionChoosed event,
    Emitter<HomeState> emit,
  ) async {
    if (event.values != null) {
      for (int i = 0; i < event.values!.length; i++) {
        await _loadController.uploadFile(filePath: event.values![i]);
      }
    }
  }
}
