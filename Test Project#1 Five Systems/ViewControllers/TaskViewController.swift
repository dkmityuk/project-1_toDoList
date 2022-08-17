import UIKit
import CoreData
import CoreMedia

// MARK: - SectionModel
struct SectionModel {
    let title: String
    var items: [TaskModel]
    var isOpen = true
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
                    items: tasks.filter { $0.date == date },
                    isOpen: false)
            )
        }
        return sections
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        taskTableView.register(UINib(nibName: "TaskDateHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "TaskDateHeader")
        navigationItem.title = "Tasks"
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
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        guard
            sectionItems.count - 1 >= indexPath.section,
            sectionItems[indexPath.section].items.count - 1 >= indexPath.row
        else { return cell }
        let model = sectionItems[indexPath.section].items[indexPath.row]
        cell.setUp(object: model)
        cell.taskStatusChangedHandler = { [weak self] status in
            CoreDataManager.shared.markAsDone(task: model, done: status)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard sectionItems.count - 1 >= section else { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerName ) as? TaskDateHeader else { return UIView()}
        let object = sectionItems[section]
        header.setUp(object: object)
//        header.showTasksButton.tag = section
//        header.showTasksButton.addTarget(self, action: #selector(self.openSection), for: .touchUpInside)
        return header
    }
//
//    @objc func openSection(button: UIButton ) {
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            sectionItems.count - 1 >= indexPath.section,
            sectionItems[indexPath.section].items.count - 1 >= indexPath.row else { return }
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailTaskViewController {
            vc.selectedTask = sectionItems[indexPath.section].items[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Constants
fileprivate enum Constants {
    static let entity = "Task"
    static let sortDate = "date"
    static let cellName = "TaskTableViewCell"
    static let headerName = "TaskDateHeader"
}
