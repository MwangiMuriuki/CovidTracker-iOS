//
//  ViewController.swift
//  CovidTracker
//
//  Created by ERNEST MURIUKI on 10/09/2021.
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var serverUrl: String = ""
    let service = ServiceCaller()
    var countryData = [CountryData]()
    var countryDataList : CountryData?
    var globalData: GlobalDataClass?
    
    var casesData = PieChartDataEntry(value: 0, label: "Total Cases")
    var deathsData = PieChartDataEntry(value: 0, label: "Total Deaths")
    var activeCasesData = PieChartDataEntry(value: 0, label: "Active Cases")
    var recoveriesData = PieChartDataEntry(value: 0, label: "Recoveries")
    
    var combinedData = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        pieChart.delegate = self
        setupChart()
        setupTableView()
        setupActivityIndicator()
        fetchGlobalData()
//        fetchCountryData()
    }
    
   
    func setupChart(){
        let legend = pieChart.legend
        legend.textColor = .black
        pieChart.entryLabelColor = .clear
        pieChart.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
       // pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        pieChart.animate(yAxisDuration: 2.8)
        pieChart.holeRadiusPercent = 0.4
        pieChart.transparentCircleRadiusPercent = 0.55
        pieChart.dragDecelerationEnabled = true
        pieChart.dragDecelerationFrictionCoef = 0.98
        
    }
    
    func updateChartData(){
        
        let chartDataSet = PieChartDataSet(entries: combinedData, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named: "colorTotalCases"),
                      UIColor(named: "colorTotalDeaths"),
                      UIColor(named: "colorActiveCases"),
                      UIColor(named: "colorRecovered")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
        
        //Fetch Country Data after Global Data is set
        fetchCountryData()
        
    }
    
    func setupTableView(){
        let nib = UINib(nibName: "CountriesTableViewCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "countriesTableViewCell")
        tableView?.rowHeight = 55
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
    
    func fetchGlobalData(){
        activityIndicator.startAnimating()
        serverUrl = Config.GLOBAL_ENDPOINT
        service.makeRequest(url: serverUrl, requestBody: nil, method: .get)
    }
    
    func fetchCountryData(){
        activityIndicator.startAnimating()
        serverUrl = Config.COUNTRY_ENDPOINT
        service.makeRequest(url: serverUrl, requestBody: nil, method: .get)
    }
    
    // MARK: - Global Data Response
    func globalDataResponse(resp: Data){
        self.activityIndicator.stopAnimating()
        do {
            let gDataResp = try JSONDecoder().decode(GlobalDataClass.self, from: resp)
            globalData = gDataResp
            
            print("GDataList: \(globalData)")
            
            casesData.value = (globalData?.cases)!
            deathsData.value = (globalData?.deaths)!
            activeCasesData.value = (globalData?.active)!
            recoveriesData.value = (globalData?.recovered)!
            
            combinedData = [casesData, deathsData, activeCasesData, recoveriesData]
            updateChartData()

        }
        catch let DecodingError.dataCorrupted(context) {
            activityIndicator.stopAnimating()
            print("GDContextError: ", context)
            fetchCountryData()
        } catch let DecodingError.keyNotFound(key, context) {
            activityIndicator.stopAnimating()
            print("Key '\(key)' not found:", context.debugDescription)
            print("GDcodingPath:", context.codingPath)
            fetchCountryData()
        } catch let DecodingError.valueNotFound(value, context) {
            activityIndicator.stopAnimating()
            print("Value '\(value)' not found:", context.debugDescription)
            print("GDcodingPath:", context.codingPath)
            fetchCountryData()
        } catch let DecodingError.typeMismatch(type, context)  {
            activityIndicator.stopAnimating()
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("GDcodingPath:", context.codingPath)
            fetchCountryData()
        } catch {
            activityIndicator.stopAnimating()
            print("GDerror: ", error)
            fetchCountryData()
        }
    }
    
    // MARK: - Country Data Response
    func countryDataResponse(response: Data){
        do {
            let resp = try JSONDecoder().decode([CountryData].self, from: response)
            countryData = resp
            print("DataList: \(countryData)")
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }

        }
        catch let DecodingError.dataCorrupted(context) {
            activityIndicator.stopAnimating()
            print("CDContextError: ", context)
        } catch let DecodingError.keyNotFound(key, context) {
            activityIndicator.stopAnimating()
            print("Key '\(key)' not found:", context.debugDescription)
            print("CDcodingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            activityIndicator.stopAnimating()
            print("Value '\(value)' not found:", context.debugDescription)
            print("CDcodingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            activityIndicator.stopAnimating()
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("CDcodingPath:", context.codingPath)
        } catch {
            activityIndicator.stopAnimating()
            print("CDerror: ", error)
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countriesTableViewCell", for: indexPath) as! CountriesTableViewCell
        
        let countryDataList = countryData[indexPath.row]
        cell.populateCountryData(with: countryDataList)
        //cell.countryNameLabel.text = countryDataList.country
        return cell
    }
    
}

extension ViewController: ServiceCallerDelegate{
    
    func successResponse(response: Data) {
        
        if serverUrl == Config.GLOBAL_ENDPOINT {
            globalDataResponse(resp: response)
        }
        else if serverUrl == Config.COUNTRY_ENDPOINT{
            countryDataResponse(response: response)
        }
        
//
//        self.activityIndicator.stopAnimating()
//        do {
//            let gDataResp = try JSONDecoder().decode(GlobalDataClass.self, from: response)
//            globalData = gDataResp
//
//            print("GDataList: \(globalData)")
//
//            casesData.value = (globalData?.cases)!
//            deathsData.value = (globalData?.deaths)!
//            activeCasesData.value = (globalData?.active)!
//            recoveriesData.value = (globalData?.recovered)!
//
//            combinedData = [casesData, deathsData, activeCasesData, recoveriesData]
//            updateChartData()
//
//        }
//        catch let DecodingError.dataCorrupted(context) {
//            activityIndicator.stopAnimating()
//            print("GDContextError: ", context)
//        } catch let DecodingError.keyNotFound(key, context) {
//            activityIndicator.stopAnimating()
//            print("Key '\(key)' not found:", context.debugDescription)
//            print("GDcodingPath:", context.codingPath)
//        } catch let DecodingError.valueNotFound(value, context) {
//            activityIndicator.stopAnimating()
//            print("Value '\(value)' not found:", context.debugDescription)
//            print("GDcodingPath:", context.codingPath)
//        } catch let DecodingError.typeMismatch(type, context)  {
//            activityIndicator.stopAnimating()
//            print("Type '\(type)' mismatch:", context.debugDescription)
//            print("GDcodingPath:", context.codingPath)
//        } catch {
//            activityIndicator.stopAnimating()
//            print("GDerror: ", error)
//        }
        
    }
    
    func errorResponse(error: String) {
        activityIndicator.stopAnimating()
    }
}



