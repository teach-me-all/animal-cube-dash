import UIKit

// iOS delivery stub — Animal Cube Dash is a watch-only app.
// This target exists solely as the App Store distribution container.
// Displays a simple companion screen so the app does not launch to a black screen.

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = WatchCompanionViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

// MARK: - Companion Screen

final class WatchCompanionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1) // sky blue

        // Watch icon
        let watchLabel = UILabel()
        watchLabel.text = "⌚️"
        watchLabel.font = .systemFont(ofSize: 80)
        watchLabel.textAlignment = .center
        watchLabel.translatesAutoresizingMaskIntoConstraints = false

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Animal Cube Dash"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "This app is designed for Apple Watch.\nOpen it on your Apple Watch to play!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [watchLabel, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
        ])
    }
}

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(AppDelegate.self)
)
