//
//  CountryData.swift
//  CovidTracker
//
//  Created by ERNEST MURIUKI on 04/10/2021.
//

import Foundation

struct CountryData: Codable{
    var country: String
    var countryInfo: CountryInfo?
    var cases: Int
    var todayCases: Int
    var deaths: Int
    var todayDeaths: Int
    var recovered: Int
    var active: Int
    var critical: Int
    var casesPerOneMillion: Int
    var deathsPerOneMillion: Int
    var tests: Int
    var testsPerOneMillion: Int
    var continent: String
}

struct CountryInfo: Codable{
    var _id: Int
    var iso2: String
    var iso3: String
    var lat: Int
    var long: Int
    var flag: String
}
