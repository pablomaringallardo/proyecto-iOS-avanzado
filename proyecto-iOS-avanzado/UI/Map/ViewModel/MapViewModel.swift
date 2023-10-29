//
//  MapViewModel.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 27/10/23.
//

import Foundation
import MapKit

class MapViewModel: MapViewControllerDelegate {
    
//    MARK: - Dependencies -
    var viewState: ((MapViewState) -> Void)?
    var networkManager = NetworkManager()
    var secureDataManager = SecureDataManager()
    
    var locationsHeros: [LocationDAO] = []
    
//    MARK: - Initializers -
    init(
        networkManager: NetworkManager = NetworkManager(),
        secureDataManager: SecureDataManager = SecureDataManager()
    ) {
        self.networkManager = networkManager
        self.secureDataManager = secureDataManager
    }
    
//    MARK: - Public functions -
    func onViewAppear() {
        self.getLocations()
        self.viewState?(.update(locations: locationsHeros))
    }
    
    func getLocations() {
        if Global.shared.getLocationsCoreData(context: Global.shared.context).isEmpty {
            let heroes = Global.shared.getHeroesCoreData(context: Global.shared.context)
            guard let token = secureDataManager.getToken() else { return }
            heroes.forEach {
                networkManager.getLocations(
                    heroId: $0.id,
                    token: token) { locations in
                        locations.forEach {
                            let newLocation = LocationDAO(context: Global.shared.context)
                            newLocation.id = $0.id
                            newLocation.date = $0.dateShow
                            newLocation.latitude = $0.latitud
                            newLocation.longitude = $0.longitud
                            self.locationsHeros.append(newLocation)
                            Global.shared.saveCoreData()
                        }
                    }
            }
            
            print("API MAP")
            
        } else {
            self.locationsHeros = Global.shared.getLocationsCoreData(context: Global.shared.context)
            print("COREDATA MAP")
        }
    }
    
}
