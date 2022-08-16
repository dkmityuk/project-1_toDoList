import Foundation

struct UserModel {
    let name: String
    let email: String
    let isCurrent: Bool
    let tasks: [TaskModel]
}

extension UserModel {
    init?(managedObject: UserMO) {
        guard
            let name = managedObject.name,
            let email = managedObject.email
        else { return nil }
        self.name = name
        self.email = email
        self.isCurrent = managedObject.isCurrentUser
      if let array = managedObject.tasks?.allObjects {
        self.tasks = array
          .compactMap { $0 as? TaskMO }
          .compactMap { TaskModel(managedObject: $0) }
      } else {
        self.tasks = []
      }
    }
    
  func fill(to managedObject: UserMO, with tasks: NSSet?) {
      managedObject.name = name
      managedObject.email = email
      managedObject.tasks = tasks
    }
}
