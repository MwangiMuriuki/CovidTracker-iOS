//
//  ViewController.swift
//  CovidTracker
//
//  Created by ERNEST MURIUKI on 10/09/2021.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var serverurl: String = ""
    let service = ServiceCaller()
    var countryData = [CountryData]()
    var countryDataList : CountryData?
    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        setupTableView()
        setupActivityIndicator()
        fetchCountryData()
    }
    
    func setupTableView(){
        tableView?.register(CountriesTableViewCell.self, forCellReuseIdentifier: "countriesTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupActivityIndicator(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7041453178)
        activityIndicator.color = .white
        activityIndicator.layer.cornerRadius = 10
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func fetchCountryData(){
        activityIndicator.startAnimating()
        serverurl = Config.BASE_URL + Config.COUNTRY_ENDPOINT
        service.makeRequest(url: serverurl, requestBody: nil, method: .get)
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countriesTableViewCell", for: indexPath) as! CountriesTableViewCell
        
        return cell
    }
    
}

extension ViewController: ServiceCallerDelegate{
    
    func successResponse(response: Data) {
        activityIndicator.stopAnimating()
        do {
            let response = try? JSONDecoder().decode(CountryData.self, from: response)
            print("GResp: ",response)
            
            self.countryDataList = response
            
        }
        catch let DecodingError.dataCorrupted(context) {
            activityIndicator.stopAnimating()
            print("GymContextError: ", context)
        } catch let DecodingError.keyNotFound(key, context) {
            activityIndicator.stopAnimating()
            print("Key '\(key)' not found:", context.debugDescription)
            print("GymcodingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            activityIndicator.stopAnimating()
            print("Value '\(value)' not found:", context.debugDescription)
            print("GymcodingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            activityIndicator.stopAnimating()
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("GymcodingPath:", context.codingPath)
        } catch {
            activityIndicator.stopAnimating()
            print("Gymerror: ", error)
        }
        
    }
    
    func errorResponse(error: String) {
        activityIndicator.stopAnimating()
    }
}

