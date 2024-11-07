final Map<int, String> _httpErrMsgs = {
  //3xx codes:
  300: "The server has more than one possible response.",
  301: "The requested page has moved to a new URL.",
  302: "The requested page has moved temporarily to a new URL.",
  303: "The requested page can be found under a different URL.",
  304: "The requested page has not been modified since the last request.",
  305: "The requested page must be accessed through a proxy.",
  306: "Unused.",
  307: "The requested page has moved temporarily to a new URL.",
  308: "The requested page has moved permanently to a new URL.",

  //4xx codes:
  400: "The server could not understand the request due to invalid syntax.",
  401: "The client must authenticate itself to get the requested response.",
  402: "Payment is required to get the requested response.",
  403: "The client does not have the necessary permissions.",
  404: "The server can not find the requested page.",
  405: "The method specified in the request is not allowed.",
  406: "The server can only generate a response that is"
      " not accepted by the client.",
  407: "You must authenticate with a proxy server before this"
      " request can be served.",
  408: "The request took longer than the server was prepared to wait.",
  409: "The request could not be completed because of a conflict.",
  410: "The requested page is no longer available.",
  411: "The request did not specify the length of its content.",
  412: "The server does not meet one of the preconditions that the"
      " requester put on the request.",
  413: "The request is larger than the server is willing or able to process.",
  414: "The URI provided was too long for the server to process.",
  415: "The request entity has a media type which the server"
      " or resource does not support.",
  416: "The client has asked for a portion of the file, but the"
      " server cannot supply that portion.",
  417: "The server cannot meet the requirements of the Expect"
      " request-header field.",
  418: "I'm a teapot.",
  421: "The request was directed at a server that is not"
      " able to produce a response.",
  422: "The request was well-formed but was unable to be"
      " followed due to semantic errors.",
  423: "The resource that is being accessed is locked.",

  //5xx codes:
  500: "The server has encountered a situation it doesn't know how to handle.",
  501:
      "The request method is not supported by the server and cannot be handled.",
  502: "The server, while acting as a gateway or proxy, received an invalid "
      "response from the upstream server it accessed in attempting to fulfill "
      "the request.",
  503: "The server is not ready to handle the request.",
  504:
      "The server, while acting as a gateway or proxy, did not receive a timely"
          " response from the upstream server specified by the URI.",
  505: "The server does not support the HTTP protocol version "
      "used in the request.",
  506: "Transparent content negotiation for the request results"
      " in a circular reference.",
};

/// ElbeError is a class that represents an error in the Elbe framework.
/// It contains a code, message and optional details.
/// It can be localized using the ElbeErrors service.
class ElbeError {
  late final String code;
  final String message;
  final dynamic details;
  final ElbeError? cause;

  ElbeError._(String code, this.message, this.cause, this.details)
      : code = code.toUpperCase();

  ElbeError(String code, String message, [dynamic cause])
      : this._(code, message, cause is ElbeError ? cause : null,
            cause is ElbeError ? null : cause);

  ElbeError.unknown([dynamic cause])
      : this("UNKNOWN", "An unknown error occurred", cause);

  /// Create an ElbeError instance for an HTTP error.
  /// the [statusCode] is the HTTP status code and will be prefixed with "HTTP_".
  factory ElbeError.http(int statusCode, {String? message, dynamic details}) {
    final msg = _httpErrMsgs[statusCode] ?? "Network error: HTTP $statusCode";
    return ElbeError("HTTP_$statusCode", msg, details);
  }

  static ElbeError Function(dynamic err) make(String code, String message) =>
      (err) => ElbeError(code, message, err);

  /// Returns a copy of the error with the provided values.
  ElbeError copyWith({String? code, String? message}) {
    return ElbeError._(
        code ?? this.code, message ?? this.message, cause, details);
  }

  List<ElbeError> get causeChain => [this, ...(cause?.causeChain ?? [])];
}
