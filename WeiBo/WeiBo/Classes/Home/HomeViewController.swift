import UIKit
import SDWebImage
import MJRefresh
import SVProgressHUD

class HomeViewController: BaseViewController {

    var statusViewModels : [StatusViewModel] = [StatusViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            return
        }
        
        title = "Home"
        tableView.estimatedRowHeight = 200
        addRefreshComponent()
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
            
            var tempViewModels = [StatusViewModel]()
            
            for dict in statusArray{
                
                let status = Status(dict : dict)
                
                tempViewModels.append(StatusViewModel(status: status))
            }
            
            if isNewData {
                self.statusViewModels = tempViewModels + self.statusViewModels
                self.cacheImage(isNewData: true , count: tempViewModels.count,viewModels: self.statusViewModels)

            } else {
                self.statusViewModels += tempViewModels
                self.cacheImage(isNewData: false , count: tempViewModels.count,viewModels: self.statusViewModels)

            }

        }
        
    }
    
    fileprivate func cacheImage(isNewData : Bool ,count : Int ,  viewModels : [StatusViewModel]){
        let group = DispatchGroup.init()
        for viewModel in viewModels {
            for url in viewModel.picURLs {
                
                group.enter()
                SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil, completed: { (_, _, _, _, _, _) in

                    Dlog("图片下载完")
                    group.leave()
                })
            }
        }

        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
    }
}

extension HomeViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeViewCell
        
        cell.statusVM = self.statusViewModels[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = self.statusViewModels[indexPath.row]
    
        return viewModel.cellHeight
    }
    
}


