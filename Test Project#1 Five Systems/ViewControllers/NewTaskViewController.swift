import UIKit
import CoreData
import PhotosUI
import UserNotifications

final class NewTaskViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    var refreshDataHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupTimePicker()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updatesaveButtonState()
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        showAlertactionSheet()
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
    
    private func updatesaveButtonState() {
        let titleText = titleTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        let dateText = dateField.text ?? ""
        saveButton.isEnabled = !dateText.isEmpty && !titleText.isEmpty && !descriptionText.isEmpty
    }
    
     // MARK: - SetupDate&TimePickers
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
    
    private func showAlertactionSheet() {
        let alert = UIAlertController(title: "Add photo", message: "Choose course", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
        self.showPicker(source: .camera)
        } 
        let library = UIAlertAction(title: "Library", style: .default) { _ in
        self.showPicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func showPicker(source: UIImagePickerController.SourceType) {
                let picker = UIImagePickerController()
                picker.sourceType = source
                picker.allowsEditing = true
                picker.delegate = self
                present(picker, animated: true, completion: nil)
    }
}

// MARK: - ImageickerViewDelegate
extension NewTaskViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage = UIImage()
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = image
        }
        taskImage.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
    }
}
