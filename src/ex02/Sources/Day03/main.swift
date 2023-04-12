import Foundation

protocol Bullet {
    var isLoaded: Bool { get set }
    var id: UUID { get }
    func shoot()
}

class TwentyTwo: Bullet {
    let id: UUID
    var isLoaded = false
    
    init() {
        self.id = UUID()
    }
    
    func shoot() {
        if isLoaded {
            print("Bang - 22")
        } else {
            print("Click")
        }
    }
}

extension TwentyTwo: Equatable {
    static func == (lhs: TwentyTwo, rhs: TwentyTwo) -> Bool {
        return lhs.id == rhs.id && lhs.isLoaded == rhs.isLoaded
    }
}


class ThreeEighty: Bullet {
    let id: UUID
    var isLoaded = false
    
    init() {
        self.id = UUID()
    }
    
    func shoot() {
        if isLoaded {
            print("Bang - 380")
        } else {
            print("Click")
        }
    }
}

extension ThreeEighty: Equatable {
    static func == (lhs: ThreeEighty, rhs: ThreeEighty) -> Bool {
        return lhs.id == rhs.id && lhs.isLoaded == rhs.isLoaded
    }
}


class FortyFive: Bullet {
    let id: UUID
    var isLoaded = false
    
    init() {
        self.id = UUID()
    }
    
    func shoot() {
        if isLoaded {
            print("Bang - 45")
        } else {
            print("Click")
        }
    }
}

extension FortyFive: Equatable {
    static func == (lhs: FortyFive, rhs: FortyFive) -> Bool {
        return lhs.id == rhs.id && lhs.isLoaded == rhs.isLoaded
    }
}


class RevolverDrum<T: Bullet>: Equatable where T: Equatable {
    var objects: [T?]
    var pointer: Int = 0
    
    init(maxSize: Int) {
        objects = Array<T?>(repeating: nil, count: maxSize)
        for i in 0..<objects.count {
            if objects[i] != nil {
                pointer = i
                break
            }
        }
    }

    func add(_ element: T) -> Bool {
        for i in 0..<objects.count {
            if objects[i] == nil && !objects.contains(where: { $0?.id == element.id }) {
                objects[i] = element
                pointer = i
                return true
            }
        }
        return false
    }
    
    func addAll(_ elements: [T]) -> Bool {
        if elements.isEmpty {
            return false
        }
        var added = 0
        for i in 0..<objects.count {
            if objects[i] == nil && added < elements.count && !objects.contains(where: { $0?.id == elements[added].id }) {
                objects[i] = elements[added]
                pointer = i
                added += 1
            }
        }
        return added > 0
    }
    
    func shoot() {
        guard let object = objects[pointer], object.isLoaded else {
            pointer = (pointer + 1) % objects.count
            print("Click")
            return
        }
        object.shoot()
        objects[pointer]?.isLoaded = false
        pointer = (pointer + 1) % objects.count
    }
    
    func unload() -> [T] {
        var unloaded: [T] = []
        for i in 0..<objects.count {
            if let object = objects[i] {
                unloaded.append(object)
                objects[i] = nil
            }
        }
        pointer = 0
        return unloaded
    }
    
    func unloadCurrent() -> T? {
        guard let object = objects[pointer] else {
            return nil
        }
        objects[pointer] = nil
        pointer = (pointer + 1) % objects.count
        return object
    }
    
    func scroll() {
        pointer = Int.random(in: 0..<objects.count)
    }
    
    var count: Int {
        return objects.filter { $0 != nil }.count
    }
    
    subscript(index: Int) -> T? {
        guard index < objects.count else {
            fatalError("Index out of bounds")
        }
        return objects[index]
    }
    static func == (lhs: RevolverDrum<T>, rhs: RevolverDrum<T>) -> Bool {
        for i in 0..<lhs.objects.count {
            var matches = true
            for j in 0..<lhs.objects.count {
                if lhs.objects[(i+j)%lhs.objects.count] != rhs.objects[j] {
                    matches = false
                    break
                }
            }
            if matches {
               return true
            }
        }
        return false
    }

    
    var description: String {
        var result = "Structure: RevolverDrum<\(T.self)> \n"
        result += "Objects: "
        let objectsArray = objects.map { $0 == nil ? "nil" : "\($0!)" }
        result += "[\(objectsArray.joined(separator: ", "))]\n"
        result += "Pointer: \(objects[pointer]!)"
        return result
    }
}


let revolver = RevolverDrum<FortyFive>(maxSize: 6)
_ = revolver.add(FortyFive())
_ = revolver.add(FortyFive())
_ = revolver.add(FortyFive())
_ = revolver.add(FortyFive())
_ = revolver.add(FortyFive())
_ = revolver.add(FortyFive())

print(revolver)

print("First element: \(revolver[0]!)")
print("Last element: \(revolver[5]!)")

revolver.scroll()
print(revolver)

revolver.shoot()
revolver.shoot()
revolver.shoot()
revolver.shoot()
revolver.shoot()
revolver.shoot()
revolver.shoot()
revolver.shoot()
revolver.shoot()

print(revolver.unload())
