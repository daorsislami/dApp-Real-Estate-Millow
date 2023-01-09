//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// importing third-party library for creating the NFT
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract RealEstate is ERC721URIStorage {
    
    // this is gonna help us create an ienumerable ERC 721 token so we can create them from scratch
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;


    constructor() ERC721("Real Estate", "Real") { }

    // create NFT from scratch
    function mint(string memory tokenURI) public returns (uint256) {

        // here we're gonna let somebody MINT with a specific tokenURI so this is going to be the actual
        // metadata
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    // this is used to see how many NFTS have been currently minted
    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }
}
