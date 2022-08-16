import Foundation
import CoreData

enum CoreDataError: Error {
  case noEntityByDescription
  case errorCreatingMO
  case noCurrentUser
}

// MARK: - CoreDataManager
final class CoreDataManager {
  static let shared = CoreDataManager()
  
  private init() {}
  
  private enum ManagedObjectNames {
    static let userMO = "UserMO"
    static let taskMO = "TaskMO"
  }
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Test_Project_1_Five_Systems")
    container.loadPersistentStores { [weak self] _, error in
      guard let self = self else { return }
      if let error = error as NSError? {
        assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  private var mainMOC: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  // MARK: - Users
  func save(user model: UserModel) throws {
    let fetchRequest = UserMO.fetchRequest()
    if let user = try? mainMOC.fetch(fetchRequest).first(where: { $0.isCurrentUser }) {
      let tasks = user.tasks
      model.fill(to: user, with: tasks)
    } else {
      let sameUser = ((try? mainMOC.fetch(fetchRequest)) ?? [] ).first(where: { $0.email == model.email })
      guard sameUser == nil else { sameUser?.isCurrentUser = true; return }
      guard
        let entityDescription = NSEntityDescription
          .entity(forEntityName: ManagedObjectNames.userMO, in: mainMOC)
      else { throw CoreDataError.noEntityByDescription }
      guard
        let userMO = NSManagedObject(entity: entityDescription, insertInto: mainMOC) as? UserMO
      else { throw CoreDataError.errorCreatingMO }
      model.fill(to: userMO, with: [])
      markUsersAsNotCurrent()
      userMO.isCurrentUser = true
    }
    saveContext()
  }
  
  func fetchCurrentUser() -> UserModel? {
    return fetchUsers().first(where: { $0.isCurrent })
  }
  
  func markUsersAsNotCurrent() {
    let fetchRequest = UserMO.fetchRequest()
    guard let users = try? mainMOC.fetch(fetchRequest) else { return }
    users.forEach { $0.isCurrentUser = false }
    saveContext()
  }
  
  // MARK: - Tasks
  func fetchTasks() -> [TaskModel] {
    return fetchCurrentUser()?.tasks ?? []
  }
  
  func save(task model: TaskModel) throws {
    let fetchRequest = UserMO.fetchRequest()
    if let currentUserMO = try? mainMOC.fetch(fetchRequest).first(where: { $0.isCurrentUser }) {
      guard
        let entityDescription = NSEntityDescription
          .entity(forEntityName: ManagedObjectNames.taskMO, in: mainMOC)
      else { throw CoreDataError.noEntityByDescription }
      guard
        let taskMO = NSManagedObject(entity: entityDescription, insertInto: mainMOC) as? TaskMO
      else { throw CoreDataError.errorCreatingMO }
        model.fill(to: taskMO, for: currentUserMO)
      if var tasks = currentUserMO.tasks?.allObjects as? [TaskMO] {
        tasks.append(taskMO)
        currentUserMO.tasks = NSSet(array: tasks)
      } else {
          let tasks = [taskMO]
          currentUserMO.tasks = NSSet(array: tasks)
      }
      saveContext()
    } else {
      print("No user")
    }
  }
  
  func markAsDone(task model: TaskModel, done: Bool) {
    let fetchRequest = TaskMO.fetchRequest()
    if let tasks = try? mainMOC.fetch(fetchRequest) {
      tasks.first(where: { $0.title == model.text && $0.descr == model.description})?.isDone = done
    }
    saveContext()
  }
  
  // MARK: - Private
  private func fetchUsers() -> [UserModel] {
    let fetchReuest = UserMO.fetchRequest()
    guard let users = try? mainMOC.fetch(fetchReuest) else { return [] }
    return users.compactMap { UserModel(managedObject: $0) }
  }
  
  private func saveContext() {
    do {
      try mainMOC.save()
    } catch let error as NSError {
      print(error.localizedDescription)
      print(error)
    }
  }
  
}


