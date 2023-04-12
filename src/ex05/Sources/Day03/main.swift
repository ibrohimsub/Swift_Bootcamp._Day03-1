import Foundation

enum WeaponType {
    case knife, gun
}

class Player {
    let name: String
    var health: Int
    let weapon: WeaponType
    var isAttacker: Bool = false
    
    init(name: String, weapon: WeaponType) {
        self.name = name
        self.health = 100
        self.weapon = weapon
    }
    
    func attack() -> Int {
        switch weapon {
        case .knife:
            return Int.random(in: 10...30)
        case .gun:
            return Int.random(in: 20...40)
        }
    }
}

protocol PlayerAction {
    func fight() -> Bool
}

class Battle: PlayerAction {
    let player1: Player
    let player2: Player
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    func fight() -> Bool {
        player1.isAttacker = Bool.random()
        player2.isAttacker = !player1.isAttacker
        
        var currentPlayer = player1
        var opponent = player2
        
        while true {
            let damage = currentPlayer.attack()
            opponent.health -= damage
            print("\(currentPlayer.name) \(currentPlayer.health) - \(opponent.health) \(opponent.name) \(currentPlayer.name) shoot by \(currentPlayer.weapon) \(damage)")
            
            if opponent.health <= 0 {
                print("\(opponent.name) is defeated!")
                return currentPlayer.name == player1.name
            }
            
            let temp = currentPlayer
            currentPlayer = opponent
            opponent = temp
        }
    }
}

let player1 = Player(name: "Player1", weapon: .knife)
let player2 = Player(name: "Player2", weapon: .gun)

let battle = Battle(player1: player1, player2: player2)
let player1Wins = battle.fight()
print(player1Wins ? "\(player1.name) wins!" : "\(player2.name) wins!")