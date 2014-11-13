//
//  ViewController.swift
//  Lemonade Stand
//
//  Created by home on 30/10/2014.
//  Copyright (c) 2014 home. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var moneySupplyCount: UILabel!
    @IBOutlet weak var lemonSupplyCount: UILabel!
    @IBOutlet weak var iceCubeSupplyCount: UILabel!
    
    @IBOutlet weak var lemonPurchaseCount: UILabel!
    @IBOutlet weak var iceCubePurchaseCount: UILabel!
    
    @IBOutlet weak var lemonMixCount: UILabel!
    @IBOutlet weak var iceCubeMixCount: UILabel!
    
    var supplies = Supplies(aMoney: 10, aLemons: 1, aIceCube: 1)
    let price = Price()
    
    var lemonsToPurchase = 0
    var iceCubesToPurchase = 0
    
    var lemonsToMix = 0
    var iceCubeToMix = 0
    
    //Each internal array is a weather pattern through a single day.
    var weatherArray :[[Int]] = [[-10,-9,-5,-7],[5,8,10,9],[22,25,27,23]]
    var weatherToday :[Int] = [0,0,0,0]
    
    var weatherImageView:UIImageView = UIImageView(frame: CGRect(x: 20, y: 50, width: 50, height: 50))
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(weatherImageView)
        updateMainView()
        simulateWeatherToday()
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //IBActions
    
    @IBAction func purchaseLemonButtonPressed(sender: UIButton)
    {
        if supplies.money >= price.lemon
        {
        lemonsToPurchase += 1
        supplies.money = supplies.money - price.lemon
        supplies.lemons += 1
        updateMainView()
        }
        else
        {
            showAlertWithText(message: "No money left !")
        }
    }

    @IBAction func purchaseIceCubeButtonPressed(sender: UIButton)
    {
        if supplies.money >= price.iceCube
        {
        iceCubesToPurchase += 1
        supplies.money = supplies.money - price.iceCube
        supplies.iceCubes += 1
        updateMainView()
        }
        else
        {
            showAlertWithText(header: "Error", message: "You don't have enough money")
        }
    }
    
    @IBAction func unpurchaseLemonButtonPressed(sender: UIButton)
    {
        if lemonsToPurchase > 0
        {
        lemonsToPurchase -= 1
        supplies.money = supplies.money + price.lemon
        supplies.lemons -= 1
        updateMainView()
        }
        else
        {
            showAlertWithText(message: "You don't have anything to return")
        }
    }
    
    @IBAction func unpurchaseIceCubeButtonPressed(sender: UIButton)
    {
        if iceCubesToPurchase > 0
        {
        iceCubesToPurchase -= 1
        supplies.money = supplies.money + price.iceCube
        supplies.iceCubes -= 1
        updateMainView()
        }
        else
        {
            showAlertWithText(header: "Be Careful", message: "You have 0 IceCubes!")
        }
        
    }
    
    @IBAction func mixLemonButtonPressed(sender: UIButton)
    {
        if supplies.lemons > 0
        {
             lemonsToPurchase = 0 //to fix the bug of the user being able to change the purchase after mix
             lemonsToMix += 1
             supplies.lemons -= 1
             updateMainView()
        }
        else
        {
            showAlertWithText(header: "Wait!", message: "You don't have any lemons")
        }
    }
    
    @IBAction func mixIceCubeButtonPressed(sender: UIButton)
    {
        if supplies.iceCubes > 0
        {
            iceCubesToPurchase = 0
            iceCubeToMix += 1
            supplies.iceCubes -= 1
            updateMainView()
        }
        else
        {
            showAlertWithText(message: "You don't have any ice cubes")
        }
    }
    
    @IBAction func unmixLemonButtonPressed(sender: UIButton)
    {
        if lemonsToMix > 0
        {
        lemonsToPurchase = 0
        lemonsToMix -= 1
        supplies.lemons += 1
        updateMainView()
        }
        else
        {
            showAlertWithText(message: "Nothing left to un-Mix")
        }
        
    }
    
    @IBAction func unmixIceCubeButtonPressed(sender: UIButton)
    {
        if iceCubeToMix > 0
        {
            iceCubesToPurchase = 0
            iceCubeToMix -= 1
            supplies.iceCubes += 1
            updateMainView()
        }
        else
        {
            showAlertWithText(message: "Nothing left to un-Mix")
        }
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton)
    {
        
        let average = findAverage(weatherToday)
     
//        let customers = Int(arc4random_uniform(UInt32(11))) //generate random number between 0 - 10
        
        //This time, instead of using a potential 10 customers, we will use the average of the weather to limit our random function. Lower temperatures will get fewer customers.
        let customers = Int(arc4random_uniform(UInt32(abs(average)))) //generate random number between 0 - 10
        println("customers:\(customers)")
        
        if lemonsToMix == 0 || iceCubeToMix == 0
        {
            showAlertWithText(message: "You need to add al least 1 Lemon and 1 IceCube")
        }
        else
        {
            //we need the lemonadeRation as a double becasue if we use it as Int we will cut off the reminder but actually we do need the reminder
            //A ratio of greater than 1 means you have more lemons, less than 1 means you have more ice, and 1 means you have equal amounts.
            let lemonadeRation = Double(lemonsToMix) / Double(iceCubeToMix)
            
            for x in 0 ... customers
            {
                let preference = Double(arc4random_uniform(UInt32(101))) / 100
                
                //Use if, and else if, to determine if the preference and the lemonade ratio match. If the preferences match, we add $1 to the users supplies.
                if preference < 0.4 && lemonadeRation > 1
                {
                    supplies.money += 1
                    println("paid")
                }
                else if preference > 0.5 && lemonadeRation < 1
                {
                    supplies.money += 1
                    println("paid")
                }
                else if preference <= 0.6 && preference >= 0.4 && lemonadeRation == 1
                {
                    supplies.money += 1
                    println("paid")
                }
                else
                {
                    println("else statement evaluating")
                }
                
                lemonsToPurchase = 0
                iceCubesToPurchase = 0
                lemonsToMix = 0
                iceCubeToMix = 0
                
                simulateWeatherToday()
                updateMainView()
                
            }
        }
    }
    
    //Helper functions
    
    func updateMainView()
    {
        moneySupplyCount.text = "$\(supplies.money)"
        lemonSupplyCount.text = "\(supplies.lemons) Lemons"
        iceCubeSupplyCount.text = "\(supplies.iceCubes) IceCubes"
        
        lemonPurchaseCount.text = "\(lemonsToPurchase)"
        iceCubePurchaseCount.text = "\(iceCubesToPurchase)"
        
        lemonMixCount.text = "\(lemonsToMix)"
        iceCubeMixCount.text = "\(iceCubeToMix)"
        
    }
    
    func showAlertWithText (header : String = "Warning" , message: String)
    {
        
        //Create a variable named alert. Initialize a UIAlertController instance and set it equal to the variable alert
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Adding an action will allow the user to close the alert.
        //We set the button's title for closing the alert view by setting the title.
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        
        //Finally, we can present the UIAlertController instance on the screen. We use the function presentViewController. By setting the animated parameter to true, the alert will nicely animate onto the screen
        self.presentViewController(alert, animated: true, completion: nil)
        
        //Notice we are setting the header variable to have a preset value of "Warning". This is useful because most of the time it will be warning, but could change if we want it to. No need for making a new method, just pass in that parameter. Since the first parameter has a default value, it is an optional parameter. The second parameter does not have a default, so it is required.
    }
    
    func simulateWeatherToday()
    {
        
        let index = Int(arc4random_uniform(UInt32(weatherArray.count)))
        weatherToday = weatherArray[index]
        
        switch index
        {
            case 0: weatherImageView.image = UIImage(named: "cold")
            case 1: weatherImageView.image = UIImage(named: "mild")
            case 2: weatherImageView.image = UIImage(named: "warm")
            default:weatherImageView.image = UIImage(named: "warm")
        }
    }
    
    func findAverage(data:[Int]) -> Int
    {
        var sum = 0
        for x in data
        {
            sum += x
        }
        
        var average:Double = Double(sum) / Double(data.count)
        var rounded:Int = Int(ceil(average))
        
        return rounded
    }

}

