import Foundation

struct PhysicsCategory {
    static let none:       UInt32 = 0
    static let player:     UInt32 = 0b1        // 1
    static let platform:   UInt32 = 0b10       // 2
    static let spike:      UInt32 = 0b100      // 4
    static let quicksand:  UInt32 = 0b1000     // 8
    static let knife:      UInt32 = 0b10000    // 16
    static let treasure:   UInt32 = 0b100000   // 32
    static let boundary:   UInt32 = 0b1000000  // 64

    static let hazards: UInt32 = spike | knife | quicksand
    static let all: UInt32 = UInt32.max
}
