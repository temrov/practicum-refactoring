import Foundation

protocol Figure {
    func area() ->Int
}

class Rectangle: Figure {
    var width: Int
    var height: Int

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    func area() -> Int {
        return width * height
    }
}

class Square: Figure {
    init(side: Int) {
        self.side = side
    }
    var side: Int

    func area() -> Int {
        side * side
    }
}

let rect: Rectangle = Rectangle(width: 2, height: 4)
//print("\(rect.area())") // 8

var square: Rectangle = Square(side: 3) // 3 на 3
square.height = 4 // 3 на 4
//print("\(square.area())") // 16
