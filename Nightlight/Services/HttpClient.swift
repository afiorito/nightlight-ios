import Foundation

public class HttpClient {
    public typealias RequestResult = Result<(HTTPURLResponse, Data), Error>

    private let urlSession: URLSession
    
    enum HttpMethod: String {
        case get
        case post, put
        case delete
    }
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    @discardableResult
    public func request(urlRequest: URLRequest, result: @escaping (RequestResult) -> Void) -> URLSessionDataTask? {
        let task = urlSession.dataTask(with: urlRequest) { taskResult in
            switch taskResult {
            case .success(let response, let data):
                guard let response = response as? HTTPURLResponse, let data = data else {
                    return result(.failure(NetworkError.badResponse))
                }
                
                if response.statusCode >= 300 {
                    return result(.failure(HttpError(value: response.statusCode, reason: data)))
                }
                
                result(.success((response, data)))
                
            case .failure(let error):
                result(.failure(error))
                
            }
        }
        
        task.resume()
        
        return task
    }
    
    @discardableResult
    public func get(endpoint: Endpoint, result: @escaping (RequestResult) -> Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            result(.failure(NetworkError.badURL))
            return nil
        }
        
        return request(urlRequest: urlRequest(for: url, method: .get), result: result)
    }
    
    @discardableResult
    public func post(endpoint: Endpoint, body: Data?, result: @escaping (RequestResult) -> Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            result(.failure(NetworkError.badURL))
            return nil
        }
        
        var urlRequest = self.urlRequest(for: url, method: .post)
        urlRequest.httpBody = body
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        return request(urlRequest: urlRequest, result: result)
    }
    
    @discardableResult
    public func put(endpoint: Endpoint, body: Data?, result: @escaping (RequestResult) -> Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            result(.failure(NetworkError.badURL))
            return nil
        }
        
        var urlRequest = self.urlRequest(for: url, method: .put)
        urlRequest.httpBody = body
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return request(urlRequest: urlRequest, result: result)
    }
    
    @discardableResult
    public func delete(endpoint: Endpoint, result: @escaping (RequestResult) -> Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            result(.failure(NetworkError.badURL))
            return nil
        }
        
        return request(urlRequest: urlRequest(for: url, method: .delete), result: result)
    }
    
    private func urlRequest(for url: URL, method: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        
        return request
    }
}
