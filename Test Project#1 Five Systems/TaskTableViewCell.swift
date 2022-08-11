import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
  
    @IBOutlet weak var isDoneButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(object: TaskModel) {
        self.taskDescriptionLabel.text = object.description
        self.taskNameLabel.text = object.text
        guard let image = object.taskImage else { return }
        self.taskImageView.image = UIImage(data: image)
        taskImageView.layer.cornerRadius = taskImageView.bounds.height / 4
    }
}
