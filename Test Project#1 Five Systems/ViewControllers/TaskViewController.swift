import UIKit
import CoreData

// MARK: - SectionModel
struct SectionModel {
    let title: String
    let items: [TaskModel]
}

// MARK: - ViewController
class TaskViewController: UIViewController {
    
    @IBOutlet weak var taskTableView: UITableView!
    
    var sectionItems: [SectionModel] {
        let tasks = CoreDataManager.shared.fetchTasks()
        var datesArray = [String]()
        var sections = [SectionModel]()
        
        for task in tasks {
            if !datesArray.contains(task.date) {
                datesArray.append(task.date)
            }
        }
        
        for date in datesArray {
            sections.append(
                SectionModel(
                    title: date,
                    items: tasks.filter { $0.date == date })
            )
        }
        return sections
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        self.title = "Tasks"
    }
    
    @IBAction func addNewTaskButtonPressed(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "NewTaskViewController") as! NewTaskViewController
        controller.refreshDataHandler = { [weak self] in
            guard let self = self else { return }
            self.taskTableView.reloadData()
        }
        present(controller, animated: true, completion: nil)
    }
    
}

// MARK: - TableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sectionItems.count - 1 >= section else { return .zero }
        return sectionItems[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sellName, for: indexPath) as! TaskTableViewCell
        guard
            sectionItems.count - 1 >= indexPath.section,
            sectionItems[indexPath.section].items.count - 1 >= indexPath.row
        else { return cell }
        let model = sectionItems[indexPath.section].items[indexPath.row]
        cell.setUp(object: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sectionItems.count - 1 >= section else { return nil }
        return sectionItems[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailTaskViewController{
            vc.selectedTask = sectionItems[indexPath.section].items[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Constants
fileprivate enum Constants {
    static let entity = "Task"
    static let sortDate = "date"
    static let sellName = "taskCell"
}
