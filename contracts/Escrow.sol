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
}
