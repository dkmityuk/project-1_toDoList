//import Foundation
//import UserNotifications
//import UIKit
//
//class NotificationManager: ObservableObject {
//    static let shared = NotificationManager()
//    @Published var settings: UNNotificationSettings?
//
//    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
//      UNUserNotificationCenter.current()
//        .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
//            self.fetchNotificationSettings()
//          completion(granted)
//        }
//    }
//
//    func fetchNotificationSettings() {
//      // 1
//      UNUserNotificationCenter.current().getNotificationSettings { settings in
//        // 2
//        DispatchQueue.main.async {
//          self.settings = settings
//        }
//      }
//    }
//    // 1
//    func scheduleNotification(task: TaskModel) {
//      // 2
//      let content = UNMutableNotificationContent()
//        content.title = task.text
//      content.body = "Gentle reminder for your task!"
//
//      // 3
//      var trigger: UNNotificationTrigger?
////      switch task.reminder {
////      case .time:
////        if let timeInterval = task.reminder {
////          trigger = UNTimeIntervalNotificationTrigger(
////            timeInterval: timeInterval,
////            repeats: task.reminder)
////        }
////      default:
////        return
////      }
//
//      // 4
//      if let trigger = trigger {
//        let request = UNNotificationRequest(
//          identifier: task.text,
//          content: content,
//          trigger: trigger)
//        // 5
//        UNUserNotificationCenter.current().add(request) { error in
//          if let error = error {
//            print(error)
//          }
//        }
//      }
//    }
//
//}
