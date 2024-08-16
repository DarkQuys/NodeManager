pragma solidity ^0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";
contract UserManager is Ownable(msg.sender){
    struct User{
        string name  ;
        string email ; 
        string ipfsHash ;
    }
    mapping(address => User) private Users ;
    event registered(address indexed acc, string name , string email , string ipfsHash) ;
    event updated(address indexed acc , string name , string email , string ipfsHash ) ; 
    function registerUser(string memory name ,  string memory email ,string memory ipfsHash)public {
        require(bytes(Users[msg.sender].name).length ==0 ," User already rigisted" ) ;
        Users[msg.sender] = User(name , email , ipfsHash) ;
        emit registered(msg.sender, name, email, ipfsHash);
    }
    function updateUser(string memory name , string memory email , string memory ipfsHash)public {
        require(bytes(Users[msg.sender].name).length !=0 ,"User not register");
        Users[msg.sender] = User(name ,  email,  ipfsHash) ;
        emit updated(msg.sender, name , email,  ipfsHash);
    }
    function getUser(address userAddress) public view returns (string memory , string memory , string memory ){
        require( bytes(Users[msg.sender].name).length !=0 ,"user not register") ;
        return (Users[msg.sender].name ,Users[msg.sender].email , Users[msg.sender].ipfsHash ) ;
    }
}