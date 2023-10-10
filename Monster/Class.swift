
import Foundation

class Creature {
    var Name: String
    var Health: Int
    var Power: Int   //до 30
    var Protection: Int   //до 30
    var Damage_min: Int
    var Damage_max: Int
    
    init(
        Name: String ,
        Health: Int ,
        Power: Int ,  //до 30
        Protection: Int  , //до 30
        Damage_min: Int  ,
        Damage_max: Int
    ) {
        self.Name = Name
        self.Health = Health
        self.Power = Power
        self.Protection = Protection
        self.Damage_min = Damage_min
        self.Damage_max = Damage_max
    }
    
    func Attack(second: Creature) -> Bool{
        let attackMod = self.Power - second.Protection + 1
        var numbers : [Int] = []
        if attackMod > 0{
            for _ in 1...attackMod{
                numbers.append(Int(arc4random_uniform((6 - 1) + 1)) + 1)
            }
        } else {
            numbers.append(Int(arc4random_uniform((6 - 1) + 1)) + 1)
        }
        if numbers.contains(5) {
            return true
        } else if numbers.contains(6) {
            return true
        } else {
            return false
        }
    }
}

class Player: Creature {
    var maxHealth: Int = 0
    
    override init(Name: String ,
                  Health: Int ,
                  Power: Int ,  //до 30
                  Protection: Int  , //до 30
                  Damage_min: Int  ,
                  Damage_max: Int
    ) {
        super.init(Name: Name, Health: Health, Power: Power, Protection: Protection, Damage_min: Damage_min, Damage_max: Damage_max)
        self.maxHealth = Health
    }
    
    func Healing() -> Int {
        if self.Health + Int(Double(self.maxHealth) * 0.3) >= self.maxHealth{
            self.Health = self.maxHealth
        } else {
            self.Health = self.Health + Int(Double(self.maxHealth) * 0.3)
        }
        return self.Health
    }
}

class Monster: Creature {
}
