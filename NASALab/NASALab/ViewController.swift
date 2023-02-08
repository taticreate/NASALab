//
//  ViewController.swift
//  NASALab
//
//  Created by Tati on 2/3/23.
//

import UIKit

struct Constants {
    
    //api details
    static let API_KEY = "DEMO_KEY"
    static let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers"
    
    //data formatter
    static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var roverName: UIPickerView!
    
    @IBOutlet weak var date: UIDatePicker!
    
    @IBOutlet weak var imgCount: UILabel!
    
    @IBOutlet weak var imgList: UIPickerView!
    
    var photos = [Photo]()
    let rovers = ["Opportunity", "Curiosity", "Spirit"]
    var selectedRover: String?
    var selectedDate: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set data source and delegate
        roverName.dataSource = self
        roverName.delegate = self

        imgList.dataSource = self
        imgList.delegate = self
        
        //date change trigger
        date.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        imgCount.text = "Number of Photos: \(photos.count)"
    }
    
    //method to handle event
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        selectedDate = formatter.string(from: date.date)
        
        //retrieve photos with rover and data
        if let selectedRover = selectedRover, let selectedDate = selectedDate {
            retrievePhotos(for: selectedRover, on: selectedDate)
        }
    }


    // UIPickerViewDataSource methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == roverName {
            return rovers.count
        } else if pickerView == imgList {
            return photos.count
        } else {
            return 0
        }
    }
    
    //return ID of the photos
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == roverName {
            return rovers[row]
        } else if pickerView == imgList {
            return String(photos[row].id)
        } else {
            return nil
        }
    }

    //trigger setup to retrieve photos
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == roverName {
            let selectedRover = rovers[row]
            let formattedDate = Constants.dateFormatter.string(from: date.date)
            retrievePhotos(for: selectedRover, on: formattedDate)
        } else if pickerView == imgList {
            //load photo to mainImage UIImage
            let selectedPhoto = photos[row]
            mainImage.loadImage(from: selectedPhoto.img_src)
        }
    }
    //method for retrieving photos
    func retrievePhotos(for roverName: String, on date: String) {
        //use fetchdata method
        Networking.shared.fetchData(rover: roverName, date: date) { [self] (result: Result<PhotoDisplay, Error>) in
            switch result {
            case .success(let photoDisplay):
                
                // reload to show the updated list of photo IDs
                DispatchQueue.main.async {
                    self.photos = photoDisplay.photos
                self.imgList.reloadAllComponents()
                //count the number of photos in the picker
                self.imgCount.text = "Number of Photos: \(self.photos.count)"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//retrieve image data asynchronously
extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                    self?.image = image
                    }
                }
            }
        }
    }
}
