import UIKit
import CoreData
import PhotosUI

final class NewTaskViewController: UIViewController {
     // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var taskImage: UIImageView!
    
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    var refreshDataHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupTimePicker()
//        taskImage.image = UIImage(named: "defaultTaskImage")
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
        let task = TaskModel(
            text: titleTextField.text ?? "",
            description: descriptionTextField.text ?? "",
            date: dateField.text ?? "",
            isDone: false,
            taskImage: taskImage.image?.pngData()
        )
        do {
            try CoreDataManager.shared.save(task: task)
            refreshDataHandler?()
            dismiss(animated: true)
        } catch let error  {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    private func setupDatePicker() {
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
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }
}

 // MARK: - PHPickerViewControllerDelegate
extension NewTaskViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for item in results {
            if item.itemProvider.canLoadObject(ofClass: UIImage.self) {
                item.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.taskImage.image = image
                        }
                    }
                }
            }
        }
    }
}
