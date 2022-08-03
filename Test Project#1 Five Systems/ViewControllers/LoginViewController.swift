import UIKit

class LoginViewController: UIViewController {

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
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
      
        self.navigationController?.pushViewController(controller, animated: true)
//        self.present(controller, animated: false, completion: nil)
    }
    
}
