
import Foundation
import Moya

public enum OpenWeatherAPI {
    static private let apikey = "8f48d654880701b7425d91a301ee81ac"
    case weather(lat: Double, lon: Double)
    case box
}
//api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}
extension OpenWeatherAPI : TargetType
{
    public var baseURL: URL {
        switch self
        {
        case .weather:
            return URL(string: "https://api.openweathermap.org/data/2.5/weather")!
        case .box:
            return URL(string: "https://api.openweathermap.org/data/2.5/weather")!
        }
        
    }
    public var path: String {
        switch self {
        case .weather:
            return ""
        case .box:
            return ""
        }
    }
    public var method: Moya.Method {
        switch self {
        case .weather:
            return .get
        case .box:
            return .get
        }
    }
    public var sampleData : Data {
        return Data()
    }
    public var task: Task {
        switch self
        {
        case .weather(let lat, let long):
            let authParams = ["lat": lat, "lon": long, "appid": OpenWeatherAPI.apikey] as [String : Any]
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        case .box:
            let authParams = ["q": "London"] as [String : Any]
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        }
        
    }
    
    public var headers: [String: String]?
    {
        return ["Content-type": "application/json"]
    }
    
}


