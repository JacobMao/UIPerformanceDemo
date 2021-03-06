import UIKit
import SDWebImage
import MJRefresh
import SVProgressHUD

class HomeViewController: BaseViewController {

    var statusViewModels : [StatusViewModel] = [StatusViewModel]()
    var cellLayoutModels : [HomeCellLayout] = [HomeCellLayout]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if !isLogin {
//            return
//        }

        title = "Home"
//        addRefreshComponent()

        tableView.register(HomeViewCell.self, forCellReuseIdentifier: "homeCell")
        self.loadData(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController{
    func addRefreshComponent() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadData(true)
        })

        self.tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: kScreenW - 20, height: 30))
            label.backgroundColor = UIColor.clear
            label.text = "Loading more datas..."
            label.textColor = UIColor.gray
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.boldSystemFont(ofSize: 13)
            self.tableView.mj_footer.addSubview(label)

            self.loadData(false)
        })

        self.tableView.mj_header.beginRefreshing()
        
    }

    func loadData(_ isNewData : Bool) {
        var since_id = 0
        var max_id = 0
        
        if isNewData {
            since_id = self.statusViewModels.first?.status.mid ?? 0
        }else{
            max_id = self.statusViewModels.last?.status.mid ?? 0
            max_id = max_id == 0 ? 0 : max_id - 1
        }
        
        NetworkTools.loadHomeData(since_id, max_id: max_id) { (result) in
            
            guard let statusArray = result else {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.endRefreshing()
                
                SVProgressHUD.showError(withStatus: "over counts")
                
                return
            }

            DispatchQueue.global(qos: .userInitiated).async {
                var tempViewModels = [StatusViewModel]()
                tempViewModels.reserveCapacity(statusArray.count)

                var tempLayoutModels = [HomeCellLayout]()
                tempLayoutModels.reserveCapacity(statusArray.count)

                for dict in statusArray {
                    let status = Status(dict : dict)
                    let viewModel = StatusViewModel(status: status)
                    tempViewModels.append(viewModel)
                    tempLayoutModels.append(viewModel.generateLayoutModel())
                }

                DispatchQueue.main.async {
                    if isNewData {
                        self.statusViewModels = tempViewModels + self.statusViewModels
                        self.cellLayoutModels = tempLayoutModels + self.cellLayoutModels

                    } else {
                        self.statusViewModels += tempViewModels
                        self.cellLayoutModels += tempLayoutModels
                    }

                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension HomeViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeViewCell

        cell.parentVC = self
        cell.setupLayout(cellLayoutModels[indexPath.row])
        cell.statusVM = self.statusViewModels[indexPath.row]

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellLayoutModels[indexPath.row].cellHeight
    }
}


