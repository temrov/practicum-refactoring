//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import Foundation
import UIKit
import Combine

struct User {
    let id: String
    let name: String
    let bio: String?
    let avatar: String?
}

protocol UserProvider {
    func updateUser(id: String, name: String, password: String, avatarUrl: String?, bio: String?, competion: @escaping (User?, Error?)->Void)
}

protocol ImageUploader {
    func uploadImage(fileName: String, image: UIImage, completion: @escaping ([String: Any]?, Error?)->Void)
}



struct UserRegistrationInfo {
    let name
    let password
    //...

}

class AuthService {

    init(userProvider: UserProvider, imageUploader: ImageUploader) {
        self.userProvider = userProvider
        self.imageUploader = imageUploader
    }

    let userProvider: UserProvider
    let imageUploader: ImageUploader
    private var currentUser: CurrentValueSubject<User?, Never>(nil)

    var currentUserPublisher: AnyPublisher<User?, Never> {
        currentUser.eraseToAnyPublisher()
    }

    func registerUser(name: String, password: String, avatar: UIImage?, bio: String?, completion: @escaping(Error?)->Void) {
        let userId = UUID().uuidString

        let updateUser: (String?)->Void  = { [weak self] avatar in
            self?.userProvider.updateUser(id: userId, name: name, password: password, avatarUrl: avatar, bio: buio, competion: { user, error in
                guard let user else {
                    completion(error ?? NSError())
                    return
                }
                self?.currentUser.send(user)
                completion(nil)

            })
        }

        if let avatar {
            uploadImage(fileName: "avatar/\(userId)\"", image: avatar) { jsonData, error in
                guard error == nil,
                        let json = jsonData as? [String: Any] else {
                    completion(error ?? NSError(domain: "Service", code: 1))
                    return
                }
                let avatarUrl = json["avatar"] as? String
                updateUser(avatar)
            }
        } else {
            updateUser(nil)
        }

    }

    private func uploadImage(fileName: String, image: UIImage, completion: @escaping ([String: Any]?, Error?)->Void) {
        imageUploader.uploadImage(fileName: fileName, image: image, completion: completion)
    }


}

fileprivate extension String {
    static let avatarUrl = "http://api-host-name/v1/api/uploadfile/single"
    static let registrationUrl = "https://some-user-service/1/"
}

let authService = AuthService(userProvider: <#T##UserProvider#>, imageUploader: <#T##ImageUploader#>)

authService.currentUserPublisher.sink { _ in

} receiveValue: { newValue in
    // операции с зарегестрированным пользователем
}

