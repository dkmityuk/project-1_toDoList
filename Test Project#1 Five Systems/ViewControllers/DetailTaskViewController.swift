import UIKit

class DetailTaskViewController: UIViewController {

    @IBOutlet weak var desriptionLabel: UILabel!
    
    var selectedTask: TaskModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedTask.text
        desriptionLabel.text = selectedTask.description
    }
    

    @IBAction func shareTask() {
        let shareController = UIActivityViewController(activityItems: [selectedTask.description], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                print("succsesfool")
            }
            
        }

        present(shareController, animated: true, completion: nil)
    }

}
