import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
