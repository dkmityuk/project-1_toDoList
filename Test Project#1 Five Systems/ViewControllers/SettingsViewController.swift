import UIKit

final class SettingsViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    let user: UserModel? = CoreDataManager.shared.fetchCurrentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    private func setupLabels() {
        userNameLabel.text = user?.name
        userEmailLabel.text = user?.email
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
