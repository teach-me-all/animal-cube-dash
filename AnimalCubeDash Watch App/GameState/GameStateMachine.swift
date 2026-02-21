import Foundation

enum GameStateType: Equatable {
    case playing, paused, respawn, levelComplete, gameOver
}

protocol GameStateDelegate: AnyObject {
    func stateDidChange(to state: GameStateType)
    func requestRespawn()
    func requestLevelComplete()
    func requestGameOver()
    func requestRestart()
}

final class GameStateMachine {
    weak var stateDelegate: GameStateDelegate?
    private(set) var currentStateType: GameStateType = .playing

    init(scene: GameStateDelegate) {
        self.stateDelegate = scene
    }

    func enter(_ state: GameStateType) {
        let valid: Bool
        switch (currentStateType, state) {
        case (.playing, .paused),
             (.playing, .respawn),
             (.playing, .levelComplete),
             (.playing, .gameOver),
             (.paused, .playing),
             (.respawn, .playing),
             (.respawn, .gameOver),
             (.levelComplete, .playing),
             (.gameOver, .playing):
            valid = true
        default:
            valid = false
        }

        guard valid else { return }
        currentStateType = state
        stateDelegate?.stateDidChange(to: state)

        switch state {
        case .respawn:
            stateDelegate?.requestRespawn()
        case .levelComplete:
            stateDelegate?.requestLevelComplete()
        case .gameOver:
            stateDelegate?.requestGameOver()
        default:
            break
        }
    }
}
