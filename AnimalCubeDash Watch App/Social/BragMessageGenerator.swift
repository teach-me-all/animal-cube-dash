import Foundation

struct BragMessageGenerator {

    static func homeBannerMessage(store: GameProgressStore) -> String {
        var messages: [String] = []

        // Level-based messages
        if store.highestLevel >= 50 {
            messages.append("Legend status! Level \(store.highestLevel) reached!")
        } else if store.highestLevel >= 20 {
            messages.append("Level \(store.highestLevel) and climbing!")
        } else if store.highestLevel > 1 {
            messages.append("by Ahaana Sistla!")
        }

        // Skin unlock messages
        if store.unlockedSkins.count == AnimalSkin.allCases.count {
            messages.append("All skins unlocked! True champion!")
        } else if store.unlockedSkins.count > 1 {
            let latest = store.unlockedSkins.last ?? .cat
            messages.append("\(latest.displayName) Cube unlocked!")
        }

        // Stats-based messages
        if store.totalLevelsCompleted >= 100 {
            messages.append("\(store.totalLevelsCompleted) levels completed! Unstoppable!")
        } else if store.totalLevelsCompleted >= 10 {
            messages.append("\(store.totalLevelsCompleted) levels down!")
        }

        // Fallback
        if messages.isEmpty {
            messages.append("by Ahaana Sistla!")
        }

        return messages.randomElement() ?? "by Ahaana Sistla!"
    }

    static func postLevelMessage(level: Int, livesRemaining: Int, time: TimeInterval, deaths:
                                 Int) -> String {
        let formattedTime = String(format: "%.1fs", time)

        // Perfect run - no deaths
        if deaths == 0 && livesRemaining == Constants.maxLives {
            let perfectMessages = [
                "Perfect run! Flawless on Level \(level)!",
                "Not a scratch! Level \(level) cleared!",
                "Zero deaths! You nailed Level \(level)!"
            ]
            return perfectMessages.randomElement()!
        }

        // Fast completion
        if time < 30.0 {
            let speedMessages = [
                "Speed demon! Level \(level) in \(formattedTime)!",
                "Blazing fast! \(formattedTime) on Level \(level)!"
            ]
            return speedMessages.randomElement()!
        }

        // Survived with few lives
        if livesRemaining == 1 {
            let clutchMessages = [
                "Clutch! Survived Level \(level) with 1 life left!",
                "Close call! Level \(level) beaten by a whisker!"
            ]
            return clutchMessages.randomElement()!
        }

        // Standard completion
        let standardMessages = [
            "Level \(level) cleared in \(formattedTime)!",
            "Level \(level) conquered! Well played!",
            "Nice work! Level \(level) is done!",
            "Level \(level) complete! Onward!"
        ]
        return standardMessages.randomElement()!
    }

    static func shareMessage(level: Int, livesRemaining: Int, deaths: Int) -> String {
        if deaths == 0 {
            return "I just CRUSHED Level \(level) in Animal Cube Dash with ZERO deaths! Think you can beat that? 🏆🔥"
        } else if livesRemaining == 1 {
            return "Just barely survived Level \(level) in Animal Cube Dash with 1 life left! That was intense! 😅⭐"
        } else {
            return "I just beat Level \(level) in Animal Cube Dash! Can you make it this far? 🎉💪"
        }
    }

    static func skinBragMessage(skin: AnimalSkin) -> String {
        let rarityName = skin.rarity.displayName
        let skinName = skin.displayName

        switch skin.rarity {
        case .legendary:
            let messages = [
                "BOW DOWN! I just unlocked the LEGENDARY \(skinName) skin! Only the best of the best earn this!",
                "LEGENDARY \(skinName) is MINE! 5 perfect levels in a row, no big deal!",
                "You wish you had my LEGENDARY \(skinName) skin! I'm basically a gaming god!",
                "Just casually unlocked the LEGENDARY \(skinName)... while you're still on Common skins!",
                "LEGENDARY status achieved! \(skinName) cube reporting for duty! Can YOU do that? Didn't think so!"
            ]
            return messages.randomElement()!
        case .epic:
            let messages = [
                "EPIC \(skinName) skin unlocked! Yeah, I'm THAT good!",
                "Just got the \(rarityName) \(skinName)! Try not to be too jealous!",
                "My \(skinName) cube is EPIC and so am I! Come catch me if you can!",
                "Another EPIC unlock! \(skinName) cube looking FIRE right now!"
            ]
            return messages.randomElement()!
        case .ultraRare:
            let messages = [
                "ULTRA RARE \(skinName) unlocked! Not everyone can do this!",
                "Got the \(rarityName) \(skinName) skin! Pretty rare, just like my skills!",
                "Flexing my ULTRA RARE \(skinName)! Bet you don't have this one!"
            ]
            return messages.randomElement()!
        case .rare:
            let messages = [
                "Just unlocked the Rare \(skinName) skin! Getting better every day!",
                "New skin alert! \(skinName) cube is looking fresh!",
                "Rare \(skinName) acquired! My collection is growing!"
            ]
            return messages.randomElement()!
        case .common:
            let messages = [
                "Unlocked the \(skinName) skin! Gotta collect 'em all!",
                "New \(skinName) cube! Looking cute out here!",
                "\(skinName) skin unlocked! The grind is real!"
            ]
            return messages.randomElement()!
        }
    }

    static func encouragingMessage() -> String {
        let messages = [
            "You got this!",
            "Try again, champ!",
            "Almost had it! One more go!",
            "Every great player stumbles. Get back in there!",
            "Practice makes perfect! Go again!",
            "So close! You can do it!",
            "Shake it off and try again!",
            "Keep at it! Victory is near!",
            "Don't give up! You're getting better!",
            "That was a tough one. Ready for another shot?"
        ]
        return messages.randomElement()!
    }
}
