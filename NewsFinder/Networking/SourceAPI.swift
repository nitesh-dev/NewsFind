
import Foundation
import Moya

public enum SourceAPI {
    static private let apikey = "8feb6ea136944606bea846fa02de6581"
    
    case countryWise(ccode: String, language: String)
    case languageWise(qry: String)
    case source
}
//https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=8feb6ea136944606bea846fa02de6581
extension SourceAPI : TargetType
{
    public var baseURL: URL {
        switch self
        {
        case .countryWise, .languageWise, .source:
            return URL(string: "https://newsapi.org/v2/sources")!
        }
    }
    public var path: String {
        switch self {
        case .countryWise:
            return ""
        case .languageWise:
            return ""
        case .source:
            return ""
        }
    }
    public var method: Moya.Method {
        switch self {
        case .countryWise:
            return .get
        case .languageWise:
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
        case .countryWise(let ccode, let language):
            var authParams = [String: Any]()
            if language == ""
            {
                authParams = ["country": ccode,  "apiKey": SourceAPI.apikey] as [String : Any]
            }
            else
            {
                authParams = ["language": language, "country": ccode, "apiKey": SourceAPI.apikey] as [String : Any]
            }
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        case .languageWise(let language):
            let authParams = ["language": language, "apiKey": SourceAPI.apikey] as [String : Any]
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        case .source:
            let authParams = ["apiKey": SourceAPI.apikey] as [String : Any]
            return .requestParameters(
                parameters: authParams, encoding: URLEncoding.default)
        }
        
    }
    
    public var headers: [String: String]?
    {
        return ["Content-type": "application/json"]
    }
    
}


