import Foundation

// MARK: - TaskModel
struct TaskModel {
  let text: String
  let description: String
  let date: Date
  let isDone: Bool
}

extension TaskModel {
  init?(managedObject: Task) {
    guard
      let title = managedObject.title,
      let date = managedObject.date,
      let description = managedObject.descr
    else { return nil }
    self.text = title
    self.description = description
    self.isDone = managedObject.isDone
    self.date = date
  }
  
  func fill(to managedObject: Task) {
    managedObject.title = text
    managedObject.descr = description
    managedObject.date = date
    managedObject.isDone = isDone
  }
}
