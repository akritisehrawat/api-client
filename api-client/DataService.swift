import Foundation

protocol DataServiceDelegate: class  {
    func foodtrucksLoaded()
    func reviewsLoaded()
}

class DataService {
    static let instance = DataService()
    
    weak var delegate: DataServiceDelegate?
    var foodtrucks = [FoodTruck]()
    var reviews = [Review]()
    
    // below funcs roughly equate to our API
    // get all foodtrucks
    func getAllFoodtrucks() {
        let sessionConfig = URLSessionConfiguration.default
        
        // create session
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // create request
        // do a GET on /api/v1/foodtrucks
        guard let URL = URL(string: GET_ALL_FOODTRUCKS) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if(error == nil) {
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                if let data = data {
                    self.foodtrucks = FoodTruck.parseFoodtruckJSONData(data: data)
                    self.delegate?.foodtrucksLoaded()
                }
            }
            else {
                print("URL Session Task Failed \(error!.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    
    // get all foodtrucks for a specific truck
    func getAllReviews(for truck: FoodTruck) {
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(GET_ALL_REVIEWS_FOR_ONE_FOODTRUCK)/\(truck.id)") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error:Error?) -> Void in
            if (error == nil) {
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                if let data = data {
                    self.reviews = Review.parseReviewJSONData(data: data)
                    self.delegate?.reviewsLoaded()
                }
            }
            else {
                print("URL Session Task Failed: \(error?.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    
    // post a new foodtruck
    func addNewFoodTruck(_ name: String, cuisine: String, avgCost: Double, latitude: Double, longitude: Double, completion: @escaping callback) {
        
        // construct our json
        let json: [String: Any] = [
            "name": name,
            "cuisine": cuisine,
            "avgCost": avgCost,
            "geometry": [
                "coordinates": [
                    "lat": latitude,
                    "long": longitude
                ]
            ]
        ]
        
        do {
            // serialize json
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
            guard let URL = URL(string: POST_FOODTRUCK) else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                if(error == nil) {
                    // success
                    // check for status code 200 for successful auth
                    // if it is 200 we're done
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        self.getAllFoodtrucks()
                        completion(true)
                    }
                }
                else {
                    print("URL Session Task Failed: \(error?.localizedDescription)")
                    completion(false)
                }
                })
            task.resume()
            session.finishTasksAndInvalidate()
        
        } catch let err {
            completion(false)
            print(err)
        }
        
    }
    
    
    // post foodtruck review
    func addNewReview(_ foodtruckId: String, title: String, text: String, completion: @escaping callback) {
        let json: [String: Any] = [
            "title": title,
            "text": text,
            "forFoodtruck": foodtruckId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: "\(POST_REVIEW)/\(foodtruckId)") else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"

            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
        
            let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                if(error == nil) {
                    // success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    
                    if statusCode != 200 {
                        completion(false)
                        return
                    }
                    else {
                        print("URL Session Task Failed")
                        completion(true)
                    }
                }
                else {
                    completion(false)
                }
                })
            task.resume()
            session.finishTasksAndInvalidate()
        }
        catch let err {
            print(err)
        }
    }
    
}
