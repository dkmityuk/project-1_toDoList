import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    // I will add textField and put datePicker into it
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
  var refreshData: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updatesaveButtonState() {
        let titleText = titleTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        
        saveButton.isEnabled = !titleText.isEmpty && !descriptionText.isEmpty
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updatesaveButtonState()
    }
    
    @IBAction func saveTaskButtonPressed(_ sender: UIButton) {
      let taks = TaskModel(
        text: titleTextField.text ?? "",
        description: descriptionTextField.text ?? "",
        date: datePicker.date,
        isDone: false
      )
      do {
        try CoreDataManager.shared.save(task: taks)
        refreshData?()
        dismiss(animated: true)
      } catch let error  {
        print(error)
        print(error.localizedDescription)
      }
    }
}
