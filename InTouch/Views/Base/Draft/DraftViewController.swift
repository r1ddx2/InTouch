//
//  DraftViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import UIKit

enum DraftType: String, CaseIterable {
    case image = "Images"
    case text = "Articles"
}

class DraftViewController: ITBaseViewController {
    
    var addedImageCell: ImageBlockDraftCell?
   
    // MARK: - Subviews
    let tableView = UITableView()
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit Newsletter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bold(size: 1)
        button.backgroundColor = .ITBlack
        button.layer.cornerRadius = 8
        return button
    }()
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let dismissButton = UIBarButtonItem(image: UIImage(resource: .iconClose).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismissTapped))
        navigationItem.rightBarButtonItem = dismissButton
        
        setUpTableView()
        setUpLayouts()
        setUpActions()
    }
    private func setUpLayouts() {
        view.addSubview(tableView)
        view.addSubview(submitButton)
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        submitButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(45)
        }
        
        
    }
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TextBlockDraftCell.self, forCellReuseIdentifier: TextBlockDraftCell.identifier)
        tableView.register(ImageBlockDraftCell.self, forCellReuseIdentifier: ImageBlockDraftCell.identifier)
        tableView.register(DraftTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: DraftTableSectionHeaderView.identifier)
        tableView.rowHeight = 170
        tableView.sectionHeaderHeight = 45
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.cellLayoutMarginsFollowReadableWidth = false
    }
    private func setUpActions() {
        
    }
    
    
    // MARK: - Methods
    @objc private func dismissTapped(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
extension DraftViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return DraftType.allCases.count
        //return datas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        // return datas[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageBlockDraftCell.identifier, for: indexPath) as? ImageBlockDraftCell else {
                fatalError("Cannot create image cell") }
           
            cell.addImageHandler = { [weak self] in
                self?.addedImageCell = cell
                self?.showImagePicker()
                cell.addImageButton.isEnabled = false
                cell.addImageButton.isHidden = true
            }
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextBlockDraftCell.identifier, for: indexPath) as? TextBlockDraftCell else { fatalError("Cannot create text cell") }
            
          
            return cell
            
        default:
            return UITableViewCell(style: .default, reuseIdentifier: String(describing: ITBaseTableViewController.self))
        }
    
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: DraftTableSectionHeaderView.self)) as? DraftTableSectionHeaderView else {
                fatalError("Cannot create section header")
        }
        headerView.titleLabel.text = DraftType.allCases[section].rawValue
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }


}

// MARK: - UIImagePickerControllerDelegate

extension DraftViewController {
    func imagePickerController(_ picker: UIImagePickerController, 
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
 
        if let imageCell = addedImageCell {
            imageCell.userImageView.image = selectedImage
        }
        dismiss(animated: true)
    }
}
