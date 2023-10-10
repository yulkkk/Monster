
import UIKit

class ViewControllerForData: UIViewController, UITextFieldDelegate {
    
    var player = Player(
        Name: "Miron"  ,
        Health: -1,
        Power:  -1 ,
        Protection:  -1 ,
        Damage_min:  -1 ,
        Damage_max:  -1
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        
        attackText.delegate = self
        protectionText.delegate = self
        damageMinText.delegate = self
        damageMaxText.delegate = self
        
        labelForName.text = "Hi, \(player.Name)!"
        
        if player.Power != 0 {
            attackText.isEnabled = false
            protectionText.isEnabled = false
            damageMinText.isEnabled = false
            damageMaxText.isEnabled = false
            damageMaxText.text = String(player.Damage_max)
            attackText.text = String(player.Power)
            protectionText.text = String(player.Protection)
            damageMinText.text = String(player.Damage_min)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
    }
    
    override public var shouldAutorotate: Bool {
        return false
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var labelForName: UILabel!
    
    @IBOutlet weak var attackText: UITextField!
    @IBOutlet weak var protectionText: UITextField!
    @IBOutlet weak var damageMinText: UITextField!
    @IBOutlet weak var damageMaxText: UITextField!
    
    @IBOutlet weak var errorAttacrLabel: UILabel!
    @IBOutlet weak var errorProtectionLabel: UILabel!
    @IBOutlet weak var errorDamageLabel: UILabel!
    
    var powerDone = false
    var protectionDone = false
    var damageDone = false
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == attackText {
            textField.resignFirstResponder()
            protectionText.becomeFirstResponder()
        } else if textField == protectionText {
            textField.resignFirstResponder()
            damageMinText.becomeFirstResponder()
        } else if textField == damageMinText {
            textField.resignFirstResponder()
            damageMaxText.becomeFirstResponder()
        } else if textField == damageMaxText {
            textField.resignFirstResponder()
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    @IBAction func buttonStartAction(_ sender: Any) {
        if check() {
            let storyboard = UIStoryboard(name: "ViewControllerForFight", bundle: nil)
            if let vc3 = storyboard.instantiateViewController(identifier: "ViewControllerForFight") as? ViewControllerForFight {
                vc3.player1 = player
                
                vc3.monster.Name = "Monster"
                vc3.monster.Health = Int(exactly: player.Health)!
                vc3.monster.Power = Int(arc4random_uniform((30 - 1) + 1) + 1)
                vc3.monster.Protection = Int(arc4random_uniform((30 - 1) + 1) + 1)
                
                vc3.monster.Damage_max = Int(arc4random_uniform(UInt32(((vc3.monster.Health - 1) - 1) + 1)) + 1)
                vc3.monster.Damage_min = Int(arc4random_uniform(UInt32(((vc3.monster.Damage_max - 2) - 1) + 1)) + 1)
                
                vc3.player1.maxHealth = player.Health
                if let navigationController = self.navigationController {
                    navigationController.setViewControllers([vc3], animated: true)
                }
            }
        }
    }
    
    func check()->Bool {
        if attackText.hasText {
            player.Power = Int(attackText.text!)!
        } else {
            player.Power = 0
        }
        if protectionText.hasText {
            player.Protection = Int(protectionText.text!)!
        } else {
            player.Protection = 0
        }
        if damageMinText.hasText {
            player.Damage_min = Int(damageMinText.text!)!
        } else {
            player.Damage_min = 0
        }
        if damageMaxText.hasText {
            player.Damage_max = Int(damageMaxText.text!)!
        } else {
            player.Damage_max = 0
        }
        
        if player.Power > 30 || player.Power == 0 {
            errorAttacrLabel.text = "number must be from 1 to 30"
            powerDone = false
        }  else {
            powerDone = true
            errorAttacrLabel.text = ""
        }
        
        if player.Protection > 30 || player.Protection == 0 {
            errorProtectionLabel.text = "number must be from 1 to 30"
            protectionDone = false
        }  else {
            protectionDone = true
            errorProtectionLabel.text = ""
        }
        
        if player.Damage_min >= player.Damage_max || player.Damage_min == 0 || player.Damage_max > player.Health {
            errorDamageLabel.text = "numbers must be < \(player.Health) and m < n"
            damageDone = false
        } else {
            damageDone = true
            errorDamageLabel.text = ""
        }
        
        if !powerDone || !protectionDone || !damageDone {
            return false
        }

        return true
    }
}
