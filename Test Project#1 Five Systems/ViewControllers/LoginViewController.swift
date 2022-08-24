import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eMailLabel: UILabel!
    @IBOutlet weak var emailError: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
 
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
    }
    
    private func resetForm() {
        emailError.isHidden = false
        nextButton.isEnabled = false
    }
        
       private func invalidEmail(_ value: String) -> String?
        {
            let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            if !predicate.evaluate(with: value)
            {
                return "e-mail is not valid."
            }
            
            return nil
        }
    
    private func checkForValidForm()
        {
            if emailError.isHidden
            {
                nextButton.isEnabled = true
            }
            else
            {
                nextButton.isEnabled = false
            }
        }
    
    private func updateNextButtonState(){
        let nameText = nameTextField.text ?? ""
        let eMailText = eMailTextField.text ?? ""
        nextButton.isEnabled = !nameText.isEmpty && !eMailText.isEmpty
    }
    
    @IBAction func emailChanged(_ sender: Any)
        {
            if let email = eMailTextField.text
            {
                if let errorMessage = invalidEmail(email)
                {
                    emailError.text = errorMessage
                    emailError.isHidden = false
                }
                else
                {
                    emailError.isHidden = true
                }
            }
            
            checkForValidForm()
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
