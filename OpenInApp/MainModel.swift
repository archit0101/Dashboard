//
//  MainModel.swift
//  OpenInApp
//
//  Created by Archit Gupta on 18/06/23.
//

import Foundation
struct Dashboard: Decodable {
    let support_whatsapp_number: String
    let extra_income: Double
    let total_links: Int
    let total_clicks: Int
    let today_clicks: Int
    let top_source: String
    let top_location: String
    let startTime: String
    let links_created_today: Int
    let applied_campaign: Int
    let data: DataModel
}

struct DataModel: Decodable {
    let recent_links: [LinksModel]?
    let top_links: [LinksModel]?
    let overall_url_chart: [String:CGFloat]
}

struct LinksModel: Decodable {
    let url_id: Int
    let web_link: String
    let smart_link: String
    let title: String
    let total_clicks: Int
    let original_image: String
    let thumbnail: String?
    let times_ago: String
    let created_at: String
    let domain_id: String
    let url_prefix: String?
    let url_suffix: String
    let app: String
}

struct AnalyticsModel: Decodable {
    let title: String
    let subtitle: String
}

