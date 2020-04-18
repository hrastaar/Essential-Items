//
//  CovidDataView.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/9/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import SwiftUI



// Purpose of this view: show live covid data
struct CovidDataView: View {
    var covidData = CovidData()
    
    var body: some View {
        VStack {
            Text("\(covidData.confirmedCount) confirmed cases")
                .font(.custom("customBold", size: 18))
                        
            Text("\(covidData.criticalCount) critical cases")
                .font(.custom("customRegular", size: 18))

            Text("\(covidData.deathCount) deaths")
                .font(.custom("customBold", size: 18))

            Text("\(covidData.recoveredCount) recovered patients")
                .font(.custom("customRegular", size: 18))

        }
    }
}

struct CovidDataView_Previews: PreviewProvider {
    static var previews: some View {
        CovidDataView()
            .environment(\.colorScheme, .dark)
    }
}
