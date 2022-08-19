import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eMailLabel: UILabel!
 
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
 
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    private func updateNextButtonState(){
        let nameText = nameTextField.text ?? ""
        let eMailText = eMailTextField.text ?? ""
        nextButton.isEnabled = !nameText.isEmpty && !eMailText.isEmpty
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateNextButtonState()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let user = UserModel(name: nameTextField.text ?? "", email: eMailTextField.text ?? "", isCurrent: true, tasks: [])
        do {
            try CoreDataManager.shared.save(user: user)
            print(user)
        } catch let error  {
            print(error)
            print(error.localizedDescription)
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
