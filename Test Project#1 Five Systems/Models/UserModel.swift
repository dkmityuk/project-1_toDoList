import Foundation

struct UserModel {
    let name: String
    let email: String
}

extension UserModel {
    init?(UserMO: User) {
        guard
            let name = UserMO.name,
            let email = UserMO.email
        else { return nil }
        self.name = name
        self.email = email
    }
    
    func fill(to UserMO: User) {
        UserMO.name = name
        UserMO.email = email
    }
}
