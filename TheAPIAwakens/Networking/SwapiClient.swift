//
//  SwapiClient.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 12/21/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

class SwapiClient {

    lazy var baseUrl: URL = {
        return URL(string: "https://swapi.co")!
    }()
    
    var resultsArray = [SWEntity]()
    var pageNumber = 1
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias GenericCompletionHandler<T: SWEntity> = (T?, Error?) -> Void
    typealias SWEntityCompletionHandler = ([SWEntity]?, Error?) -> Void
    
    
    // Makes Swapi API requests based on the type of Star Wars entity passed in.
    // The completion handler returns an array of Star Wars entities, or an error.
    // The results of each request are appended to the resultsArray.
    // The request will repeat recursively until all entities of the designated type have been returned.
    // Errors will be returned by the completion handler in case the device is offline or json data cannot be parsed.
    private func getSwapiData(for requestType: SWEntityType, completion: @escaping SWEntityCompletionHandler) {
        
        guard let url = URL(string: "\(requestType.resource)\(pageNumber)", relativeTo: baseUrl) else {
            completion(nil, SwapiError.invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, SwapiError.requestFailed)
                    return
                }
                if httpResponse.statusCode == 200 {
                    do {
                        var count = 0
                        
                        switch requestType {
                        case .characters:
                            let results = try self.decoder.decode(CharacterResults.self, from: data)
                            self.resultsArray.append(contentsOf: results.characters)
                            self.pageNumber += 1
                            count = results.count
                        case .vehicles:
                            let results = try self.decoder.decode(VehicleResults.self, from: data)
                            self.resultsArray.append(contentsOf: results.vehicles)
                            self.pageNumber += 1
                            count = results.count
                        case .starships:
                            let results = try self.decoder.decode(StarshipResults.self, from: data)
                            self.resultsArray.append(contentsOf: results.starships)
                            self.pageNumber += 1
                            count = results.count
                        }
                        if self.resultsArray.count == count {
                            DispatchQueue.main.async {
                                self.pageNumber = 1
                                completion(self.resultsArray, nil)
                            }
                        } else {
                            self.getSwapiData(for: requestType) { results, error in
                                if self.resultsArray.count == count {
                                    DispatchQueue.main.async {
                                        self.pageNumber = 1
                                        completion(self.resultsArray, nil)
                                    }
                                }
                            }
                        }
                    } catch {
                        completion(nil, SwapiError.jsonParsingFailure)
                    }
                } else {
                    completion(nil, SwapiError.responseUnsuccesful(statusCode: httpResponse.statusCode))
                }
            } else {
                completion(nil, SwapiError.invalidData)
            }
        }
        task.resume()
    }
    
    // Makes Swapi API requests based on the urlString passed in.
    // The completion handler returns a Star Wars entity, or an error.
    private func getGenericSwapiData<T: SWEntity>(for urlString: String, completionHandler completion: @escaping GenericCompletionHandler<T>) {
        guard let url = URL(string: urlString) else {
            completion(nil, SwapiError.invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, SwapiError.requestFailed)
                        return
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let result = try self.decoder.decode(T.self, from: data)
                            completion(result, nil)
                        } catch {
                            completion(nil, SwapiError.jsonParsingFailure)
                        }
                    } else {
                        completion(nil, SwapiError.responseUnsuccesful(statusCode: httpResponse.statusCode))
                    }
                } else {
                    completion(nil, SwapiError.invalidData)
                }
            }
        }
        task.resume()
    }

    // Calls the private method - getSwapiData.
    func getData(for requestType: SWEntityType, completionHandler completion: @escaping SWEntityCompletionHandler) {
            getSwapiData(for: requestType) { results, error in
                completion(results, error)
            }
    }

    // Calls the private method - getGenericSwapiData.
    func getData<T: SWEntity>(for urlString: String, completionHandler completion: @escaping GenericCompletionHandler<T>) {
        getGenericSwapiData(for: urlString) { result, error in
            completion(result, error)
        }
    }
    
}
