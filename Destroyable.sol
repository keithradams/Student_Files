import "./Ownable.sol";
pragma solidity 0.5.12;

contract Destroyable is Ownable {
     
     address payable private owner;
     
     constructor() public {
        owner = msg.sender;
     }
     
      function close() public { 
        selfdestruct(owner); 
     }
     
 }
