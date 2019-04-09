//
//  ListaEstacionesViewController.swift
//  EcobiciAFA
//
//  Created by Alberto Farías on 4/5/19.
//  Copyright © 2019 Alberto Farías. All rights reserved.
//

import UIKit
import TableFlip

class ListaEstacionesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    var estaciones:StationsList? = nil
    var stationsFiltered:[Station] = []
    var estacion:Station!
    
    
    @IBOutlet weak var txtFilter: DesignableUITextField2Gom!
    @IBOutlet weak var tblEstaciones: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //SEtup navigation bar
        AppUtils.setupNavBarApp(navigationItem: self.navigationItem, navigationController: self.navigationController!)
        
        tblEstaciones.delegate = self
        tblEstaciones.dataSource = self
        
        
        refreshControl.tintColor = .black;
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tblEstaciones.refreshControl = refreshControl
    
        loadEstaciones()
        
        
        txtFilter.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        
    }
    
    @objc func reloadData(){
        loadEstaciones()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let filter = txtFilter.text!;
        //filtra las estaciones
        stationsFiltered = (estaciones?.filterDataList(filter: filter))!;
        DispatchQueue.main.async {
            self.tblEstaciones.reloadData()
        }
    }
    
    
    
    
    //MARK: TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return stationsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EstacionesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "estaciones_cell") as! EstacionesTableViewCell
        
        let estacion = stationsFiltered[indexPath.row]
        cell.setup(estacion: estacion)
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        estacion = stationsFiltered[indexPath.row]
        performSegue(withIdentifier: "estacion2Detalle", sender: self)
    }

    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "estacion2Detalle"){
            let next = segue.destination as! EstacionDetalleViewController
            next.setup(estacion: estacion, estaciones:estaciones!)
            
        }
     }
    
    
    //MARK: Networking
    
    private func loadEstaciones(){
        let controller = AppController();
        //showLoadingScreen(vc: self, msg: "Cargando estaciones")
        controller.getListaEstaciones { (res, err) in
            if(err != nil){
                
                self.showAlertMessage(message: "Error al cargar las estaciones", alertType: .error)
                self.removeLoadingScreen()
                return;
            }
            
            DispatchQueue.main.async {
                self.estaciones = res
                self.stationsFiltered = (self.estaciones?.stations)!
                self.tblEstaciones.reloadData()
               // self.removeLoadingScreen()
                self.refreshControl.endRefreshing()
                self.tblEstaciones.animate(animation: TableViewAnimation.Cell.left(duration: 0.5))
                
            }
            
        }
    }
    
   
}
