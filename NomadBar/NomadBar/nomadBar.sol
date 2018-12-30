pragma solidity ^0.5.0;

import "./safemath.sol";
import "./Ownable.sol";


//@title Contract for making random cocktails.
//@author Jin Chae
//@dev You can make your own unique cocktails after collecting enough stars by making a toast.
contract NomadBar is Ownable {

  using SafeMath for uint256;

  uint limit = 16;
  uint randModule = 10 ** limit;
  uint randNonce = 0;

  //@dev Event function to log.
  event NewCocktail(uint id, string name);

  //@dev mapping to store the owner address with a Cocktail's id.
  mapping (uint => address) cocktailIdToOwner;
  //@dev mapping to store the amount of stars with the owner address.
  mapping (address => uint) starsCount;
  //@dev mapping to store the amount of cocktails with the owner address.
  mapping (address => uint) cocktailsCount;

  //@dev Structure of a Cocktail.
  struct Cocktail {
    string name;
    uint look;
  }

  //@dev Array to store cocktails.
  Cocktail[] cocktails;

  //@dev Modifier to check the amount of cocktails the owner's got.
  modifier toastCheck {
      require(cocktailsCount[msg.sender] > 0,
    "You don't have any glasses to toast.\
    Create your own cocktails first.");
    _;
  }

  //@dev Function to create a new cocktail. You must have five stars to do.
  function bartend(string calldata _name) external {
    if(cocktailsCount[msg.sender] == 0 || starsCount[msg.sender] >= 5) {
        uint newLook = _createRandomDesign(_name);
        _createCocktail(_name, newLook);
    }else {
        revert("You don't have enough stars.\
                Make a toast to get stars.");
    }
  }

  //@dev Designs the looks which is like shape of a glass, colours, deco for a cocktail at random.
  function _createRandomDesign(string memory _str) private view returns(uint) {
    uint randLooks = uint(keccak256(abi.encodePacked(now, msg.sender, _str)));
    return randLooks % randModule;
  }

 //@dev Creates a cocktail.
  function _createCocktail(string memory _name, uint _look) private {
    uint cocktailId = cocktails.push(Cocktail(_name, _look)) - 1;
    cocktailIdToOwner[cocktailId] = msg.sender;
    cocktailsCount[msg.sender] = cocktailsCount[msg.sender].add(1);
    if(starsCount[msg.sender] >= 5)
        starsCount[msg.sender] = 0;
    emit NewCocktail(cocktailId, _name);
  }

  //@dev Creates a random number to make a toast.
  function _createRandomNum(uint _rand) private returns(uint) {
      randNonce++;
      uint randNum = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _rand + 1;
      return randNum;
  }

  //@dev You can get stars if your number is bigger then a random number.
  function makeToast(uint _pickedNum) external onlyOwner() toastCheck {
    require(0 < _pickedNum && 100 >= _pickedNum, "your number must be minimum 1 and meximum 100");
    uint rand = _createRandomNum(100);
    if (_pickedNum >= rand) {
        starsCount[msg.sender] = starsCount[msg.sender].add(1);
    }else {
        revert("none");
    }
  }

  //@dev You can check your all cocktails you've got.
  function getAllCocktails() external view onlyOwner() returns(uint[] memory) {
    uint[] memory allMyCocktails = new uint[](cocktailsCount[msg.sender]);
    uint counter = 0;
    for(uint i = 0; i < cocktails.length; i++) {
        if(cocktailIdToOwner[i] == msg.sender) {
          allMyCocktails[counter] = i;
          counter++;
        }
    }
    return allMyCocktails;
  }

  //@dev You can check your stars you've got.
  function checkMyStars() external view onlyOwner() returns(uint) {
      return starsCount[msg.sender];
  }

}
