import UIKit

class AddReviewVC: UIViewController {

    var selectedFoodtruck: FoodTruck?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var reviewTitleField: UITextField!
    @IBOutlet weak var reviewDescriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let truck = selectedFoodtruck {
            headerLabel.text = truck.name
        }
        else {
            headerLabel.text = "Add Review"
        }
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        guard let truck = selectedFoodtruck else {
            showAlert(with: "Error", message: "Could not get selected truck")
            return
        }
        
        guard let title = reviewTitleField.text, reviewTitleField.text != "" else {
            showAlert(with: "Error", message: "Please enter a title for your review")
            return
        }
        
        guard let description = reviewDescriptionField.text, reviewDescriptionField.text != "" else {
            showAlert(with: "Error", message: "Please enter a description for your review")
            return
        }
        
        DataService.instance.addNewReview(truck.id, title: title, text: description, completion: { Success in
            if Success {
                print("We saved successfully")
                DataService.instance.getAllReviews(for: truck)
                self.dismissViewController()
            }
            else {
                self.showAlert(with: "Error", message: "An error occurred saving the new review")
                print("Save was unsuccessful")
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
        let okAction = UIAlertAction(title: "Error", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
