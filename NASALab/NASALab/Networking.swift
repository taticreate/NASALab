//
//  Networking.swift
//  NASALab
//
//  Created by Tati on 2/3/23.
//

import Foundation

class Networking {
    
    //initialize instance
    static var shared = Networking()
    
    //function to get data with rover and data paramaters
    func fetchData(rover: String, date: String, completion: @escaping (Result<PhotoDisplay, Error>) -> Void) {

        
        //concatenating constants and variables
        let urlString = ("\(Constants.baseURL)/\(rover)/photos?api_key=\(Constants.API_KEY)&earth_date=\(date)")
        //checking url
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        // checking fetching of data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }
            
            //decoding json data
            do {
                let decodedData = try JSONDecoder().decode(PhotoDisplay.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum NetworkingError: Error {
    case invalidURL
    case noData
}
