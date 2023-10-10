
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let MaxHealth = 200
    var name = ""
    var health = 0
    
    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var enterHealth: UITextField!
    @IBOutlet weak var errorHealthLabel: UILabel!
    @IBOutlet weak var errorNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        
        enterName.delegate = self
        enterHealth.delegate = self
    }
    
    override public var shouldAutorotate: Bool {
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == enterName {
            enterHealth.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == enterHealth{
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            return true
        }
    }

    @IBOutlet weak var buttonRandom: UIButton!
    @IBAction func createRandom(_ sender: Any) {
        if check() {
            let storyboard = UIStoryboard(name: "ViewControllerForData", bundle: nil)
            if let vc2 = storyboard.instantiateViewController(identifier: "ViewControllerForData") as? ViewControllerForData{
                vc2.player.Name = name
                vc2.player.Health = health
                vc2.player.Power = Int(arc4random_uniform((30 - 1) + 1) + 1)
                vc2.player.Protection = Int(arc4random_uniform((30 - 1) + 1) + 1)
                vc2.player.Damage_max = Int(arc4random_uniform(UInt32(((vc2.player.Health - 1) - 1) + 1)) + 1)
                vc2.player.Damage_min = Int(arc4random_uniform(UInt32(((vc2.player.Damage_max - 2) - 1) + 1)) + 1)
                show(vc2,sender:nil)
            }
        }
    }
    
    @IBOutlet weak var buttonOwn: UIButton!
    @IBAction func createOwnCharacter(_ sender: Any) {
        if check() {
            let storyboard = UIStoryboard(name: "ViewControllerForData", bundle: nil)
            if let vc2 = storyboard.instantiateViewController(identifier: "ViewControllerForData") as? ViewControllerForData{
                vc2.player.Name = name
                vc2.player.Health = health
                vc2.player.Power = 0
                vc2.player.Protection = 0
                vc2.player.Damage_min = 0
                vc2.player.Damage_max = 0
                show(vc2,sender:nil)
            }
        }
    }
    
    func check()->Bool {
        if enterName.hasText {
            name = enterName.text!
        } else {
            name = ""
        }
        if enterHealth.hasText {
            health = Int(enterHealth.text!)!
        } else {
            health = 0
        }
        
        if name.count > 20 || name.count <= 2{
            errorNameLabel.text = "name can be 3–20 characters long"
            return false
        } else if health > MaxHealth {
            errorHealthLabel.text = "health must be from 1 to \(MaxHealth)"
            return false
        }
        if name == "" {
            errorNameLabel.text = "name can be 3–20 characters long"
            return false
        }
        if health == 0 {
            errorHealthLabel.text = "health must be from 1 to \(MaxHealth)"
            return false
        }

        return true
    }
}

