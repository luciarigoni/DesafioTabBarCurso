//
//  ViewController.swift
//  DesafioTabBarCurso
//
//  Created by Lucia Rigoni Freire on 27/11/22.
//

import UIKit

class Tela01VC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editPictureButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    var data: [Profile] = []
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var alert: AlertController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        alert = AlertController(controller: self)
        configElemnts()
        configTableView()
        configImagePicker()
    }
    
    func configImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    func configElemnts() {
        view.backgroundColor = .lightGray
        nameLabel.text = "Nome:"
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .black
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        nameTextField.placeholder = "Digite seu nome:"
    }
    
    func configTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(CustomTableViewCell.nib(), forCellReuseIdentifier: CustomTableViewCell.identifier)
    }

    @IBAction func tappedEditPictureButton(_ sender: UIButton) {
        self.alert?.chooseImage(completion: { option in
            switch option {
            case .camera:
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.sourceType = .camera
                } else {
                    self.imagePicker.sourceType = .photoLibrary
                }
                self.present(self.imagePicker, animated: true)
            case .library:
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true)
            case .cancel:
                break
            }
        })
    }
        
    @IBAction func tappedAddButton(_ sender: UIButton) {
        if nameTextField.text == "" {
            self.alert?.alertInformation(title: "ATENCAO", message: "Por favor, informe o nome")
        } else {
            data.append(Profile(name: nameTextField.text ?? "", photo: profileImageView.image ?? UIImage()))
            nameTextField.text = ""
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            tableview.reloadData()
        }
    }
}

extension Tela01VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell
        cell?.setupCell(profile: data[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

extension Tela01VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = image
        }
        picker.dismiss(animated: true)
    }
}
