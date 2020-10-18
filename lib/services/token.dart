import 'package:devfest2020/res.dart';
import 'package:mpesa_sdk_dart/mpesa_sdk_dart.dart';

String token = MpesaConfig.getBearerToken(
  apiKey_mpesa,
  publicKey_mpesa,
);
