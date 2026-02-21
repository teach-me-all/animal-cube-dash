import SpriteKit

enum SkinRarity: String, CaseIterable {
    case common
    case rare
    case ultraRare
    case epic
    case legendary

    var displayName: String {
        switch self {
        case .common: return "Common"
        case .rare: return "Rare"
        case .ultraRare: return "Ultra Rare"
        case .epic: return "Epic"
        case .legendary: return "Legendary"
        }
    }

    var color: SKColor {
        switch self {
        case .common: return SKColor(hex: 0xA0A0A0)
        case .rare: return SKColor(hex: 0x3498DB)
        case .ultraRare: return SKColor(hex: 0x9B59B6)
        case .epic: return SKColor(hex: 0xF1C40F)
        case .legendary: return SKColor(hex: 0xFF1493)
        }
    }
}

enum AnimalSkin: String, CaseIterable, Codable {
    // Common
    case cat
    case dog
    case bunny
    case frog
    case chick
    case hamster
    case duck

    // Rare
    case panda
    case fox
    case owl
    case penguin
    case koala
    case raccoon
    case deer

    // Ultra Rare
    case tiger
    case wolf
    case lion
    case dolphin
    case redPanda
    case chameleon

    // Epic
    case dragon
    case phoenix
    case unicorn
    case shark
    case goldenTiger
    case arcticFox
    case snowyOwl

    // Legendary (Sanrio)
    case helloKitty
    case myMelody
    case cinnamoroll
    case kuromi
    case pompompurin
    case keroppi
    case pochacco
    case badtzMaru
    case tuxedoSam
    case littleTwinStars
    case blueTwinStar

    var displayName: String {
        switch self {
        case .cat: return "Cat"
        case .dog: return "Dog"
        case .bunny: return "Bunny"
        case .frog: return "Frog"
        case .chick: return "Chick"
        case .hamster: return "Hamster"
        case .duck: return "Duck"
        case .panda: return "Panda"
        case .fox: return "Fox"
        case .owl: return "Owl"
        case .penguin: return "Penguin"
        case .koala: return "Koala"
        case .raccoon: return "Raccoon"
        case .deer: return "Deer"
        case .tiger: return "Tiger"
        case .wolf: return "Wolf"
        case .lion: return "Lion"
        case .dolphin: return "Dolphin"
        case .redPanda: return "Red Panda"
        case .chameleon: return "Chameleon"
        case .dragon: return "Dragon"
        case .phoenix: return "Phoenix"
        case .unicorn: return "Unicorn"
        case .shark: return "Shark"
        case .goldenTiger: return "Gold Tiger"
        case .arcticFox: return "Arctic Fox"
        case .snowyOwl: return "Snowy Owl"
        case .helloKitty: return "Hello Kitty"
        case .myMelody: return "My Melody"
        case .cinnamoroll: return "Cinnamoroll"
        case .kuromi: return "Kuromi"
        case .pompompurin: return "Pompompurin"
        case .keroppi: return "Keroppi"
        case .pochacco: return "Pochacco"
        case .badtzMaru: return "Badtz-Maru"
        case .tuxedoSam: return "Tuxedo Sam"
        case .littleTwinStars: return "Lala"
        case .blueTwinStar: return "Kiki"
        }
    }

    var rarity: SkinRarity {
        switch self {
        case .cat, .dog, .bunny, .frog, .chick, .hamster, .duck:
            return .common
        case .panda, .fox, .owl, .penguin, .koala, .raccoon, .deer:
            return .rare
        case .tiger, .wolf, .lion, .dolphin, .redPanda, .chameleon:
            return .ultraRare
        case .dragon, .phoenix, .unicorn, .shark, .goldenTiger, .arcticFox, .snowyOwl:
            return .epic
        case .helloKitty, .myMelody, .cinnamoroll, .kuromi, .pompompurin, .keroppi,
             .pochacco, .badtzMaru, .tuxedoSam, .littleTwinStars, .blueTwinStar:
            return .legendary
        }
    }

    var bodyColor: SKColor {
        switch self {
        case .cat: return SKColor(hex: 0xFF9F43)
        case .dog: return SKColor(hex: 0xC8A87C)
        case .bunny: return SKColor(hex: 0xFABDD2)
        case .frog: return SKColor(hex: 0x2ECC71)
        case .chick: return SKColor(hex: 0xFFF176)
        case .hamster: return SKColor(hex: 0xF0C27F)
        case .duck: return SKColor(hex: 0xFFEB3B)
        case .panda: return SKColor.white
        case .fox: return SKColor(hex: 0xE8652B)
        case .owl: return SKColor(hex: 0x8B5E3C)
        case .penguin: return SKColor(hex: 0x2D3436)
        case .koala: return SKColor(hex: 0x9E9E9E)
        case .raccoon: return SKColor(hex: 0x78909C)
        case .deer: return SKColor(hex: 0xBE8C63)
        case .tiger: return SKColor(hex: 0xFFA502)
        case .wolf: return SKColor(hex: 0x636E72)
        case .lion: return SKColor(hex: 0xF5A623)
        case .dolphin: return SKColor(hex: 0x74B9FF)
        case .redPanda: return SKColor(hex: 0xD35400)
        case .chameleon: return SKColor(hex: 0x00E676)
        case .dragon: return SKColor(hex: 0x6C5CE7)
        case .phoenix: return SKColor(hex: 0xFF6B6B)
        case .unicorn: return SKColor(hex: 0xE8DAEF)
        case .shark: return SKColor(hex: 0x5D6D7E)
        case .goldenTiger: return SKColor(hex: 0xFFD700)
        case .arcticFox: return SKColor(hex: 0xE8F0FE)
        case .snowyOwl: return SKColor(hex: 0xFAFAFA)
        case .helloKitty: return SKColor.white
        case .myMelody: return SKColor(hex: 0xFFB6C1)
        case .cinnamoroll: return SKColor(hex: 0xE0F0FF)
        case .kuromi: return SKColor(hex: 0x3D3D3D)
        case .pompompurin: return SKColor(hex: 0xFFE082)
        case .keroppi: return SKColor(hex: 0x4CAF50)
        case .pochacco: return SKColor.white
        case .badtzMaru: return SKColor(hex: 0x2D2D2D)
        case .tuxedoSam: return SKColor(hex: 0x87CEEB)
        case .littleTwinStars: return SKColor(hex: 0xFFD1EC)
        case .blueTwinStar: return SKColor(hex: 0xBBDEFB)
        }
    }

    var accentColor: SKColor {
        switch self {
        case .cat: return SKColor(hex: 0xE17055)
        case .dog: return SKColor(hex: 0x8B6F47)
        case .bunny: return SKColor(hex: 0xF8A5C2)
        case .frog: return SKColor(hex: 0x1ABC9C)
        case .chick: return SKColor(hex: 0xFFB74D)
        case .hamster: return SKColor(hex: 0xD4A056)
        case .duck: return SKColor(hex: 0xFF8F00)
        case .panda: return SKColor(hex: 0x2D3436)
        case .fox: return SKColor(hex: 0xD4451A)
        case .owl: return SKColor(hex: 0xC8A87C)
        case .penguin: return SKColor(hex: 0xF5F6FA)
        case .koala: return SKColor(hex: 0x757575)
        case .raccoon: return SKColor(hex: 0x37474F)
        case .deer: return SKColor(hex: 0x8D6E43)
        case .tiger: return SKColor(hex: 0xD63031)
        case .wolf: return SKColor(hex: 0x2D3436)
        case .lion: return SKColor(hex: 0xE8962E)
        case .dolphin: return SKColor(hex: 0x0984E3)
        case .redPanda: return SKColor(hex: 0xA04000)
        case .chameleon: return SKColor(hex: 0x00C853)
        case .dragon: return SKColor(hex: 0xFD79A8)
        case .phoenix: return SKColor(hex: 0xFFC312)
        case .unicorn: return SKColor(hex: 0xA29BFE)
        case .shark: return SKColor(hex: 0x85929E)
        case .goldenTiger: return SKColor(hex: 0xFFA000)
        case .arcticFox: return SKColor(hex: 0xB0C4DE)
        case .snowyOwl: return SKColor(hex: 0xD5D8DC)
        case .helloKitty: return SKColor(hex: 0xFF4081)
        case .myMelody: return SKColor(hex: 0xFF69B4)
        case .cinnamoroll: return SKColor(hex: 0x90CAF9)
        case .kuromi: return SKColor(hex: 0xCE93D8)
        case .pompompurin: return SKColor(hex: 0xA67C52)
        case .keroppi: return SKColor(hex: 0x2E7D32)
        case .pochacco: return SKColor(hex: 0x42A5F5)
        case .badtzMaru: return SKColor(hex: 0xFFA726)
        case .tuxedoSam: return SKColor(hex: 0x1565C0)
        case .littleTwinStars: return SKColor(hex: 0xCE93D8)
        case .blueTwinStar: return SKColor(hex: 0x42A5F5)
        }
    }

    var earStyle: EarStyle {
        switch self {
        case .cat, .tiger, .fox, .goldenTiger, .arcticFox: return .pointed
        case .dog: return .floppy
        case .panda, .koala: return .round
        case .dragon: return .horn
        case .bunny: return .tall
        case .owl, .snowyOwl: return .tuft
        case .frog, .penguin, .dolphin, .shark, .chameleon: return .none
        case .chick, .duck: return .none
        case .hamster: return .round
        case .raccoon: return .pointed
        case .deer: return .antler
        case .wolf, .lion: return .pointed
        case .redPanda: return .round
        case .phoenix: return .tuft
        case .unicorn: return .horn
        case .helloKitty: return .sanrioBow
        case .myMelody: return .sanrioHood
        case .cinnamoroll: return .floppy
        case .kuromi: return .sanrioJester
        case .pompompurin: return .sanrioBeret
        case .keroppi: return .none
        case .pochacco: return .floppy
        case .badtzMaru: return .pointed
        case .tuxedoSam: return .none
        case .littleTwinStars: return .round
        case .blueTwinStar: return .round
        }
    }

    var unlockLevel: Int {
        switch self {
        // Common: Cat free, then every 10 levels
        case .cat: return 0
        case .dog: return 10
        case .bunny: return 20
        case .frog: return 30
        case .chick: return 40
        case .hamster: return 50
        case .duck: return 60
        // Rare: continue +10
        case .panda: return 70
        case .fox: return 80
        case .owl: return 90
        case .penguin: return 100
        case .koala: return 110
        case .raccoon: return 120
        case .deer: return 130
        // Ultra Rare: continue +10
        case .tiger: return 140
        case .wolf: return 150
        case .lion: return 160
        case .dolphin: return 170
        case .redPanda: return 180
        case .chameleon: return 190
        // Epic: continue +10
        case .dragon: return 200
        case .phoenix: return 210
        case .unicorn: return 220
        case .shark: return 230
        case .goldenTiger: return 240
        case .arcticFox: return 250
        case .snowyOwl: return 260
        // Legendary: continue +10
        case .helloKitty: return 270
        case .myMelody: return 280
        case .cinnamoroll: return 290
        case .kuromi: return 300
        case .pompompurin: return 310
        case .keroppi: return 320
        case .pochacco: return 330
        case .badtzMaru: return 340
        case .tuxedoSam: return 350
        case .littleTwinStars: return 360
        case .blueTwinStar: return 370
        }
    }

    var emoji: String {
        switch self {
        case .cat: return "🐱"
        case .dog: return "🐶"
        case .bunny: return "🐰"
        case .frog: return "🐸"
        case .chick: return "🐥"
        case .hamster: return "🐹"
        case .duck: return "🦆"
        case .panda: return "🐼"
        case .fox: return "🦊"
        case .owl: return "🦉"
        case .penguin: return "🐧"
        case .koala: return "🐨"
        case .raccoon: return "🦝"
        case .deer: return "🦌"
        case .tiger: return "🐯"
        case .wolf: return "🐺"
        case .lion: return "🦁"
        case .dolphin: return "🐬"
        case .redPanda: return "🔴"
        case .chameleon: return "🦎"
        case .dragon: return "🐲"
        case .phoenix: return "🔥"
        case .unicorn: return "🦄"
        case .shark: return "🦈"
        case .goldenTiger: return "✨"
        case .arcticFox: return "🦊"
        case .snowyOwl: return "🦉"
        case .helloKitty: return "🎀"
        case .myMelody: return "🐰"
        case .cinnamoroll: return "☁️"
        case .kuromi: return "💜"
        case .pompompurin: return "🍮"
        case .keroppi: return "🐸"
        case .pochacco: return "🐕"
        case .badtzMaru: return "🐧"
        case .tuxedoSam: return "🐧"
        case .littleTwinStars: return "⭐"
        case .blueTwinStar: return "🌟"
        }
    }

    static func skinsByRarity(_ rarity: SkinRarity) -> [AnimalSkin] {
        allCases.filter { $0.rarity == rarity }
    }
}

enum EarStyle {
    case pointed, floppy, round, horn, tall, tuft, none, antler
    case sanrioBow, sanrioHood, sanrioJester, sanrioBeret
}
