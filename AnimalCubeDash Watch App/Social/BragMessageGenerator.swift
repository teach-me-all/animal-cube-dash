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
                "Zero deaths! You nailed Level \(level)!",
                "Untouchable! Level \(level) never stood a chance!",
                "Immaculate. Level \(level) cleared without a single oopsie! 😤",
                "FLAWLESS VICTORY on Level \(level)! I am built different.",
                "Level \(level) tried its best. It was not enough. 💅",
                "Zero deaths on Level \(level)? Yeah I do this in my sleep. 😴"
            ]
            return perfectMessages.randomElement()!
        }

        // Fast completion
        if time < 30.0 {
            let speedMessages = [
                "Speed demon! Level \(level) in \(formattedTime)!",
                "Blazing fast! \(formattedTime) on Level \(level)!",
                "Did I just speedrun Level \(level)? \(formattedTime)? That's gotta be a record! 🚀",
                "Blink and you'd miss it! Level \(level) done in \(formattedTime)! ⚡",
                "\(formattedTime)?! I wasn't even trying on Level \(level)! 😏"
            ]
            return speedMessages.randomElement()!
        }

        // Survived with few lives
        if livesRemaining == 1 {
            let clutchMessages = [
                "Clutch! Survived Level \(level) with 1 life left!",
                "Close call! Level \(level) beaten by a whisker!",
                "1 life, 0 chill. Level \(level) was INTENSE! 😰",
                "They said I couldn't do it with 1 life... they were wrong. 😎",
                "Last life, no problem. Level \(level) is done! 🫀"
            ]
            return clutchMessages.randomElement()!
        }

        // Standard completion
        let standardMessages = [
            "Level \(level) cleared in \(formattedTime)!",
            "Level \(level) conquered! Well played!",
            "Nice work! Level \(level) is done!",
            "Level \(level) complete! Onward!",
            "Level \(level) has been DEFEATED. Next victim please! 😤",
            "Ate Level \(level) up and left no crumbs! 🍽️",
            "Level \(level)? More like Level EASY! 😂",
            "Another one bites the dust! Level \(level) cleared! 🎶",
            "Level \(level) saw me coming and still couldn't stop me! 💪",
            "That's \(level) levels down. How many can YOU beat? 🤔"
        ]
        return standardMessages.randomElement()!
    }

    private static let appStoreLink = "https://apps.apple.com/us/app/animal-cube-dash/id6759482553"

    static func shareMessage(level: Int, livesRemaining: Int, deaths: Int) -> String {
        let base: String
        if deaths == 0 {
            let perfectShareMessages = [
                "I just CRUSHED Level \(level) in Animal Cube Dash with ZERO deaths! Think you can beat that? 🏆🔥",
                "FLAWLESS on Level \(level) in Animal Cube Dash! Zero deaths. Pure skill. Can you even? 😤💎",
                "Level \(level) in Animal Cube Dash: ZERO deaths. I am literally unbeatable right now. 👑🔥",
                "Not to brag but... I just cleared Level \(level) in Animal Cube Dash without dying ONCE. Yeah. 😎✨"
            ]
            base = perfectShareMessages.randomElement()!
        } else if livesRemaining == 1 {
            let clutchShareMessages = [
                "Just barely survived Level \(level) in Animal Cube Dash with 1 life left! That was intense! 😅⭐",
                "1 life. Level \(level). Animal Cube Dash. WE SURVIVED. 😤❤️",
                "Came THIS close to losing on Level \(level) in Animal Cube Dash! Heart still pounding! 💀➡️😅"
            ]
            base = clutchShareMessages.randomElement()!
        } else {
            let standardShareMessages = [
                "I just beat Level \(level) in Animal Cube Dash! Can you make it this far? 🎉💪",
                "Level \(level) DOWN in Animal Cube Dash! The animal cube life chose me! 🐾🎮",
                "Another level cleared in Animal Cube Dash! Level \(level) couldn't stop me. Can you do better? 😏🏅",
                "Just conquered Level \(level) in Animal Cube Dash! Your turn — bet you can't! 🎯🔥"
            ]
            base = standardShareMessages.randomElement()!
        }
        return "\(base)\n\nDownload Animal Cube Dash 👇\n\(appStoreLink)"
    }

    static func skinBragMessage(skin: AnimalSkin) -> String {
        let rarityName = skin.rarity.displayName
        let skinName = skin.displayName

        let base: String
        switch skin.rarity {
        case .legendary:
            let messages = [
                "BOW DOWN! I just unlocked the LEGENDARY \(skinName) skin! Only the best of the best earn this!",
                "LEGENDARY \(skinName) is MINE! 5 perfect levels in a row, no big deal!",
                "You wish you had my LEGENDARY \(skinName) skin! I'm basically a gaming god!",
                "Just casually unlocked the LEGENDARY \(skinName)... while you're still on Common skins!",
                "LEGENDARY status achieved! \(skinName) cube reporting for duty! Can YOU do that? Didn't think so!",
                "LEGENDARY \(skinName) UNLOCKED! 👑 I am the main character and this is proof!",
                "They said it was impossible. They were WRONG. LEGENDARY \(skinName) GET! 🏆✨",
                "5 perfect levels. 0 deaths. LEGENDARY \(skinName) is officially MINE. Bow to the champion! 💎👑",
                "LEGENDARY \(skinName) secured! I didn't come to play... actually I did, and I WON! 😤🔥"
            ]
            base = messages.randomElement()!
        case .epic:
            let messages = [
                "EPIC \(skinName) skin unlocked! Yeah, I'm THAT good!",
                "Just got the \(rarityName) \(skinName)! Try not to be too jealous!",
                "My \(skinName) cube is EPIC and so am I! Come catch me if you can!",
                "Another EPIC unlock! \(skinName) cube looking FIRE right now!",
                "EPIC \(skinName) acquired! Honestly, what CAN'T I do? 🤩🎮",
                "The \(skinName) cube is EPIC... just like its owner! 💪🔥",
                "Unlocked the EPIC \(skinName)! My watch game is seriously on another level! ⌚✨"
            ]
            base = messages.randomElement()!
        case .ultraRare:
            let messages = [
                "ULTRA RARE \(skinName) unlocked! Not everyone can do this!",
                "Got the \(rarityName) \(skinName) skin! Pretty rare, just like my skills!",
                "Flexing my ULTRA RARE \(skinName)! Bet you don't have this one!",
                "ULTRA RARE \(skinName) is officially in my collection! Most people never see this. 👀💎",
                "The \(skinName) cube is ULTRA RARE and so are my skills! Catch up! 😏🌟",
                "Found an ULTRA RARE \(skinName)! I'm starting to think I might be the best? 🤔✨"
            ]
            base = messages.randomElement()!
        case .rare:
            let messages = [
                "Just unlocked the Rare \(skinName) skin! Getting better every day!",
                "New skin alert! \(skinName) cube is looking fresh!",
                "Rare \(skinName) acquired! My collection is growing!",
                "Rare \(skinName) UNLOCKED! The grind is absolutely paying off! 🎯💪",
                "Collecting Rare skins like it's nothing! \(skinName) cube is so cute! 🐾😍",
                "Added \(skinName) to my Rare collection! Who else has this one? 🙋"
            ]
            base = messages.randomElement()!
        case .common:
            let messages = [
                "Unlocked the \(skinName) skin! Gotta collect 'em all!",
                "New \(skinName) cube! Looking cute out here!",
                "\(skinName) skin unlocked! The grind is real!",
                "Started from \(skinName), now we're here! My collection grows! 🚀",
                "\(skinName) cube join the team! Every skin counts! 🐾💖",
                "Fresh \(skinName) skin acquired! Building my animal army! 🦁🐸🐱"
            ]
            base = messages.randomElement()!
        }
        return "\(base)\n\nPlay Animal Cube Dash 👇\n\(appStoreLink)"
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
            "That was a tough one. Ready for another shot?",
            "The cube believes in you! Go! 🐾",
            "That level is NOT the boss of you! Try again! 😤",
            "Okay THAT level is trolling you. Get revenge! 😠",
            "One more try. This time it's personal! 💢",
            "You didn't come this far to only come this far! 🔥",
            "The animals are rooting for you! Back in! 🐱🐶🐸",
            "That level has HANDS. Show it yours! 👊",
            "Respawn. Retry. Revenge. That's the formula! ⚔️",
            "If at first you don't succeed... destroy the level on attempt 2! 💥",
            "Your future self is already celebrating this clear. Go get it! 🏆"
        ]
        return messages.randomElement()!
    }
}
