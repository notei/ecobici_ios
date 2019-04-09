//
//  EstacionDetalleViewController.swift
//  EcobiciAFA
//
//  Created by Alberto Farías on 4/5/19.
//  Copyright © 2019 Alberto Farías. All rights reserved.
//

import UIKit
import GoogleMaps

class EstacionDetalleViewController: UIViewController, GMSMapViewDelegate  {
    
    
    var estaciones:StationsList!
    var estacion:Station!
    var status:StationsStatus?
    
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtDireccion: UILabel!
    @IBOutlet weak var txtColonia: UILabel!
    @IBOutlet weak var txtBicicletas: UILabel!
    @IBOutlet weak var txtSlots: UILabel!
    @IBOutlet weak var txtStatus: UILabel!
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    var markerActual:GMSMarker!
    var markers:[GMSMarker] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //SEtup navigation bar
        AppUtils.setupNavBarApp(navigationItem: self.navigationItem, navigationController: self.navigationController!)
    
        setupUI()
       
        let camera = GMSCameraPosition.camera(withLatitude: estacion.location.lat, longitude: estacion.location.lon, zoom: 20.0)
        //viewMap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        viewMap.camera = camera
        viewMap.delegate = self
       
        //Pone todos los marcadores
         setupAllMarkers()
        
        //Pone el marcador seleccionado
        setupSelectedMarker(estacion: estacion)
       
        
    }

    
    func setup( estacion:Station, estaciones:StationsList){
        self.estacion = estacion
        self.estaciones = estaciones
    }
    
    
    
    //Asigna la estacion actual
    private func setupSelectedMarker(estacion:Station){
        //Quita la marca del marker actual
        if(markerActual != nil){
            markerActual.map = nil
        }
        // Creates a marker in the center of the map.
        markerActual = GMSMarker()
        markerActual.position = CLLocationCoordinate2D(latitude: estacion.location.lat, longitude: estacion.location.lon)
        markerActual.title = estacion.name
        markerActual.snippet = estacion.districtName
        markerActual.userData = estacion.id
        markerActual.map = viewMap
        markerActual.icon = UIImage(named: "ico_target_selected")
        
        let camera = GMSCameraPosition.camera(withLatitude: estacion.location.lat, longitude: estacion.location.lon, zoom: 17.0)
        
        viewMap.animate(to: camera)
        //Actualiza la vista
        setupUI()
    }
    
    
    //Pone todos los marcadores
    private func setupAllMarkers(){
        for estacion in estaciones.stations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: estacion.location.lat, longitude: estacion.location.lon)
            marker.title = estacion.name
            marker.snippet = estacion.districtName
            marker.map = viewMap
            marker.icon = UIImage(named: "ico_target")
            marker.userData = estacion.id
            markers.append(marker)
        }
    }
    
    
    //Seleccionar el marker del mapa
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let estacion = estaciones.getEstacionById(id: marker.userData as! Int);
        if(estacion != nil){
             DispatchQueue.main.async {
                self.estacion = estacion
                self.setupSelectedMarker(estacion: estacion!);
            }
        }
        return true;
    }
    
    
    //Actualiza los textos de la vista
    private func setupUI(){
        txtName.text = estacion.name
        txtDireccion.text = estacion.address
        txtColonia.text = estacion.districtName
        
        let controller = AppController()
        
        controller.getDisponibilidadEstaciones(refresh: true) { (res, err) in
            if(err != nil){
                
                return;
            }
            
            DispatchQueue.main.async {
                self.status = res?.getStatus(id: self.estacion.id)
                if(res != nil){
                    self.txtBicicletas.text = String(self.status!.availability.bikes)
                    self.txtSlots.text = String(self.status!.availability.slots)
                    self.txtStatus.text = self.status!.getStatus()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
