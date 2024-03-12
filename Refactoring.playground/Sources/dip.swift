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

protocol AnimalSoundable {
    func makeNoise()
}

// High-level class: AnimalSoundMaker
class AnimalSoundMaker {
    let animal: AnimalSoundable

    init(animal: AnimalSoundable) {
        self.animal = animal
    }

    func noise() {
        animal.makeNoise()
    }

}

extension Cat: AnimalSoundable {
    func makeNoise() {
        meow()
    }
}

extension Dog: AnimalSoundable {
    func makeNoise() {
        bark()
    }
}
