import UIKit
import MapKit

class DetailsVC: UIViewController {
    
    var selectedFoodtruck: FoodTruck?
    var loginVC: LoginVC?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var avgCostLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = selectedFoodtruck?.name
        cuisineLabel.text = selectedFoodtruck?.cuisine
        avgCostLabel.text = "\(selectedFoodtruck!.avgCost)"
        
        mapView.addAnnotation(selectedFoodtruck!)
        centerMapOnLocation(CLLocation(latitude: selectedFoodtruck!.lat, longitude: selectedFoodtruck!.long))

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReviewsVC" {
            let destinationViewController = segue.destination as! ReviewsVC
            destinationViewController.selectedFoodtruck = selectedFoodtruck
        }
        else if segue.identifier == "showAddReviewVC" {
            let destinationViewController = segue.destination as! AddReviewVC
            destinationViewController.selectedFoodtruck = selectedFoodtruck
        }
    }
    
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(selectedFoodtruck!.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reviewsButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "showReviewsVC", sender: self)
    }
    
    @IBAction func addReviewButtonTapped(sender: UIButton) {
        if AuthService.instance.isAuthenticated == true {
            performSegue(withIdentifier: "showAddReviewVC", sender: self)
        }
        else {
            showLoginVC()
        }
    }

    func showLoginVC() {
        loginVC = LoginVC()
        loginVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(loginVC!, animated: true, completion: nil)
    }

}
