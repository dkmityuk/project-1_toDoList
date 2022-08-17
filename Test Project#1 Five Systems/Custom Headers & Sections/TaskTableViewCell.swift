import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
  
    @IBOutlet weak var isDoneButton: UIButton!
    
    var taskStatusChangedHandler: ((Bool) -> Void)?
    private var isDone = false {
        willSet {
            if newValue {
                isDoneButton.setImage(UIImage(named: "isDoneTrue"), for: .normal)
            } else {
                isDoneButton.setImage(UIImage(named: "isDoneFalse"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setUp(object: TaskModel) {
        taskDescriptionLabel.text = object.description
        taskNameLabel.text = object.text
        if let image = object.taskImage {
            taskImageView.image = UIImage(data: image)
        }
        isDone = object.isDone
    }
    
    private func setupUI() {
        taskImageView.layer.cornerRadius = 10
    }

    @IBAction func isDoneButtonPressed(_ sender: UIButton) {
        isDone.toggle()
        taskStatusChangedHandler?(isDone)
    }
}
