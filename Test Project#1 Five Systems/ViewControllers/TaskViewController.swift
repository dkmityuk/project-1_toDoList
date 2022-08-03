import UIKit
import CoreData

// MARK: - DateFormatters
// Move to sepparate file
// I will edit datePicker(It will be dateField) after that I move this part of code into NewTaskViewController
extension DateFormatter {
    static var userFriendlyFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY "
        return dateFormatter
    }()
}

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
        var datesArray = [Date]()
        var sections = [SectionModel]()
        
        for task in tasks {
            if !datesArray.contains(task.date) {
                datesArray.append(task.date)
            }
        }
        
        for date in datesArray {
            sections.append(
                SectionModel(
                    title: DateFormatter.userFriendlyFormatter.string(from: date),
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
        controller.refreshData = { [weak self] in
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
        cell.taskNameLabel.text? = sectionItems[indexPath.section].items[indexPath.row].text
        cell.taskDescriptionLabel.text? = sectionItems[indexPath.section].items[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sectionItems.count - 1 >= section else { return nil }
        return sectionItems[section].title
    }
}

// MARK: - Constants
fileprivate enum Constants {
    static let entity = "Task"
    static let sortDate = "date"
    static let sellName = "taskCell"
}
