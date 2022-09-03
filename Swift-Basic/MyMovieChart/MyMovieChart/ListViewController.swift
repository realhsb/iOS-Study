import UIKit

class ListViewController : UITableViewController {
    // 현재까지 읽어온 데이터의 페이지 정보
    var page = 1
    
    // 튜플 아이템으로 구성된 데이터 세트
//    var dataset = [
//        ("다크 나이트", "영웅물에 철학에 음악까지 더해져 예술이 되다.", "2008-09-04", 8.95, "darknight.jpg"),
//        ("호우시절", "때를 알고 내리는 좋은 비", "2009-10-08", 7.31, "rain.jpg"),
//        ("말할 수 없는 비밀", "여기서 너까지 다섯 걸음", "2015-05-07", 9.19, "secret.jpg")
//    ]
    
    // 테이블 뷰를 구성할 리스트 데이터
    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
        
//        for (title, desc, opendate, rating, thumnail) in self.dataset {
//            let mvo = MovieVO()
//            mvo.title = title
//            mvo.description = desc
//            mvo.opendate = opendate
//            mvo.rating = rating
//            mvo.thumbnail = thumnail
//            
//            datalist.append(mvo)
//        }
        return datalist
    }()
    
    @IBOutlet var moreBtn: UIButton!
    
    @IBAction func more(_ sender: Any) {
        // 0 현재 페이지 값에 1을 추가한다
        self.page += 1
        
        // 영화 차트 API를 호출
        callMovieAPI()
                
        // 데이터를 다시 읽어오도록 테이블 뷰를 갱신한다
        self.tableView.reloadData()
        /*
        화면 구현이 완료된 후에 데이터가 추가돼도 테이블 뷰는 기존에 있던 데이터 크기를 유지.
        이것을 갱신해서 데이터를 다시 읽어 들이도록 만들어야 함.
        */
            
    }
    
    
    override func viewDidLoad() {
        // 영화 차트 API를 호출
        callMovieAPI()
    }
    
    // 영화 차트 API를 호출해주는 메소드
    func callMovieAPI(){
        // 1. 호핀 API 호출을 위한 URI를 생성
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        
        // 2. REST API를 호출
        let apidata = try! Data(contentsOf : apiURI)
        
        // 3. 데이터 전송 결과를 로그로 출력 (반드시 필요한 코드는 아님)
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result=\( log )")
        
        // 4. JSON 객체를 파싱하여 NSDictionary 객체로 받음
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            // 5. 데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            // 6. Iterator 처리를 하면서 API 데이터를 MovieVO 객체에 저장한다.
            for row in movie {
                // 순회 상수를 NSDictionary 타입으로 캐스팅
                let r = row as! NSDictionary
                
                // 테이블 뷰 리스트를 구성할 데이터 형식
                let mvo = MovieVO()
                
                // movie 배열의 각 데이터를 mvo 상수의 속성에 대입
                mvo.title       = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail   = r["thumbnailImage"] as? String
                mvo.detail      = r["linkUrl"] as? String
                mvo.rating      = ((r["ratingAverage"] as! NSString).doubleValue)
                
                // 웹상에 있는 이미지를 읽어와 UIImage 객체로 생성
                let url: URL! = URL(string: mvo.thumbnail!)
                let imageData = try! Data(contentsOf: url)
                mvo.thumbnailImage = UIImage(data:imageData)
                
                // list 배열에 추가
                self.list.append(mvo)
            }
            
            // 7. 전체 데이터 카운트를 얻는다.
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            
            // 8. totalCount가 읽어온 데이터 크기와 같거나 클 경우 더보기 버튼을 막는다.
            if(self.list.count >= totalCount) {
                self.moreBtn.isHidden = true
            }
        } catch {
            NSLog("Parse Error!")
        }
    }
    
    // 생성해야 할 행의 개수를 반환하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // 테이블 뷰 행을 구성하는 메소드 (한 번 호출될 때마다 하나의 행이 만들어짐)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 주어진 행에 맞는 데이터 소스를 읽어온다.
        let row = self.list[indexPath.row]
        // 행 번호 : indexPath.row (배열과 마찬가지로 0부터 시작, 행 번호 = 인덱스 번호)
        
        // 로그 출력
        NSLog("제목:\(row.title!), 호출된 행번호:\(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        
        
//        if cell == nil {
//                cell = MovieCell(style: UITableViewCellStyle.Default, reuseIdentifier: ListCell)
//            }
//        
        // 데이터 소스에 저장된 값을 각 아울렛 변수에 할당
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
        // 추가된 부분 : 이미지 뷰 처리
//        cell.thumnail.image = UIImage(named: row.thumbnail!)
        /*
         UIImage(named:)는 앱의 로컬 경로에 있는 이미지를 읽어오는 방식, 프로젝트 내부 이미지 파일
         웹의 이미지를 읽어와서 출력하는 코드로 변경
         */
        
//        // 섬네일 경로를 인자값으로 하는 URL 객체 생성
//        let url: URL! = URL(string: row.thumbnail!)
//
//        // 이미지를 읽어와 Data 객체에 저장
//        let imageData = try! Data(contentsOf: url)
//
//        // UIImage 객체를 생성하여 아울렛 변수의 image 속성에 대입
//        cell.thumnail.image = UIImage(data: imageData)
        
        // 위의 3줄 코드 필요 없음
        // 최초 한 번만 이미지를 내려받고, 화면을 스크롤해서 셀이 재구성되어도 이미지를 내려 받지 않음
        // 이미 내려받은 이미지 객체를 꺼내어 씀 = 메모이제이션 기법
        
        // 수정) 비동기 방식으로 섬네일 이미지를 읽어옴
        // 이미지 객체를 대입한다.
        DispatchQueue.main.async(execute: {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        })

        /*
         한 줄로 작성시
         cell.thumbnail.image = UIImage(data: try! Data(contentsOf: URL(string:row.thumbnail!)!))
         */
        
        // 셀 객체 반환
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row) 번째 행입니다.")
    }
    
    func getThumbnailImage(_ index: Int) -> UIImage {
        // 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
        let mvo = self.list[index]
        
        // 메모이제이션 : 저장된 이미지가 있으면 그것을 반환하고, 없을 경우 내려받아 지정한 후 반환
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData)   // UIImage를 MovieVO 객체에 우선 저장
            
            return mvo.thumbnailImage!
        }
    }
 }



// MARK: - 화면 전환 시 값을 넘겨주기 위한 세그웨이 관련 처리
// 세그웨이에 대한 전처리 메소드
extension ListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 실행된 세그웨이의 식별자가 "segue_detail"이라면
        if segue.identifier == "segue_detail" {
            // sender 인자를 캐스팅하여 테이블 셀 객체로 변환한다.
            let cell = sender as! MovieCell
            
            // 사용자가 클릭한 행을 찾아낸다.
            let path = self.tableView.indexPath(for: cell)
            
            // API 영화 데이터 배열 중에서 선택된 행에 대한 데이터를 추출한다.
            let movieinfo = self.list[path!.row]
            
            // 행 정보를 통해 선택된 영화 데이터를 찾은 다음, 목적지 뷰 컨트롤러의 mvo 변수에 대입한다.
            let detailVC = segue.destination as? DetailViewController
            detailVC?.mvo = movieinfo
        }
    }
}
