import Foundation

typealias callback = (_ success: Bool) -> ()

// base url
let BASE_API_URL = "http://foodtruck.date:3005/api/v1"

// get
let GET_ALL_FOODTRUCKS = "\(BASE_API_URL)/foodtruck"
let GET_ALL_REVIEWS_FOR_ONE_FOODTRUCK = "\(BASE_API_URL)/foodtruck/reviews"

// post
let POST_FOODTRUCK = "\(BASE_API_URL)/foodtruck/add"
let POST_REVIEW = "\(BASE_API_URL)/foodtruck/reviews/add"

// bool auth UserDefaults keys
let DEFAULTS_REGISTERED = "isRegistered"
let DEFAULTS_AUTHENTICATED = "isAuthenticated"

// auth email
let DEFAULTS_EMAIL = "email"

// auth token
let DEFAULTS_TOKEN = "authToken"

// auth register and login
let POST_REGISTER_URL = "\(BASE_API_URL)/accounts/register"
let POST_LOGIN_URL = "\(BASE_API_URL)/accounts/login"
