import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var timeField: UITextField!
    let timePicker = UIDatePicker()
    @IBOutlet weak var saveButton: UIButton!
    
    var refreshData: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        setTimePicker()
    }
    
    private func updatesaveButtonState() {
        let titleText = titleTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        let dateText = dateField.text ?? ""
        
        saveButton.isEnabled = !dateText.isEmpty && !titleText.isEmpty && !descriptionText.isEmpty
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
    
    func setDatePicker(){
        dateField.text = DateFormatter.userFriendlyDateFormatter.string(from: Date())
        dateField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDateAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.sizeToFit()
        toolbar.setItems([flexSpace,doneButton], animated: true)
        
        dateField.inputAccessoryView = toolbar
    }
    
    @objc func doneDateAction() {
        getDateFromPicker()
        view.endEditing(true)
    }
    
    func getDateFromPicker() {
        dateField.text = DateFormatter.userFriendlyDateFormatter.string(from: datePicker.date)
    }
    
    func setTimePicker() {
        timeField.text = " -- : -- "
        timeField.inputView = timePicker
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTimeAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.sizeToFit()
        toolbar.setItems([flexSpace,doneButton], animated: true)
        
        timeField.inputAccessoryView = toolbar
    }
    
    @objc func doneTimeAction() {
        getTimeFromPicker()
        view.endEditing(true)
    }
    
    func getTimeFromPicker() {
        timeField.text = DateFormatter.userFriendlyTimeFormatter.string(from: timePicker.date)
    }
    
}
