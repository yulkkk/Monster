//
//  ViewControllerForFight.swift
//  Monster
//
//  Created by Юлия Иванова on 08.10.2023.
//

import UIKit

class ViewControllerForFight: UIViewController {
    
    var countHealing = 0
    var countAttack = 1
    var player1 = Player(Name: "", Health: -1, Power: -1, Protection: -1, Damage_min: -1, Damage_max: -1)
    var monster = Monster(Name: "", Health: -1, Power: -1, Protection: -1, Damage_min: -1, Damage_max: -1)

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
        
        restartOutlet.isEnabled = false
        
        roundCounter.text = "Round \(countAttack)"
        
        namePlayer.text = player1.Name
        healthPlayer.text = String(player1.Health)
        powerPlayer.text = String(player1.Power)
        protectionPlayer.text = String(player1.Protection)
        damagePlayer.text = "\(player1.Damage_min) - \(player1.Damage_max)"
        
        nameMonster.text = monster.Name
        healthMonster.text = String(monster.Health)
        powerMonster.text = String(monster.Power)
        protectionMonster.text = String(monster.Protection)
        damageMonster.text = "\(monster.Damage_min) - \(monster.Damage_max)"
        
        attackOutlet.setTitle("player attack", for: .normal)
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    @IBOutlet weak var namePlayer: UILabel!
    @IBOutlet weak var healthPlayer: UILabel!
    @IBOutlet weak var powerPlayer: UILabel!
    @IBOutlet weak var protectionPlayer: UILabel!
    @IBOutlet weak var damagePlayer: UILabel!
    @IBOutlet weak var roundCounter: UILabel!
    
    @IBOutlet weak var nameMonster: UILabel!
    @IBOutlet weak var healthMonster: UILabel!
    @IBOutlet weak var powerMonster: UILabel!
    @IBOutlet weak var protectionMonster: UILabel!
    @IBOutlet weak var damageMonster: UILabel!
    @IBOutlet weak var healingOutlet: UIButton!
    @IBOutlet weak var attackOutlet: UIButton!
    
    @IBOutlet weak var restartOutlet: UIButton!
    @IBOutlet weak var healingCountLabel: UILabel!
    
    @IBAction func healingButton(_ sender: Any) {
        countHealing = countHealing + 1
        if countHealing > 4 {
            healingOutlet.isEnabled = false
        } else if countHealing == 4 {
            player1.Health = player1.Healing()
            healthPlayer.text = String(player1.Health)
            healingCountLabel.text = "healing counter: \(4 - countHealing) "
            healingOutlet.isEnabled = false
        }
        else {
            player1.Health = player1.Healing()
            healthPlayer.text = String(player1.Health)
            healingCountLabel.text = "healing counter: \(4 - countHealing) "
        }
    }
    
    var lastAttackPlayer = false
    
    @IBAction func attackButton(_ sender: Any) {
        if !lastAttackPlayer { // нападает игрок
            if player1.Attack(second: monster){
                successLabel.text = "Successful player attack!!!"
                monster.Health = editingMonsterChar(player: player1, monster: monster)
            } else {
                successLabel.text = "Fail player attack("
            }
            attackOutlet.setTitle("monster attack", for: .normal)
        } else { // нападает монстр
            if monster.Attack(second: player1){
                successLabel.text = "Successful monster attack!!!"
                player1.Health = editingPlayerChar(player: player1, monster: monster)
            } else {
                successLabel.text = "Fail monster attack("
            }
            countAttack = countAttack + 1
            roundCounter.text = "Round \(countAttack)"
            attackOutlet.setTitle("player attack", for: .normal)
        }
        lastAttackPlayer = !lastAttackPlayer
    }
    
    func editingPlayerChar(player: Creature, monster: Creature)->Int{
        let loss = arc4random_uniform(UInt32((monster.Damage_max - monster.Damage_min) + 1)) + UInt32(monster.Damage_min)
        if player.Health - Int(loss) <= 0{
            attackOutlet.isEnabled = false
            healingOutlet.isEnabled = false
            successLabel.font = successLabel.font.withSize(20)
            successLabel.text = "Defeted!!!"
            healthPlayer.text = "0"
            restartOutlet.isEnabled = true
            return -10
        } else {
            player.Health = player.Health - Int(loss)
            healthPlayer.text = String(player.Health)
            return player.Health
        }
    }
    
    func editingMonsterChar(player: Creature, monster: Creature)->Int{
        let loss = arc4random_uniform(UInt32((player.Damage_max - player.Damage_min) + 1)) + UInt32(player.Damage_min)
        if monster.Health - Int(loss) <= 0{
            attackOutlet.isEnabled = false
            healingOutlet.isEnabled = false
            successLabel.font = successLabel.font.withSize(20)
            successLabel.text = "Win!!!"
            healthMonster.text = "0"
            restartOutlet.isEnabled = true
            return -1
        } else {
            monster.Health = monster.Health - Int(loss)
            healthMonster.text = String(monster.Health)
            return monster.Health
        }
    }
    
    @IBAction func restartButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ViewController") as! ViewController
        //        present(vc,animated: true)
        navigationController?.pushViewController(vc, animated: true)
        if let navigationController = self.navigationController {
            navigationController.setViewControllers([vc], animated: true)
        }
    }
    
    @IBOutlet weak var successLabel: UILabel!
    
}
