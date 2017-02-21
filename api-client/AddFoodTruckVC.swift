import UIKit

class AddFoodTruckVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cuisineField: UITextField!
    @IBOutlet weak var avgCostField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        guard let name = nameField.text, nameField.text != "" else {
            showAlert(with: "Error", message: "Please enter a name")
            return
        }
        guard let cuisine = cuisineField.text, cuisineField.text != "" else {
            showAlert(with: "Error", message: "Please enter a cuisine")
            return
        }
        guard let avgCost = Double(avgCostField.text!), avgCostField.text != "" else {
            showAlert(with: "Error", message: "Please enter an average cost")
            return
        }
        guard let lat = Double(latField.text!), latField.text != "" else {
            showAlert(with: "Error", message: "Please enter a latitude")
            return
        }
        guard let long = Double(longField.text!), longField.text != "" else {
            showAlert(with: "Error", message: "Please enter a longitude")
            return
        }
        DataService.instance.addNewFoodTruck(name, cuisine: cuisine, avgCost: avgCost, latitude: lat, longitude: long, completion: {
            Success in
            if Success {
                print("We saved successfully")
                self.dismissViewController()
            }
            else {
                self.showAlert(with: "Error", message: "An error occurred saving the new food truck")
                print("We didn't save successfully")
            }
        })
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewController()
    }

    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewController()
    }
    
    func dismissViewController() {
        OperationQueue.main.addOperation {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
