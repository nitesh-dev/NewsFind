
import Foundation
import Moya

public enum TrendingAPI {
    static private let apikey = "8feb6ea136944606bea846fa02de6581"
    
    case country(ccode: String, ctgry: String)
    case query(qry: String)
    case source
}
//https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=8feb6ea136944606bea846fa02de6581
extension TrendingAPI : TargetType
{
    public var baseURL: URL {
        switch self
        {
        case .country:
            return URL(string: "https://newsapi.org/v2/top-headlines")!
        case .query:
            return URL(string: "https://newsapi.org/v2/top-headlines")!
        case .source:
            return URL(string: "https://newsapi.org/v2/sources")!
        }
        
    }
    public var path: String {
        switch self {
        case .country:
            return ""
        case .query:
            return ""
        case .source:
            return ""
        }
    }
    public var method: Moya.Method {
        switch self {
        case .country:
            return .get
        case .query:
            return .get
        case .source:
            return .get
        }
    }
    public var sampleData : Data {
        return Data()
    }
    public var task: Task {
        switch self
        {
        case .country(let ccode, let category):
            var authParams = [String: Any]()
            if category == ""
            {
            authParams = ["country": ccode,  "apiKey": TrendingAPI.apikey] as [String : Any]
            }
            else
            {
            authParams = ["country": ccode, "category": category, "apiKey": TrendingAPI.apikey] as [String : Any]
            }
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        case .query(let qry):
            let authParams = ["q": qry, "apiKey": TrendingAPI.apikey] as [String : Any]
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        case .source:
            let authParams = ["apiKey": TrendingAPI.apikey] as [String : Any]
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        }
        
    }
    
    public var headers: [String: String]?
    {
        return ["Content-type": "application/json"]
    }
    
}

