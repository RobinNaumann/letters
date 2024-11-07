import 'dart:io';

import 'package:elbe/util/json_tools.dart';

import 'elbe_error.dart';

typedef L10nMap = Map<String, JsonMap<String>>;

/// Opt is a function that returns a nullable value. This is used to
/// work with optional values in the context of copyWith methods.
/// use the optEval function to evaluate the value.
typedef Opt<T> = T? Function()?;

/// optEval evaluates the function if it is not null, otherwise returns the self value.
/// This is used to work with optional values in the context of copyWith methods.
T? optEval<T>(Opt<T> f, T? self) => f == null ? self : f();

/// shortcut for `ElbeErrors.i`
/// use `ElbeErrors.init(...)` to initialize the ElbeErrors instance.
ElbeErrors get elbeErrs => ElbeErrors.i;

extension ZonedFn<T> on T Function() {
  /// this is a shortcut for `elbeErrs.zoned(() => ...)`
  T zoned(ElbeError Function(dynamic) onError) =>
      elbeErrs.zoned(this, onError: onError);
}

class ElbeErrors {
  /// get the instance of ElbeErrors. Returns null if not initialized.
  /// you can also use the global `elbeErrors` shortcut.
  static ElbeErrors i = ElbeErrors.init(l10n: {});

  /// l10n is a map of locale to error messages. The key is the error code.
  /// For each error, provide a Map of locales and the error messages.
  ///
  /// Note: Provide an entry for `UNKNOWN` to handle unknown errors.
  ///
  /// All error codes are converted into UPPER CASE
  ///
  /// Example:
  /// ```json
  /// {
  ///   "AN_ERR_42": {
  ///     "en_US": "Error message in English",
  ///     "de_DE": "Fehlermeldung auf Deutsch"
  ///   }
  /// }
  final L10nMap l10n;

  /// Initialize the ElbeErrors instance with the l10n map.
  /// This is a singleton class. Use the `i` getter to get the instance.
  /// later, you can call `resolve` to get the localized error message.
  ElbeErrors.init({required L10nMap l10n})
      : l10n = l10n.map((k, v) => MapEntry(k.toUpperCase(), v)) {
    i = this;
  }

  T zoned<T>(T Function() f, {ElbeError Function(dynamic)? onError}) {
    try {
      return f();
    } catch (e) {
      throw (onError ?? ElbeError.unknown).call(e);
    }
  }

  Future<T> zonedAsync<T>(Future<T> Function() f,
      {ElbeError Function(dynamic)? onError}) async {
    try {
      return await f();
    } catch (e) {
      throw (onError ?? ElbeError.unknown).call(e);
    }
  }

  ElbeError resolve(dynamic error) {
    // if error is not an instance of ElbeError, return a string representation
    final ElbeError eerr = (error is ElbeError)
        ? error
        : ElbeError("UNKNOWN", "an unknown error has occurred", error);

    final locale = Platform.localeName;
    final locLang = locale.split("_").first;

    final locMsg =
        l10n[eerr.code]?[locale] ?? l10n[eerr.code]?[locLang] ?? error.message;

    return eerr.copyWith(message: locMsg);
  }
}
