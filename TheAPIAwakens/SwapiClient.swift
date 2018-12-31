//
//  SwapiClient.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 12/21/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

class SwapiClient {

    enum RequestType {
        case characters(page: Int)
        case vehicles(page: Int)
        case starships(page: Int)
        case planets(id: Int)

        var description: String {
            switch self {
            case .characters(let page): return "/api/people/?page=\(page)"
            case .vehicles(let page): return "/api/vehicles/?page=\(page)"
            case .starships(let page): return "/api/starships/?page=\(page)"
            case .planets(let id): return "/api/planets/\(id)"
            }
        }
    }

    lazy var baseUrl: URL = {
        return URL(string: "https://swapi.co")!
    }()
    
    var resultsArray = [SWEntity]()
    var stop: Bool = false
    var pageNumber = 1
    
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias GenericCompletionHandler<T: Codable> = (T?, Error?) -> Void
    typealias PlanetCompletionHandler = (Planet?, Error?) -> Void
    typealias VehicleCompletionHandler = (Vehicle?, Error?) -> Void
    typealias StarshipsCompletionHandler = (Starship?, Error?) -> Void
    typealias SWEntityCompletionHandler = ([SWEntity]?, Error?) -> Void
    
    private func getSwapiData(for requestType: SWEntityType, completion: @escaping SWEntityCompletionHandler) {
        
        guard let url = URL(string: "\(requestType.description)\(pageNumber)", relativeTo: baseUrl) else {
            completion(nil, SwapiError.invalidUrl)
            return
        }
        //print(url)
        
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
                                //print(self.pageCount)
                                completion(self.resultsArray, nil)
                            }
                        } else {
                            self.getSwapiData(for: requestType) { results, error in
                                if self.resultsArray.count == count {
                                    DispatchQueue.main.async {
                                        //print(self.pageCount)
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
    
//    func getGSwapiData<T: Codable>(for requestType: SWEntityType, page: Int, completion: @escaping (T?, Error?) -> Void) {
//
//        guard let url = URL(string: "\(requestType.description)\(page)", relativeTo: baseUrl) else {
//            completion(nil, SwapiError.invalidUrl)
//            return
//        }
//        print(url)
//
//        let request = URLRequest(url: url)
//        let task = session.dataTask(with: request) { data, response, error in
//
//            DispatchQueue.main.async {
//                if let data = data {
//                    guard let httpResponse = response as? HTTPURLResponse else {
//                        completion(nil, SwapiError.requestFailed)
//                        return
//                    }
//                    print(httpResponse.statusCode)
//                    if httpResponse.statusCode == 200 {
//                        do {
//
//                            let results = try self.decoder.decode(T.self, from: data)
//                            print(results)
//
//                            completion(results, nil)
//
//                        } catch {
//                            completion(nil, SwapiError.jsonParsingFailure)
//                        }
//                    } else {
//                        completion(nil, SwapiError.responseUnsuccesful(statusCode: httpResponse.statusCode))
//                    }
//                } else {
//                    completion(nil, SwapiError.invalidData)
//                }
//            }
//        }
//        task.resume()
//    }
    
    private func getGenericSwapiData<T: Codable>(for urlString: String, completionHandler completion: @escaping GenericCompletionHandler<T>) {
        guard let url = URL(string: urlString) else {
            completion(nil, SwapiError.invalidUrl)
            return
        }
        //print("\(url)")
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, SwapiError.requestFailed)
                        return
                    }
                    //print(httpResponse.statusCode)
                    if httpResponse.statusCode == 200 {
                        do {
                            let result = try self.decoder.decode(T.self, from: data)
                            //print(results)
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

    func getData(for requestType: SWEntityType, completionHandler completion: @escaping SWEntityCompletionHandler) {
            getSwapiData(for: requestType) { results, error in
                completion(results, error)
            }
    }

    func getData<T: Codable>(for urlString: String, completionHandler completion: @escaping GenericCompletionHandler<T>) {
        getGenericSwapiData(for: urlString) { result, error in
            completion(result, error)
        }
    }
}
