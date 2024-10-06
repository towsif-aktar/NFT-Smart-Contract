// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; // Import ERC721 for _exists function
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // Import the Strings library
import "@openzeppelin/contracts/interfaces/IERC2981.sol"; // Import the ERC2981 interface for royalties

abstract contract NFT is ERC721Enumerable, Ownable, IERC2981 {
    using Strings for uint256;

    string baseURI;
    string public baseExtension = ".json";
    uint256 public cost = 0.001 ether;
    uint256 public maxSupply = 10;
    uint256 public maxMintAmount = 10;
    bool public paused = true;
    bool public revealed = false;
    string public notRevealedUri;
    
    // Royalty information
    address public creator = "commission address"; // Set the royalty commission address
    uint96 public royaltyPercentage = 1000; // 10% in basis points (1000 = 10%)
    
    constructor(
        string memory _initBaseURI,
        string memory _initNotRevealedUri
    ) ERC721("NFT", "NFT") Ownable(msg.sender) { // Set NFT name to "NFT" and symbol to "NFT"
        setBaseURI(_initBaseURI);
        setNotRevealedURI(_initNotRevealedUri);
    }

    // Internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    // Public
    function mint(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        require(!paused);
        require(_mintAmount != 0);
        require(_mintAmount <= maxMintAmount);
        require(supply + _mintAmount <= maxSupply);

        if (msg.sender != owner()) {
            require(msg.value >= cost * _mintAmount);
        }

        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(tokenOfOwnerByIndex(msg.sender, 0) != uint256(0), "ERC721Metadata: URI query for nonexistent token");
        
        if(revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
            : "";
    }

    // Royalties implementation (ERC2981)
    function royaltyInfo(
    uint256 _salePrice
) external view returns (address receiver, uint256 royaltyAmount) {
    require(tokenOfOwnerByIndex(msg.sender, 0) != uint256(0), "ERC721Metadata: URI query for nonexistent token");
    royaltyAmount = (_salePrice * royaltyPercentage) / 10000;
    return (creator, royaltyAmount);
}

    // Only owner functions
    function reveal() public onlyOwner {
        revealed = true;
    }
  
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }
  
    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    // Set new creator address (in case ownership changes)
    function setCreator(address _newCreator) public onlyOwner {
        creator = _newCreator;
    }

    // Override supportsInterface to add IERC2981
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, IERC165) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}
