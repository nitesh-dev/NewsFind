
import Foundation
import Moya

public enum EverythingAPI {
    static private let apikey = "8feb6ea136944606bea846fa02de6581"
    
    case domain(dm: String, query: String)
}
//https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=API_KEY
extension EverythingAPI : TargetType
{
    public var baseURL: URL {
        switch self
        {
        case .domain:
            return URL(string: "https://newsapi.org/v2/everything")!
        }
        
    }
    public var path: String {
        switch self {
        case .domain:
            return ""
        }
    }
    public var method: Moya.Method {
        switch self {
        case .domain:
            return .get
        }
    }
    public var sampleData : Data {
        return Data()
    }
    public var task: Task {
        switch self
        {
        case .domain(let dm, let query):
            let authParams = ["q": query, "domains": dm, "apiKey": EverythingAPI.apikey] as [String : Any]
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        }
        
    }
    
    public var headers: [String: String]?
    {
        return ["Content-type": "application/json"]
    }
}


