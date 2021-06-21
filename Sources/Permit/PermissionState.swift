import Foundation
import CoreLocation
import UserNotifications
import Photos
import AVKit
import Contacts

enum PermissionState: String {
  case undefined = "Not Determined"
  case authorized = "Allowed"
  case denied = "Denied"
  
  var buttonTitle: String {
    switch self {
    case .authorized:
      return "ALLOWED"
    case .denied:
      return "DENIED"
    case .undefined:
      return "ALLOW"
    }
  }
}

extension AVAuthorizationStatus {
  var state: PermissionState {
    switch self {
    case .authorized:
      return .authorized
    case .denied:
      return .denied
    case .notDetermined:
      return .undefined
    case .restricted:
      return .denied
    default:
      return .denied
    }
  }
}

extension CLAuthorizationStatus {
  var state: PermissionState {
    switch self {
    case .authorizedAlways:
      return .authorized
    case .authorizedWhenInUse:
      return .authorized
    case .denied:
      return .denied
    case .notDetermined:
      return .undefined
    case .restricted:
      return .denied
    default:
      return .denied
    }
  }
}

extension PHAuthorizationStatus {
  var state: PermissionState {
    switch self {
    case .authorized:
      return .authorized
    case .denied:
      return .denied
    case .notDetermined:
      return .undefined
    case .restricted:
      return .denied
    case .limited:
      return .authorized
    default:
      return .denied
    }
  }
}

extension CNAuthorizationStatus {
  var state: PermissionState {
    switch self {
    case .authorized:
      return .authorized
    case .denied:
      return .denied
    case .notDetermined:
      return .undefined
    case .restricted:
      return .denied
    default:
      return .denied
    }
  }
}

extension UNAuthorizationStatus {
  var state: PermissionState {
    switch self {
    case .authorized:
      return .authorized
    case .denied:
      return .denied
    case .notDetermined:
      return .undefined
    default:
      return .denied
    }
  }
}
