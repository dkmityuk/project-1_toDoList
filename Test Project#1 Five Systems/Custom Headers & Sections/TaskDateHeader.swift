import UIKit

class TaskDateHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var showTasksButton: UIButton!
    
    var sectionStatusChangedHandler: ((Bool) -> Void)?
        private var isOpen = true {
            willSet {
                if newValue {
                    showTasksButton.setImage(UIImage(named: "headerIsClose"), for: .normal)
                } else {
                    showTasksButton.setImage(UIImage(named: "headerIsOpen"), for: .normal)
                }
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUp(object: SectionModel) {
        dateLabel.text = object.title
        showTasksButton.setImage(UIImage(named: "headerIsOpen"), for: .normal)
        isOpen = object.isOpen
    }
    @IBAction func showTasksButtonPressed(_ sender: UIButton) {
        isOpen.toggle()
        sectionStatusChangedHandler?(isOpen)
    }

}
