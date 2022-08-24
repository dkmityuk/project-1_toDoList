import UIKit

final class DetailTaskViewController: UIViewController {

    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var desriptionLabel: UILabel!
    
    var selectedTask: TaskModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedTask?.text
        desriptionLabel.text = selectedTask?.description
        guard let image = selectedTask?.taskImage else { return }
        taskImageView.image = UIImage(data: image)
    }
    
    @IBAction func shareTask() {
        let shareController = UIActivityViewController(activityItems: [selectedTask?.taskImage ?? "", selectedTask?.text ?? "", selectedTask?.description ?? ""], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                print("succsesfool")
            }
        }
        present(shareController, animated: true, completion: nil)
    }
}
