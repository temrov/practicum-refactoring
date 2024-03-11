import Foundation

// Low-level class: Dog
class Dog {
    func bark() {
        print("Woof!")
    }
}

// Low-level class: Cat
class Cat {
    func meow() {
        print("Meow!")
    }
}

// High-level class: AnimalSoundMaker
class AnimalSoundMaker {
    let dog: Dog
    let cat: Cat

    init(dog: Dog, cat: Cat) {
        self.dog = dog
        self.cat = cat
    }

    func makeDogSound() {
        dog.bark()
    }

    func makeCatSound() {
        cat.meow()
    }
}
