import Foundation

struct Review {
    var id: String = ""
    var title: String = ""
    var text: String = ""
    
    static func parseReviewJSONData(data: Data) -> [Review] {
        var reviews = [Review]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // parse JSON data
            if let foodtruck_reviews = jsonResult as? [Dictionary<String, AnyObject>] {
                for review in foodtruck_reviews {
                    var newReview = Review()
                    newReview.id = review["_id"] as! String
                    newReview.title = review["title"] as! String
                    newReview.text = review["text"] as! String
                    
                    reviews.append(newReview)
                }
            }
        } catch let err {
            print(err)
        }
        
        return reviews
    }
}
