//
//  EstacionesTableViewCell.swift
//  EcobiciAFA
//
//  Created by Alberto Farías on 4/5/19.
//  Copyright © 2019 Alberto Farías. All rights reserved.
//

import UIKit

class EstacionesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtDireccion: UILabel!
    @IBOutlet weak var txtIdEstacion: UILabel!
    @IBOutlet weak var txtBicicletas: UILabel!
    @IBOutlet weak var txtSlots: UILabel!
    @IBOutlet weak var txtStatus: UILabel!
    
    var status:StationsStatus?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setup(estacion:Station){
          txtNombre.text = estacion.name
         txtDireccion.text = estacion.address
        txtIdEstacion.text = "ID: " + String(estacion.id)
        
        let controller = AppController()
        
        controller.getDisponibilidadEstaciones(refresh: false) { (res, err) in
            if(err != nil){
               
                return;
            }
            
            DispatchQueue.main.async {
                self.status = res?.getStatus(id: estacion.id)
                if(res != nil){
                    self.txtBicicletas.text = String(self.status!.availability.bikes)
                    self.txtSlots.text = String(self.status!.availability.slots)
                    self.txtStatus.text = self.status?.getStatus()
                }
            }
        }
 
    }


}
