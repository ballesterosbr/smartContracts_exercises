pragma solidity ^0.5.0;

contract Ownable {

    address private _owner;

    constructor() public {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns(bool) {
        return msg.sender == _owner;
    }
}

contract Purchase is Ownable {

    struct Article {
        uint id;
        address payable seller;
        address buyer;
        uint256 price;
        State status;
    }

    //key = articleID
    mapping (uint => Article) public articles;

    enum State {
        Invalid,
        OnSale, 
        Sold
    }

    modifier checkID (uint _id) {
        require(articles[_id].id !=_id);
        _;
    }

    modifier notSeller(uint _id) {
        require(msg.sender != articles[_id].seller);
        _;
    }

    modifier sold (uint _id) {
        require(articles[_id].status == State.Sold);
        _;
    }

    modifier onSale (uint _id) {
        require(articles[_id].status == State.OnSale);
        _;
    }

    modifier checkPrice (uint _id) {
        require(articles[_id].price == msg.value);
        _;
    }

    function newArticle (uint _id, uint256 _price) 
        public
        checkID(_id)
    {
        articles[_id].id = _id;
        articles[_id].seller = msg.sender;
        articles[_id].price = _price;
        articles[_id].status = State.OnSale;
    }

    function buyArticle (uint _id) 
        public
        payable
        notSeller(_id)
        onSale(_id)
        checkPrice(_id)
    {
        articles[_id].buyer = msg.sender;
        articles[_id].status = State.Sold;
        articles[_id].seller.transfer(articles[_id].price);
    }

    function removeArticle (uint _id)
        public
        onlyOwner
        sold(_id)
    {
        delete articles[_id];
    }
}
