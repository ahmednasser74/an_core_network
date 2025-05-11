import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:an_core_log/app_logger.dart';
import 'package:an_core_network/an_core_network.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/io.dart';

mixin NetworkSSLPinning {
  final logger = networkPackageGetIt<AppLogger>();

  void addSSLPinning(String sslPinningHash, Dio dio) {
    final SecurityContext securityContext = SecurityContext(withTrustedRoots: true);
    final HttpClient client = HttpClient(context: securityContext);

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          try {
            final der = cert.der;
            final sha256 = sha256Digest(der);
            final isAllowedHash = sha256 == sslPinningHash;
            if (isAllowedHash) {
              logger.info('SSLPinning: $sslPinningHash');
              return true;
            } else {
              logger.error('SSLPinningException', sslPinningHash);
              throw const SSLPinningException();
            }
          } catch (e) {
            logger.error('SSLPinningException', sslPinningHash);
            throw const SSLPinningException();
          }
        };
        return client;
      },
    );
  }

  String sha256Digest(Uint8List bytes) {
    final hash = sha256.convert(bytes);
    return base64.encode(hash.bytes);
  }
}
