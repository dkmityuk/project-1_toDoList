import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(object: Task) {
        self.taskDescriptionLabel.text = object.descr
        self.taskNameLabel.text = object.title
    }
}
