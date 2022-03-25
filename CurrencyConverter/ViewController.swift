import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func refreshButtonClicked(_ sender: Any)
    {
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=04d7bdd65ebcaa2f86685173eb653899&format=1")
    
        let session = URLSession.shared
        let task = session.dataTask(with: url!){ data, response, error in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                if data != nil
                {
                    do
                    {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        
                        DispatchQueue.main.async
                        {
                            print(jsonResponse)
                            if let rates = jsonResponse["rates"] as? [String:Any]
                            {
                                if let tl = rates["TRY"] as? Double
                                {
                                    self.tryLabel.text = "TL: \(tl)"
                                }
                                
                                if let usd = rates["USD"] as? Double
                                {
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                
                                if let gbp = rates["GBP"] as? Double
                                {
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                            }
                        }
                    }
                    catch
                    {
                        print("error")
                    }
                    
                }
            }
        }
        
        task.resume()
    }
}
