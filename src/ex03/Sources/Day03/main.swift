import Foundation

enum ProfileStatus: String {
    case ONLINE
    case IN_PLAY
    case SEARCH
    case IDLE
    case OFFLINE
}

class PlayerProfile {
    let id: UUID
    let nickname: String
    let age: Int
    let name: String
    let revolver: String
    let createdDate: String
    var status: ProfileStatus
    lazy var profileLink: String = "http://gameserver.com/\(id)-\(nickname)"
    
    init(nickname: String, age: Int, name: String, revolver: String, status: ProfileStatus) {
        self.id = UUID()
        self.nickname = nickname
        self.age = age
        self.name = name
        self.revolver = revolver
        self.createdDate = Date().description
        self.status = status
    }
}

protocol PlayerAction {
    func findOpponent() -> PlayerProfile?
}

class GameServer: PlayerAction {
    let serverAddress: String
    var players: [PlayerProfile]
    var playerActionDelegate: PlayerAction?
    
    init(serverAddress: String) {
        self.serverAddress = serverAddress
        self.players = []
    }
    
    func findOpponent() -> PlayerProfile? {
        for (index, player) in players.enumerated() {
            if player.status == .IDLE && player !== playerActionDelegate as? PlayerProfile {
                players[index].status = .IN_PLAY
                return players[index]
            }
        }
        return nil
    }
}

let player1 = PlayerProfile(nickname: "Player1", age: 21, name: "User1", revolver: "gun", status: .IDLE)
let player2 = PlayerProfile(nickname: "Player2", age: 21, name: "User2", revolver: "pistol", status: .IDLE)
let player3 = PlayerProfile(nickname: "Player3", age: 18, name: "User3", revolver: "gun2", status: .IDLE)
let player4 = PlayerProfile(nickname: "Player4", age: 80, name: "User4", revolver: "pistol2", status: .ONLINE)
let server = GameServer(serverAddress: "http://gameserver.com")
server.players.append(contentsOf: [player1, player2, player3, player4])
let myProfile = PlayerProfile(nickname: "IamPlayer", age: 22, name: "User", revolver: "gun", status: .ONLINE)

if let opponent = server.playerActionDelegate?.findOpponent() {
    print("No opponents found\(opponent)")
} else {
    print("Opponent found: \(myProfile.nickname)")
    myProfile.status = .SEARCH
    myProfile.status = .IN_PLAY
}