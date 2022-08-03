import Foundation
import CoreData

enum CoreDataError: Error {
  case noEntityByDescription
  case errorCreatingMO
}

// MARK: - CoreDataManager
final class CoreDataManager {
  static let shared = CoreDataManager()
  
  private init() {}
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Test_Project_1_Five_Systems")
    container.loadPersistentStores { [weak self] _, error in
      guard let self = self else { return }
      if let error = error as NSError? {
//        self.destroyPersistaintStores()
        assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  private var mainMOC: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
    
  func save(task: TaskModel) throws {
    guard
      let entityDescription = NSEntityDescription
        .entity(forEntityName: "Task", in: mainMOC)
    else { throw CoreDataError.noEntityByDescription }
    guard
      let taskMO = NSManagedObject(entity: entityDescription, insertInto: mainMOC) as? Task
    else { throw CoreDataError.errorCreatingMO }
    task.fill(to: taskMO)
    do {
      try mainMOC.save()
    } catch let error {
      throw error
    }
  }

  func fetchTasks() -> [TaskModel] {
    let fetchReuest: NSFetchRequest<Task> = Task.fetchRequest()
    guard let tasks = try? mainMOC.fetch(fetchReuest) else { return [] }
    return tasks.compactMap { TaskModel(managedObject: $0) }
  }
}
