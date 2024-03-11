//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import Foundation
import UIKit

struct User {
    let id: String
    let name: String
    let bio: String?
    let avatar: String?
}


class AuthService {

    var currentUser: User?

    func registerUser(name: String, password: String, avatar: UIImage?, bio: String?, completion: @escaping(Error?)->Void) {
        let urlSession = URLSession.shared
        let userId = UUID().uuidString

        if let avatar {
            let url = URL(string: "http://api-host-name/v1/api/uploadfile/single")

            // generate boundary string using a unique per-app string
            let boundary = UUID().uuidString

            // Set the URLRequest to POST and to the specified URL
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"

            // Set Content-Type Header to multipart/form-data, 
            // this is equivalent to submitting form data with file upload in a web browser
            // And the boundary is also set here
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var data = Data()

            // Add the image data to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; filename=\"avatar/\(userId)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(avatar.pngData()!)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            // Send a POST request to the URL, with the data we created earlier
            urlSession.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                guard error == nil,
                      let responseData,
                        let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments),
                        let json = jsonData as? [String: Any] else {
                    completion(error ?? NSError(domain: "Service", code: 1))
                    return
                }
                let avatarUrl = json["avatar"] as? String
                let url = URL(string: "https://some-user-service/1/")!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                var params: [String: Any] = ["name": name,
                                             "password": password,
                                             "id": userId]
                params["avatar"] = avatarUrl
                params["bio"] = bio
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params)
                urlSession.dataTask(with: urlRequest) { [weak self] userIdData, _, error in
                    guard let userIdData, let userId = String(data: userIdData, encoding: .utf8), error == nil else {
                        completion(error)
                        return
                    }
                    self?.currentUser = User(id: userId, name: name, bio: bio, avatar: avatarUrl)
                    completion(nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "user_registered"), object: nil, userInfo: ["user": self!.currentUser!])
                }
            }).resume()

        } else {
            let url = URL(string: "https://some-user-service/1/")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            var params: [String: Any] = ["name": name,
                                         "password": password,
                                         "id": userId]
            params["bio"] = bio
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params)
            urlSession.dataTask(with: urlRequest) { [weak self] userIdData, _, error in
                guard let userIdData, let userId = String(data: userIdData, encoding: .utf8), error == nil else {
                    completion(error)
                    return
                }
                self?.currentUser = User(id: userId, name: name, bio: bio, avatar: nil)
                completion(nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "user_registered"), object: nil, userInfo: ["user": self!.currentUser!])
                completion(nil)
            }
        }

    }


}
