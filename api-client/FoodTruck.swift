import Foundation
import CoreLocation
import MapKit

class FoodTruck: NSObject, MKAnnotation {
    var id: String = ""
    var name: String = ""
    var cuisine: String = ""
    var avgCost = 0.0
    var geometry: String = "Point"
    var lat: Double = 0.0
    var long: Double = 0.0
    
    // below we're conforming to MKAnnotation
    // can now place pins on the map, with title and subtitle
    @objc var title: String?
    @objc var subtitle: String?
    @objc var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    }
    
    static func parseFoodtruckJSONData(data: Data) -> [FoodTruck] {
        var foodtrucks = [FoodTruck]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // parse JSON data
            if let trucks = jsonResult as? [Dictionary<String, AnyObject>] {
                for truck in trucks {
                    let newTruck = FoodTruck()
                    newTruck.id = truck["_id"] as! String
                    newTruck.name = truck["name"] as! String
                    newTruck.cuisine = truck["cuisine"] as! String
                    newTruck.avgCost = truck["avgCost"] as! Double
                    let geometry = truck["geometry"] as! Dictionary<String, AnyObject>
                    newTruck.geometry = geometry["type"] as! String
                    let coords = geometry["coordinates"] as! Dictionary<String, AnyObject>
                    newTruck.lat = coords["lat"] as! Double
                    newTruck.long = coords["long"] as! Double
                    
                    // for map
                    newTruck.title = newTruck.name
                    newTruck.subtitle = newTruck.cuisine
                    
                    foodtrucks.append(newTruck)
                }
            }
            
        } catch let err {
            print(err)
        }
        return foodtrucks
    }
}
