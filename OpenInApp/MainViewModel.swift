//
//  MainViewModel.swift
//  OpenInApp
//
//  Created by Archit Gupta on 18/06/23.
//

import Foundation

enum LinkType {
    case topLinks
    case recentLinks
}
protocol MainViewPresenter: AnyObject {
    var currLinkType: LinkType { get }
    func drawLineGraph(withData data: [String: CGFloat])
    func reloadCollectionView()
    func reloadTableView()
}
final class DashboardViewModel: DashboardViewModelable {
    var model: Dashboard? = nil
    var itemList: [AnalyticsModel] = []
    weak var presenter: MainViewPresenter?
    func viewLoaded() {
        makeAPICallWithBearerToken()
    }
    
    func getModel() -> Dashboard? {
        guard let model = self.model else {
            return nil
        }
        return model
    }
    
    func getCount() -> Int {
        return itemList.count
    }
    
    func getNumberOfTableViewCells() -> Int {
        guard let count = model?.data.top_links?.count else {
            return 0
        }
        return count
    }
    
    func getItem(row: Int) -> AnalyticsModel? {
        if (row < itemList.count) {
            return itemList[row]
        }
        return nil
    }
    
    func getTableViewCellItem(indexPath: IndexPath) -> LinksModel? {
        let currLinkType = presenter?.currLinkType
        switch currLinkType {
        case .topLinks:
            guard let cellModel = model?.data.top_links?[indexPath.row] else {
                return nil
            }
            return cellModel
        case .recentLinks:
            guard let cellModel = model?.data.recent_links?[indexPath.row] else {
                return nil
            }
            return cellModel
        case .none:
            return nil
        }
    }
    
    func getGreeting() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        if hour < 12 {
            return "Good morning"
        } else if hour < 18 {
            return "Good afternoon"
        } else {
            return "Good evening"
        }
    }
    
    func makeAPICallWithBearerToken() {
        guard let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    print("Error: Invalid response status code \(httpResponse.statusCode)")
                    return
                }
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.model = try decoder.decode(Dashboard.self, from: data)
                    if let model = self.model {
                        DispatchQueue.main.async {
                            self.populateItemList(model: model)
                            self.presenter?.reloadTableView()
                            self.presenter?.drawLineGraph(withData: model.data.overall_url_chart)
                        }
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            }
        }
        task.resume()
    }
    
    private func populateItemList(model: Dashboard) {
        itemList.removeAll()
        itemList.append(AnalyticsModel(title: "Extra Income", subtitle: String(model.extra_income)))
        itemList.append(AnalyticsModel(title: "Total Links", subtitle: String(model.total_links)))
        itemList.append(AnalyticsModel(title: "Total Clicks", subtitle: String(model.total_clicks)))
        itemList.append(AnalyticsModel(title: "Today's Clicks", subtitle: String(model.today_clicks)))
        itemList.append(AnalyticsModel(title: "Top Source", subtitle: String(model.top_source)))
        itemList.append(AnalyticsModel(title: "Top Location", subtitle: String(model.top_location)))
        itemList.append(AnalyticsModel(title: "Start Time", subtitle: String(model.startTime)))
        itemList.append(AnalyticsModel(title: "Links Created Today", subtitle: String(model.links_created_today)))
        itemList.append(AnalyticsModel(title: "Applied Campaign", subtitle: String(model.applied_campaign)))
        self.presenter?.reloadCollectionView()
    }
}
