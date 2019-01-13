
import Foundation

public class User : BaseModel {

    public var email : String?
	public var mobile : String?
	public var first_name : String?
    public var last_name : String?
	public var speciality : BaseModel?
    public var is_active : Bool?
    public var api_token : String?
    override init(data:AnyObject){
        super.init(data: data)
        if let data = data as? NSDictionary {
            email = data.getValueForKey(key: "email", callback: "")
            mobile = data.getValueForKey(key: "mobile", callback: "")
            first_name = data.getValueForKey(key: "first_name", callback: "")
            last_name = data.getValueForKey(key: "last_name", callback: "")
            is_active = (data.getValueForKey(key: "is_active", callback: "0")) == "1"
            api_token = (data.getValueForKey(key: "api_token", callback: ""))
            speciality = BaseModel(data: data.getValueForKey(key: "speciality", callback: [:]) as AnyObject)

        }
    }
    
    init(ID:Int,name:String,mobile:String) {
        super.init(ID: ID,name: name)
        self.mobile = mobile
    }
    
    override init() {
        super.init()
    }
    
}
