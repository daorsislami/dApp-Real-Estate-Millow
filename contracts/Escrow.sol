//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _id
    ) external;
}

contract Escrow {
    address public nftAddress; // we need this variable because we wanna store the smart contract address for the NFT for this particular real estate transaction

    address payable public seller; // we add 'payable' because seller will be able to receive crypto currency in this transaction. We'll transfer Ether to them.
    address public inspector;
    address public lender; // address is a data type


    // Modifier helps us to apply it to a function e.g. this function can be called only from seller, so when the msg.sender is a seller.
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this method");
        _;
    }

    modifier onlyBuyer(uint256 _nftID) {
        require(msg.sender == buyer[_nftID], "Only buyer can call this method");
        _;
    }

    modifier onlyInspector() {
        require(msg.sender == inspector, "Only inspector can call this method");
        _;
    }

    // This is a Solidity data structure
    // uint it's an unsigned integer so this will be like an NFT id, and bool value will be like true or false
    // The thing is we need to keep track if an NFT is listed to kind of like mark it to true if it's listed
    mapping(uint256 => bool) public isListed;


    mapping(uint256 => uint256) public purchasePrice; // The amount of Cryptocurrency so an Ether to indicate the costs for the house
    mapping(uint256 => uint256) public escrowAmount; // It's gonna hold the id of NFT and the escrow amount
    mapping(uint256 => address) public buyer; // Holds information for NFT Id and the address of the buyer
    mapping(uint256 => bool) public inspectionPassed; // uint256 -> PropertyID, bool -> it's true or false whether the inspection has passed or not


    mapping(uint256 => mapping(address => bool)) public approval; // the key is NFT, as value is going to be the address of the person who approved it and whether that's true or false

    constructor(
        address _nftAddress, 
        address payable _seller,
        address _inspector,
        address _lender
    ) {
        nftAddress = _nftAddress;
        seller = _seller;
        inspector = _inspector;
        lender = _lender;
    }

    // Take the NFT out of the users wallet and move it into Escrow
    // and we're gonna set the price for the NFT or property
    // will put an Escrow amount which is required essentially like a downpayment(paradhenie/kopare) whether the transaction is going to get completed
    function list(
        uint256 _nftID, 
        address _buyer, 
        uint256 _purchasePrice, 
        uint256 _escrowAmount
    ) public payable onlySeller{
        // Moving the NFT out of the users wallet and putting it into Escrow. 
        // Because that's the whole point of a Real Estate transaction with Escrow it's like, the ownership is put in by a neutral party
        // And everybody has to sign off and do what they're suppose to do in order to make this happen. 

        // transferFrom method let's you move tokens from one wallet to another wallet
        // we need to have the owner consent(pelqim) to move 
        // So this line is transfering the NFT from seller to this contract
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftID);

        // This is how we assign value to a mapping
        isListed[_nftID] = true;
        purchasePrice[_nftID] = _purchasePrice;
        buyer[_nftID] = _buyer;
        escrowAmount[_nftID] = _escrowAmount;
    }

    // Put under contract (only buyer - payable escrow)
    function depositEarnest(uint256 _nftID) public payable onlyBuyer(_nftID) {
        require(msg.value >= escrowAmount[_nftID]);
    }


    // Update Inpsection Status (only inspector)
    function updateInspectionStatus(uint256 _nftID, bool _passed) public onlyInspector{
        inspectionPassed[_nftID] = _passed;
    }


    // Approve Sale
    function approveSale(uint256 _nftID) public  {
        approval[_nftID][msg.sender] = true;
    }


    // This is whats it's gonna let smart contract actually receive Ether. e.g Lender could send funds to the smart contracts and increase the balance you need this in order 
    // to accept ether to the contract
    receive() external payable {

    }


    // Get the current Ether balance for this contract
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}
