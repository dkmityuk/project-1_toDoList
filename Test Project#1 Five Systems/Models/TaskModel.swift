import Foundation

// MARK: - TaskModel
struct TaskModel {
  let text: String
  let description: String
  let date: String
  let isDone: Bool
  let taskImage: Data?
//  var reminderEnabled = false
//  var reminder: Date?
}

extension TaskModel {
  init?(managedObject: TaskMO) {
    guard
      let title = managedObject.title,
      let date = managedObject.date,
      let description = managedObject.descr
    else { return nil }
    self.text = title
    self.description = description
    self.isDone = managedObject.isDone
    self.date = date
    self.taskImage = managedObject.taskImage
  }
  
  func fill(to managedObject: TaskMO, for user: UserMO) {
    managedObject.title = text
    managedObject.descr = description
    managedObject.date = date
    managedObject.isDone = isDone
    managedObject.taskImage = taskImage
    managedObject.user = user
  }
}
