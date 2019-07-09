import Foundation

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse?, Data?), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                return result(.failure(error))
            }
            
            result(.success((response, data)))
        }
    }
    
    func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse?, Data?), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return result(.failure(error))
            }
            
            result(.success((response, data)))
        }
    
    }
}
