import Foundation


enum DeeplinkType {
    case home
    case profile
}

protocol Deeplink {
    var type: DeeplinkType { get }
}

class HomeDeeplink: Deeplink {
    let type: DeeplinkType = .home

    func executeHome() {
        // Presents the main screen
    }
}

class ProfileDeeplink: Deeplink {
    let type: DeeplinkType = .profile

    func executeProfile() {
        // Presents the profile screen
    }
}

class Router {
    func execute(_ deeplink: Deeplink) {
        switch deeplink.type {
        case .home:
            (deeplink as? HomeDeeplink)?.executeHome()
        case .profile:
            (deeplink as? ProfileDeeplink)?.executeProfile()
        }
    }
}
