import Foundation

struct UserModel {
    let name: String
    let email: String
}

extension UserModel {
    init?(managedObject: User) {
        guard
            let name = managedObject.name,
            let email = managedObject.email
        else { return nil }
        self.name = name
        self.email = email
    }
    
    func fill(to managedObject: User) {
        managedObject.name = name
        managedObject.email = email
    }
}
