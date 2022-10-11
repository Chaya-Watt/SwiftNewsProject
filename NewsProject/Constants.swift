struct K {
    static let newsUrl = "https://newsapi.org/v2/everything?sortBy=publishedAt&apiKey=7d785e8a702740a5a85fa236095ec611"
    
    struct CustomTableCell {
        static let dashBoardCell = "DashBoardTableViewCell"
        static let historyCell = "HistoryTableViewCell"
    }
    
    struct Segue {
        static let goToSearch = "goToSearch"
        static let goToDetail = "goToDetail"
    }
    
    struct KeyDataLocal {
        static let HistoryList = "historyList"
        static let ArticleList = "articleList"
    }
    
    struct FormatDate {
        static let resultFormat = "dd MMM yy"
        static let orginalFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let localIdentifier = "th-TH"
    }
}
