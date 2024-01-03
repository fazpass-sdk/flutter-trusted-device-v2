
import 'package:flutter/services.dart';

sealed class FazpassException extends PlatformException {
  FazpassException(PlatformException e)
      : super(code: e.code, message: e.message);
}

class BiometricNoneEnrolledError extends FazpassException {
  BiometricNoneEnrolledError(super.e);
}

class BiometricAuthFailedError extends FazpassException {
  BiometricAuthFailedError(super.e);
}

class BiometricUnavailableError extends FazpassException {
  BiometricUnavailableError(super.e);
}

class BiometricUnsupportedError extends FazpassException {
  BiometricUnsupportedError(super.e);
}

class EncryptionException extends FazpassException {
  EncryptionException(super.e);
}

class PublicKeyNotExistException extends FazpassException {
  PublicKeyNotExistException(super.e);
}

class UninitializedException extends FazpassException {
  UninitializedException(super.e);
}

/// ANDROID ONLY
class BiometricSecurityUpdateRequiredError extends FazpassException {
  BiometricSecurityUpdateRequiredError(super.e);
}