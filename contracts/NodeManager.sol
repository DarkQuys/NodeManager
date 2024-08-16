pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract NodeManager is Ownable , AccessControl {
    bytes32 public constant ADMINER = keccak256("ADMINER") ;
    constructor() Ownable(msg.sender) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMINER, msg.sender);
    }
    struct NodeInformation {
        bool status ;  
        string name ; 
        string metadata ; 
    }
    struct DiscountCoupon{
        bool status ;
        uint discount_percent ;  
    }
    mapping(uint => NodeInformation) public nodeInformations ;
    mapping(uint => DiscountCoupon) public discountCoupons ; 
    uint public nodeCount ;
    uint public couponCount ; 
    event addedNode(uint indexed id , string name, string metadata ) ;
    event updatedNode(uint indexed id , string name , string metadata );
    event deletedNode(uint indexed id ) ;
    event addedCoupon(uint indexed id , uint discount_percent);
    event updatedCoupon(uint indexed id  , uint discout_percent) ;
    event deletedCoupon(uint indexed id) ;
    
    modifier onlyAdmin (){
        require(hasRole(ADMINER , msg.sender) , "Caller not an admin") ;
        _;
    }
    function addNode(string memory _name , string memory _metadata )public onlyAdmin {
        nodeCount++;
        nodeInformations[nodeCount] = NodeInformation(true , _name ,_metadata) ;
        emit addedNode(nodeCount , _name , _metadata ) ;
    }
    function updateNode(uint idNode  , string memory _name , string memory _metadata ) public onlyAdmin {
        require(idNode > 0 && idNode <= nodeCount , "id of node invalid"); 
        require(nodeInformations[idNode].status , "Node not active");
        nodeInformations[idNode].name = _name ; 
        nodeInformations[idNode].metadata = _metadata ;
        emit updatedNode(idNode , _name , _metadata ) ;
    }
    function getNode(uint id) public view returns(bool ,  string memory, string memory ){
        require(id>0 && id<= nodeCount , "id of node invalid") ;
        return (nodeInformations[id].status,nodeInformations[id].name , nodeInformations[id].metadata) ;
    }

    function deleteNode (uint idNode ) public onlyAdmin {
        require(idNode > 0 && idNode <= nodeCount , "id of node invalid"); 
        delete nodeInformations[idNode] ;
        emit deletedNode(idNode) ;
    }

    function addCoupon(uint _discountPercent)public onlyAdmin {
        couponCount++ ;
        discountCoupons[couponCount] = DiscountCoupon(true  ,_discountPercent);
        emit addedCoupon(couponCount , _discountPercent) ; 
    }
    function updateCoupon(uint idCoupon , uint _discountPercent ) public onlyAdmin{
        require(idCoupon > 0 && idCoupon <= couponCount , " id of coupon invalid" ) ; 
        require(discountCoupons[idCoupon].status , " status of coupon not active " ) ;
        discountCoupons[idCoupon].discount_percent = _discountPercent ; 
        emit updatedCoupon(idCoupon , _discountPercent);
    }
    function deleteCoupon(uint idCoupon) public onlyAdmin {
        require(idCoupon > 0 && idCoupon <= couponCount , " id of coupon invalid" ) ; 
        delete discountCoupons[idCoupon] ;
        emit deletedCoupon(idCoupon);
    }
    function addAdmin(address acc ) public onlyOwner {
        grantRole(ADMINER, acc) ;
    }
    function removeAdmin(address acc ) public onlyOwner {
        revokeRole(ADMINER, acc)  ; 
    }
}