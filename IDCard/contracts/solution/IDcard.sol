pragma solidity ^0.4.24;

/**
Create a Factory contract called IDcard
*/
contract IDcard {
    
    address public owner;
    
    struct User {
        address issuer;
        address IDowner;
        address userID;
        uint256 timestamp;
    }
    
    mapping (address => User) public users;
    
    event IdCreated (address _from, uint256 _timestamp, address _userID);
    
    modifier onlyOwner () {
        require(msg.sender == owner);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    /**
    Generate a new IDCard. Create a new UserID contract.
    Set as an atribute the user address that is calling this function.
    Save the info in User.
    Emit the event.
    Only if the user doesn't has a UserID created.
    */
    function newUserID()
        public       
    {
        require(users[msg.sender].issuer == address(0));
        users[msg.sender].issuer = address(this);
        users[msg.sender].IDowner = msg.sender;
        UserID _contractID = new UserID(msg.sender);
        users[msg.sender].userID = _contractID;
        users[msg.sender].timestamp = now;
        emit IdCreated (msg.sender, now,_contractID);
    }
    
    /** 
    Get User info.
    Add the keywords for getters functions
    */
    function getUser()
        public
        view
        returns (address, address, address, uint256)
    {
        return (
        users[msg.sender].issuer,
        users[msg.sender].IDowner,
        users[msg.sender].userID,
        users[msg.sender].timestamp
        );
    }
}

/**
Create a new contract called UserID
*/
contract UserID {

    address public owner;
    bool public isData;
    
    struct User {
        string name;
        string lastname;
        uint age;
        uint256 id_number;
        string birthdate;
        bool gender;
        string city;
        string country;
    }
    
    mapping (address => User) public myId;
    
    modifier onlyOwner () {
        require(msg.sender == owner);
        _;
    }
    
    event Create (address _from, uint256 _timestamp, address _UserID);
    event Update (address _from, uint256 _timestamp, address _UserID);
    event Delete (address _from, uint256 _timestamp, address _UserID);
    
    /**
    Set as attribute the address of the new owner
    */
    constructor(address _owner) public{
        owner = _owner;
    }

    /**
    Add user information.
    Only the owner can call this function.
    Use isData to check if data already exists. If is empty, data can be created.
    Emit the event.
    */
    function newInfo (string _name, string _lastname, uint _age, uint256 _id_number, string _birthdate, bool _gender, string _city, string _country)
        public
        onlyOwner
    {
        require(isData == false);
        isData = true;
        myId[msg.sender].name = _name;
        myId[msg.sender].lastname = _lastname;
        myId[msg.sender].age = _age;
        myId[msg.sender].id_number = _id_number;
        myId[msg.sender].birthdate = _birthdate;
        myId[msg.sender].gender = _gender;
        myId[msg.sender].city = _city;
        myId[msg.sender].country = _country;
        emit Create (msg.sender, now, this);
    }
    
    /**
    Update user information.
    Only the owner can call this function.
    Use isData to check if data already exists. If is not empty, data can be updated.
    Emit the event.
    */
    function updateInfo (string _name, string _lastname, uint _age, uint256 _id_number, string _birthdate, bool _gender, string _city, string _country)
        public
        onlyOwner
    {   
        require(isData != false);
        myId[msg.sender].name = _name;
        myId[msg.sender].lastname = _lastname;
        myId[msg.sender].age = _age;
        myId[msg.sender].id_number = _id_number;
        myId[msg.sender].birthdate = _birthdate;
        myId[msg.sender].gender = _gender;
        myId[msg.sender].city = _city;
        myId[msg.sender].country = _country;
        emit Create (msg.sender, now, this);
    }
    
    /** 
    Get User info.
    Add the keywords for getters functions
    */
    function getInfo ()
        public
        view
        returns (string, string, uint, uint256, string, bool, string, string)
    {
        return (
            myId[msg.sender].name,
            myId[msg.sender].lastname,
            myId[msg.sender].age,
            myId[msg.sender].id_number,
            myId[msg.sender].birthdate,
            myId[msg.sender].gender,
            myId[msg.sender].city,
            myId[msg.sender].country
            );
    }
    
    /**
    Remove user information.
    Only the owner can call this function.
    Use isData to check if data already exists. If is empty, data can't be removed.
    Emit the event.
    */
    function removeInfo ()
        public
        onlyOwner
    {
        require(isData != false);
        delete myId[msg.sender];
        isData = false;
        emit Delete(msg.sender, now, this);
    }
}