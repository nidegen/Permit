import Foundation
import CoreLocation
import UserNotifications
import Photos
import AVKit
import Contacts
import Combine

public class Permissions: ObservableObject {
  var locationManager = CLLocationManager()
  @Published public var camera: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
  @Published public var location: CLAuthorizationStatus =  CLLocationManager().authorizationStatus
  @Published public var photo: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
  @Published public var notification: UNAuthorizationStatus = .notDetermined
  @Published public var contacts: CNAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
  
  var subscription: AnyCancellable!
  
  public init() {
    subscription = NotificationCenter.default
    .publisher(for: UIApplication.didBecomeActiveNotification)
      .sink { _ in
        self.updateStatus()
      }
    
    DispatchQueue.global().async {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        DispatchQueue.main.async {
          self.notification = settings.authorizationStatus
        }
      }
    }
  }
}

public extension Permissions {
  func updateStatus() {
    photo = PHPhotoLibrary.authorizationStatus()
    camera = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    location = locationManager.authorizationStatus
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      DispatchQueue.main.async {
        self.notification = settings.authorizationStatus
      }
    }
  }
  
  func requestCameraPermission() {
    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) -> Void in
      if granted == true {
        // User granted
      } else {
        // User rejected
      }
    })
  }
  
  func requestContactsPermission() {
    CNContactStore().requestAccess(for: .contacts) { (value, error) in
      DispatchQueue.main.async {
        self.contacts = CNContactStore.authorizationStatus(for: .contacts)
      }
    }
  }
  
  func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
      if granted {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
          DispatchQueue.main.async {
            self.notification = settings.authorizationStatus
          }
        }
      }
    }
  }
  
  func requestPhotoAccess() {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
      DispatchQueue.main.async {
        self.photo = status
      }
    }
  }
  
  func requestLocationPermission() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func requestBackgroundLocationPermission() {
    locationManager.requestAlwaysAuthorization()
  }
  
  static var contactsAreAuthorized: Bool {
    CNContactStore.authorizationStatus(for: .contacts) == .authorized
  }
}

extension CLAuthorizationStatus {
  var authorized: Bool {
    self == .authorizedAlways || self == .authorizedWhenInUse
  }
  var denied: Bool {
    self == .denied
  }
}

extension Permissions {
  static var shouldShowPermissionView = "shouldShowPermissionView"
}
