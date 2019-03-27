//
//  PreferencesVC.swift
//  EasyMeals
//
//  Created by Максим on 3/25/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

//
// MARK: - CollapsibleTableSectionDelegate
//
@objc public protocol CollapsibleTableSectionDelegate {
    @objc optional func numberOfSections(_ tableView: UITableView) -> Int
    @objc optional func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    @objc optional func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    @objc optional func collapsibleTableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func collapsibleTableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    @objc optional func collapsibleTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    @objc optional func collapsibleTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func shouldCollapseByDefault(_ tableView: UITableView) -> Bool
    @objc optional func shouldCollapseOthers(_ tableView: UITableView) -> Bool
}

class PreferencesVC: ParentVC {
    
    public var delegate: CollapsibleTableSectionDelegate?

    @IBOutlet weak var preferenceTableView: UITableView!
    fileprivate var _sectionsState = [Int : Bool]()
    fileprivate var shouldRotateArrow = true
    
    public func isSectionCollapsed(_ section: Int) -> Bool {
        if _sectionsState.index(forKey: section) == nil {
            _sectionsState[section] = delegate?.shouldCollapseByDefault?(preferenceTableView) ?? false
        }
        return _sectionsState[section]!
    }
    
    func getSectionsNeedReload(_ section: Int) -> [Int] {
        var sectionsNeedReload = [section]
        
        // Toggle collapse
        let isCollapsed = !isSectionCollapsed(section)
        
        // Update the sections state
        _sectionsState[section] = isCollapsed
        
        let shouldCollapseOthers = delegate?.shouldCollapseOthers?(preferenceTableView) ?? false
        
        if !isCollapsed && shouldCollapseOthers {
            // Find out which sections need to be collapsed
            let filteredSections = _sectionsState.filter { !$0.value && $0.key != section }
            let sectionsNeedCollapse = filteredSections.map { $0.key }
            
            // Mark those sections as collapsed in the state
            for item in sectionsNeedCollapse { _sectionsState[item] = true }
            
            // Update the sections that need to be redrawn
            sectionsNeedReload.append(contentsOf: sectionsNeedCollapse)
        }
        
        return sectionsNeedReload
    }
    
    private var quantities = [QuantityData]()
    private var varieties = [VarietyData]()
    
    private var selectedQuantityText = String()
    private var selectedVarietyText = String()

    private var selectedQuantityID = Int()
    private var selectedVarietyID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        self.startProcessing()
        self.getData {
            self.stopProcessing()
            self.preferenceTableView.reloadData()
        }
    }
    
    private func getData(completed: @escaping () -> ()) {

        let group = DispatchGroup()

        group.enter()
        RequestManager.getMealQuantities { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let quantities):
                self.quantities = quantities.data ?? []
                let userQuantityID = Constants.currentUser?.data?.settings?.mealsQuantityid ?? 0
                for quantity in self.quantities {
                    if quantity.mealsQuantityid == userQuantityID {
                        self.selectedQuantityText = quantity.title ?? ""
                        self.selectedQuantityID = quantity.mealsQuantityid ?? 0
                    }
                }
            case .error(let error):
                Constants.showAlert("Error", message: error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        RequestManager.getMealVarieties { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let varieties):
                self.varieties = varieties.data ?? []
                let userVarietyID = Constants.currentUser?.data?.settings?.mealsVarietyid ?? 0
                for variety in self.varieties {
                    if variety.mealsVarietyid == userVarietyID {
                        self.selectedVarietyText = variety.title ?? ""
                        self.selectedVarietyID = variety.mealsVarietyid ?? 0
                    }
                }
            case .error(let error):
                Constants.showAlert("Error", message: error.localizedDescription)
            }
            group.leave()
        }
        
        // This closure will be called when the group's task count reaches 0
        group.notify(queue: .main) { [weak self] in
            guard let _ = self else { return }
            completed()
        }
        
    }
    
    @IBAction func backButtonTap(_ button: UIButton) {
        
        self.startProcessing(withStatus: "Saving changes...", disableUserInteraction: true)
        RequestManager.userEditSettings(quantityID: selectedQuantityID, varietyID: selectedVarietyID) { (result) in
            self.stopProcessing()
            switch result {
            case .success(_):
                self.onParentBack()
            case .error(let error):
                Constants.showAlert("Error", message: error.localizedDescription)
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

//
// MARK: - View Controller DataSource and Delegate
//
extension PreferencesVC: CollapsibleTableSectionDelegate {

    func numberOfSections(_ tableView: UITableView) -> Int {
        return 2
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return quantities.count
        case 1:
            return varieties.count
        default:
            return 0
        }
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = preferenceTableView.dequeueReusableCell(withIdentifier: "QuantityCell", for: indexPath) as! QuantityTVCell
            let quantity = quantities[indexPath.row]
            cell.configureCell(withQuantity: quantity, selectedQuantityID: selectedQuantityID)
            return cell
        case 1:
            let cell = preferenceTableView.dequeueReusableCell(withIdentifier: "VarietyCell", for: indexPath) as! VarietyTVCell
            let variety = varieties[indexPath.row]
            cell.configureCell(withVariety: variety, selectedVarieryID: selectedVarietyID)
            return cell
        default:
            return UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DefaultCell")
        }
    }
    
    func collapsibleTableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 87
    }
    
    func shouldCollapseByDefault(_ tableView: UITableView) -> Bool {
        return true
    }
    
}

extension PreferencesVC: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.numberOfSections?(tableView) ?? 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = delegate?.collapsibleTableView?(tableView, numberOfRowsInSection: section) ?? 5
        return isSectionCollapsed(section) ? 0 : numberOfRows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = delegate?.collapsibleTableView?(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let quantity = quantities[indexPath.row]
            selectedQuantityID = quantity.mealsQuantityid ?? 0
            selectedQuantityText = quantity.title ?? ""
            UIView.performWithoutAnimation {
                self.preferenceTableView.reloadData()
            }
        case 1:
            let variety = varieties[indexPath.row]
            selectedVarietyID = variety.mealsVarietyid ?? 0
            selectedVarietyText = variety.title ?? ""
            UIView.performWithoutAnimation {
                self.preferenceTableView.reloadData()
            }
        default:
            break
        }
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.collapsibleTableView?(tableView, heightForHeaderInSection: section) ?? 87.0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return delegate?.collapsibleTableView?(tableView, heightForFooterInSection: section) ?? 0.0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        switch section {
        case 0:
            header.titleText = selectedQuantityText
        case 1:
            header.titleText = selectedVarietyText
        default:
            break
        }
        
        header.setCollapsed(isSectionCollapsed(section))
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
}

//
// MARK: - Section Header Delegate
//
extension PreferencesVC: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ section: Int) {
        let sectionsNeedReload = getSectionsNeedReload(section)
        preferenceTableView.reloadSections(IndexSet(sectionsNeedReload), with: .automatic)
    }
    
}
