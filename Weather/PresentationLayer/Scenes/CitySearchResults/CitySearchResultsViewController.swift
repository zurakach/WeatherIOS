import Foundation
import UIKit

protocol CitySearchResultsViewControllerDelegate: AnyObject {
    func citySearchResultsViewControllerDidSelect(city: CityPresentationModel)
}

// TODO: This could aslo be set up in VIP way
final class CitySearchResultsViewController: UITableViewController {
    
    private var cities = [CityPresentationModel]()
    weak var searchDelegate: CitySearchResultsViewControllerDelegate?
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithCities(_ cities: [CityPresentationModel]) {
        self.cities = cities
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchDelegate?.citySearchResultsViewControllerDidSelect(city: cities[indexPath.row])
    }
    
}
