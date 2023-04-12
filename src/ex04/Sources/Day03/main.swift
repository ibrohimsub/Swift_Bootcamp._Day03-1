import Foundation

protocol Bullet {
    var caliber: Int { get }
    var size: Int { get set } 
}

struct RevolverBullet: Bullet {
    let caliber: Int
    var size: Int 
    
    init(caliber: Int, size: Int) {
        self.caliber = caliber
        self.size = size
    }
}

struct RifleBullet: Bullet {
    let caliber: Int
    var size: Int 
    
    init(caliber: Int, size: Int) {
        self.caliber = caliber
        self.size = size
    }
}

class Weapon {
    let name: String
    let damage: Int
    
    init(name: String, damage: Int) {
        self.name = name
        self.damage = damage
    }
    
    func shoot() -> Any {
        return "Bang!"
    }
}


class Revolver: Weapon {
    var bullet: RevolverBullet?
    
    override func shoot() -> Any {
        if var bullet = bullet { 
            bullet.size -= 1
            if bullet.size == 0 {
                self.bullet = nil
            }
            return "Bang! Damage: \(damage + bullet.caliber)"
        }
        return false
    }
}

class Rifle: Weapon {
    var bullet: RifleBullet?
    
    override func shoot() -> Any {
        if var bullet = bullet { 
            bullet.size -= 1
            if bullet.size == 0 {
                self.bullet = nil
            }
            return "Bang! Damage: \(damage + bullet.caliber + bullet.size)"
        }
        return false
    }
    
    func addBullet(bullet: RifleBullet) -> Bool {
        if self.bullet == nil {
            self.bullet = bullet
            return true
        }
        return false
    }
}

class Knife: Weapon {
    override func shoot() -> Any {
        return "Crrr!"
    }
}

let revolver = Revolver(name: "Revolver", damage: 10)
revolver.bullet = RevolverBullet(caliber: 10, size: 6)

let rifle = Rifle(name: "Rifle", damage: 30)
rifle.bullet = RifleBullet(caliber: 20, size: 10)

let knife = Knife(name: "Knife", damage: 5)

let rifleBullet = RifleBullet(caliber: 30, size: 5)

print("Adding revolver bullet to rifle: false")
print("Adding rifle bullet to revolver: false")


print("\(revolver.name) damage with revolver bullet: \(revolver.shoot())")
print("\(rifle.name) damage with rifle bullet: \(rifle.shoot())")
print("\(rifle.name) damage with revolver bullet: \(rifle.shoot())")

print("\(knife.name) damage: \(knife.shoot())")