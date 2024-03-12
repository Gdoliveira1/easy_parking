import "dart:async";
import "dart:math";
import "package:easy_parking/src/app_wrap_state.dart";
import "package:easy_parking/src/domain/models/response_status_model.dart";
import "package:flutter_bloc/flutter_bloc.dart";

/// A Cubit responsible for managing app-level alerts and snackbars.
///
/// This Cubit handles displaying alerts and snackbars in the application.
/// It allows for displaying custom responses with configurable durations.
/// The alerts and snackbars are reset after a random delay to prevent overlapping display.
class AppWrapCubit extends Cubit<AppWrapState> {
  AppWrapCubit._internal() : super(const AppWrapState());

  static final AppWrapCubit _instance = AppWrapCubit._internal();

  static AppWrapCubit get instance => _instance;

  static bool _hasInit = false;

  /// Initializes the AppWrapCubit instance.
  ///
  /// This method should be called once to ensure proper initialization of the cubit.
  static void init() async {
    if (!_hasInit) {
      _hasInit = true;
    }
  }

  final Random _random = Random();

  /// Displays an alert with the given response model.
  ///
  /// The [duration] parameter specifies the duration in seconds for which the alert should be displayed.
  void alert(ResponseStatusModel response, {int duration = 8}) {
    // Emit the state with the alert response and duration
    Future.delayed(const Duration(milliseconds: 80), () {
      emit(state.copyWith(
        alertResponse: response,
        duration: duration,
      ));
    });
    // Reset the alert after a random delay
    _reset(resetAlert: true);
  }

  /// Resets the alert and snackbar after a random delay.
  void _reset({bool resetSnackBar = false, bool resetAlert = false}) {
    Future.delayed(Duration(milliseconds: 200 + _random.nextInt(500)), () {
      // Reset the snackbar if requested
      if (resetSnackBar) {
        emit(state.copyWith(
          snackBarResponse: null,
          alertResponse: state.alertResponse,
        ));
      }
      // Reset the alert if requested
      if (resetAlert) {
        emit(state.copyWith(
          alertResponse: null,
          snackBarResponse: state.snackBarResponse,
        ));
      }
    });
  }
}
