import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    private let datePicker = UIDatePicker()
    
    @IBOutlet weak var timeField: UITextField!
    private let timePicker = UIDatePicker()
    @IBOutlet weak var saveButton: UIButton!
    
    var refreshDataHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupTimePicker()
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
            refreshDataHandler?()
            dismiss(animated: true)
        } catch let error  {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    private func setupDatePicker(){
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
    
    private func getDateFromPicker() {
        dateField.text = DateFormatter.userFriendlyDateFormatter.string(from: datePicker.date)
    }
    
    private func setupTimePicker() {
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
    
    private func getTimeFromPicker() {
        timeField.text = DateFormatter.userFriendlyTimeFormatter.string(from: timePicker.date)
    }
    
}
