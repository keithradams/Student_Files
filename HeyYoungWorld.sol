import "./Ownable.sol";
import "./Destroyable.sol";

pragma solidity 0.5.12;

contract HeyYoungWorld is Ownable, Destroyable {
    
    struct Person {
        string name;
        uint age;
        uint height;
        bool senior;
        
    }
    
    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);
 
    uint public balance;
    
   
    /* modifier costs(uint cost){
        require(msg.value >= cost);
        _;
    }*/
    // Runs at the time the contracy is created
   
    mapping(address => Person) private people;
    
    // An Array for saving addresses
    address[]private creators;  
    
    function createPerson(string memory name, uint age, uint height) public {
        
        require(age < 150, "Age needs to be less than 150.");
        // balance = balance + msg.value;
        
       //balance += msg.value;
       // check if payment is >= 1 ET
       // This creates a person 
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
         
         if(age >= 65){
            newPerson.senior = true;
         } 
         else{
            newPerson.senior = false;
         }
            insertPerson(newPerson);
            // Adds an entry into the Array
            creators.push(msg.sender);
            //people[msg.sender] == person 
            assert(
                keccak256(
                    abi.encodePacked(
                    people[msg.sender].name, 
                    people[msg.sender].age, 
                    people[msg.sender].height, 
                    people[msg.sender].senior
                    )
                )
                ==
                keccak256(
                    abi.encodePacked(
                    newPerson.name, 
                    newPerson.age, 
                    newPerson.height, 
                    newPerson.senior
                    )
                )
            );
            emit personCreated(newPerson.name, newPerson.senior);
    }        
    
    function insertPerson(Person memory newPerson) private{
        address creator = msg.sender; 
        people[creator] = newPerson;
        
    }
   
    function getPerson() public view returns(string memory name, uint age, uint height, bool senior){
      address creator = msg.sender;
      return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }
    
    function deletePerson(address creator) public onlyOwner {
        string memory name = people[creator].name;
        bool senior = people[creator].senior;
        
        delete people[creator];
        assert(people[creator].age == 0);
        emit personDeleted(name, senior, msg.sender);
    }
    
    function getCreator(uint index) public view onlyOwner returns(address) {
        return creators[index];
    }
}    
