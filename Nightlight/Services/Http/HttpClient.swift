import Foundation
import UIKit

/// A client for making HTTP requests.
public class HttpClient {
    public typealias RequestResult = Result<(HTTPURLResponse, Data), Error>
    private let urlSession: URLSession
    
    /// A constant for denoting the HTTP method.
    enum HttpMethod: String {
        case get
        case post, put
        case head
        case delete
    }
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /**
     Send an HTTP request.
     
     All status codes greater than 299 are considered errors.
     
     - parameter urlRequest: the url request to send.
     - parameter result: the result of the HTTP request.
     */
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
    
    // MARK: - REST Methods
    
    /**
     Send an HTTP GET request.
     
     - parameter endpoint: the endpoint to send a GET request to.
     - parameter result: the result of the HTTP GET request.
     */
    @discardableResult
    public func get(endpoint: Endpoint, result: @escaping (RequestResult) -> Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            result(.failure(NetworkError.badURL))
            return nil
        }
        
        return request(urlRequest: urlRequest(for: url, method: .get), result: result)
    }
    
    /**
     Send a HTTP POST request.
     
     - parameter endpoint: the endpoint to send a POST request to.
     - parameter body: the body of the POST request.
     - parameter result: the result of the HTTP POST request.
     */
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
    
    /**
     Send a HTTP PUT request.
     
     - parameter endpoint: the endpoint to send a PUT request to.
     - parameter body: the body of the PUT request.
     - parameter result: the result of the HTTP PUT request.
     */
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
    
    /**
     Send an HTTP DELETE request.
     
     - parameter endpoint: the endpoint to send a DELETE request to.
     - parameter result: the result of the HTTP DELETE request.
     */
    @discardableResult
    public func delete(endpoint: Endpoint, result: @escaping (RequestResult) -> Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            result(.failure(NetworkError.badURL))
            return nil
        }
        
        return request(urlRequest: urlRequest(for: url, method: .delete), result: result)
    }
    
    /**
     Send an HTTP HEAD request.
     
     - parameter endpoint: the endpoint to send a HEAD request to.
     - parameter result: the result of the HTTP HEAD request.
     */
    @discardableResult
    public func head(endpoint: Endpoint, result: @escaping (RequestResult) -> Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            result(.failure(NetworkError.badURL))
            return nil
        }
        
        return request(urlRequest: urlRequest(for: url, method: .head), result: result)
    }
    
    /**
     Format a url and HTTP method into a url request.
     
     - parameter url: the url of the url request.
     - parameter method: the HTTP method of the request.
     */
    private func urlRequest(for url: URL, method: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        
        return request
    }
}
