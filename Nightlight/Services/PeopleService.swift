import Foundation

public protocol PeopleServiced {
    var peopleService: PeopleService { get }
}

public class PeopleService {
    
    private let httpClient: HttpClient
    
    private var filterTask: URLSessionDataTask?
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    public func getHelpfulPeople(result: @escaping (Result<[User], PersonError>) -> Void) {
        httpClient.get(endpoint: Endpoint.helpfulUsers) { networkResult in
            switch networkResult {
            case .success(_, let data):
                guard let peopleResponse: [User] = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(peopleResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
        }
    }
    
    public func getPeople(filter: String, start: String?, end: String?, result: @escaping (Result<PaginatedResponse<User>, PersonError>) -> Void) {
        if let task = filterTask {
            task.cancel()
        }
        
        filterTask = httpClient.get(endpoint: Endpoint.users(filter: filter, start: start, end: end), result: { [weak self] networkResult in
            self?.filterTask = nil

            switch networkResult {
            case .success(_, let data):
                guard let peopleResponse: PaginatedResponse<User> = try? data.decodeJSON() else {
                    return result(.failure(.unknown))
                }
                
                result(.success(peopleResponse))
                
            case .failure:
                result(.failure(.unknown))
            }
        })
    }

}
