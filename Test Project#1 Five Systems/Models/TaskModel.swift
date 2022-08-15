import Foundation

// MARK: - TaskModel
struct TaskModel {
  let text: String
  let description: String
  let date: String
  var isDone: Bool
  let taskImage: Data?
}

extension TaskModel {
  init?(managedObject: Task) {
    guard
      let title = managedObject.title,
      let date = managedObject.date,
      let description = managedObject.descr,
      let taskImage = managedObject.taskImage
    else { return nil }
    self.text = title
    self.description = description
    self.isDone = managedObject.isDone
    self.date = date
    self.taskImage = taskImage
  }
  
  func fill(to managedObject: Task) {
    managedObject.title = text
    managedObject.descr = description
    managedObject.date = date
    managedObject.isDone = isDone
    managedObject.taskImage = taskImage
  }
}
