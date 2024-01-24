
import 'fazpass.dart';
import 'package:flutter/services.dart';

/// Type of exception to be generated when an error occurs in the [Fazpass.generateMeta] method.
sealed class FazpassException extends PlatformException {
  FazpassException(PlatformException e)
      : super(code: e.code, message: e.message);
}

/// Thrown when device hasn't set a password / enrolled a biometric information.
class BiometricNoneEnrolledError extends FazpassException {
  BiometricNoneEnrolledError(super.e);
}

/// Thrown when local authentication is cancelled by user.
class BiometricAuthFailedError extends FazpassException {
  BiometricAuthFailedError(super.e);
}

/// Thrown to indicate that biometric is not available at the moment.
class BiometricUnavailableError extends FazpassException {
  BiometricUnavailableError(super.e);
}

/// Thrown when biometric is not supported by the device.
class BiometricUnsupportedError extends FazpassException {
  BiometricUnsupportedError(super.e);
}

/// Thrown to indicate that encryption process is failed. Likely because
/// you used the wrong public key.
class EncryptionException extends FazpassException {
  EncryptionException(super.e);
}

/// Thrown when public key doesn't exist in the src/assets folder (or not
/// referenced properly in iOS)
class PublicKeyNotExistException extends FazpassException {
  PublicKeyNotExistException(super.e);
}

/// Thrown when [Fazpass.init] method hasn't been called once.
class UninitializedException extends FazpassException {
  UninitializedException(super.e);
}

/// Thrown when there is a major security update for user's device and user is
/// required to update immediately. Android only.
class BiometricSecurityUpdateRequiredError extends FazpassException {
  BiometricSecurityUpdateRequiredError(super.e);
}