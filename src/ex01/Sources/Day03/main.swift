import Foundation

class RevolverDrum<T: Equatable>: Equatable {
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
            if objects[i] == nil {
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
            if objects[i] == nil && added < elements.count {
                objects[i] = elements[added]
                pointer = i
                added += 1
            }
        }
        return added > 0
    }
    
    func shoot() -> T? {
        guard let object = objects[pointer] else {
            pointer = (pointer + 1) % objects.count
            return nil
        }
        objects[pointer] = nil
        pointer = (pointer + 1) % objects.count
        return object
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

func main() {
    // Adding elements
    let revolver = RevolverDrum<Int>(maxSize: 6)
    _ = revolver.add(3)
    _ = revolver.add(54)
    _ = revolver.add(7)
    _ = revolver.add(2)
    _ = revolver.add(56)
    _ = revolver.add(4)

    print("\n1. Adding elements")
    print(revolver.description)

    // Subscript
    print("\n2. Subscript")
    print("\(revolver[0]!), \(revolver[5]!)")

    // Scroll
    print("\n3. Scroll")
    revolver.scroll()
    print(revolver.description)

    // Deletion
    print("\n3. Deletion")
    print("Before:")
    print(revolver.description)
    for _ in 1...4 {
        _ = revolver.shoot()
    }
    print("After:")
    print(revolver.description)

    // Supply collection
    print("\n4. Supply collection")
    let collection = [4, 6, 3, 22, 77, 43, 76, 5]
    print("Before: ")
    print("Supply collection: \(collection)")
    for element in collection {
        _ = revolver.add(element)
        if revolver.count >= 6 {
            break
        }
    }
    print(revolver.description)

    // Extraction
    print("\n5. Extraction")
    let extracted = revolver.unload()
    print("Extracted: \(extracted), size: \(extracted.count)")
    print("Revolver size: \(revolver.count)")
    _ = revolver.addAll(extracted)
    _ = revolver.add(10)
    _ = revolver.add(20)
    _ = revolver.add(30)
    _ = revolver.add(40)
    print(revolver.description)

    // Compare two structures
    print("\n7. Equals")
    let revolver2 = RevolverDrum<Int>(maxSize: 6)
    _ = revolver2.addAll([22, 54, 6, 4, 3, 54])
    revolver2.scroll()
    print(revolver2.description)
    print(revolver == revolver2)
}

main()
