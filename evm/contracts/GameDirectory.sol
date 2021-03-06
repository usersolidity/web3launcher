// SPDX-License-Identifier: MIT
/* this is going to store all the gaming info 
#TODO add title, game description, image URL, cost (USD only), and webhook address, publisher name */
pragma solidity ^0.8.2;

import '@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import '@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol';
import "./IGameDirectory.sol";
import './Base64.sol';

contract GameDirectory is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, AccessControlUpgradeable, IGameDirectory {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIdCounter;
    mapping (uint256 => GameData) public _games;

    event GameCreated(uint256 indexed gameId, address indexed owner);
    event GameUpdated(uint256 indexed gameId);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {
        __ERC721_init('Figura Game Directory', 'GDN');
        __ERC721Enumerable_init();
        __AccessControl_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function gameData(uint256 gameId) external view override returns (GameData memory) {
        return _games[gameId];
    }

    function submitGame(address to, GameData memory gamesub) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _games[tokenId]=gamesub;

        emit GameCreated(tokenId, to);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return '0';
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function updateGame(uint256 tokenId, GameData calldata newData) external {
        require(_exists(tokenId), 'Game does not exist');
        require(msg.sender == ownerOf(tokenId), 'Caller must be the current game admin');

        _games[tokenId] = newData;

        emit GameUpdated(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, IGameDirectory)
        returns (string memory)
    {
        GameData memory game=_games[tokenId];

        string memory packedJson = string(abi.encodePacked('{"name": "', game.title ,'", "description": "',game.description, '", "image_data": "', game.gameCoverURL, '", "image": "',game.gameCoverURL,'", "price": ',uint2str(game.price),', "publisher": "', game.publisher, '"}'));

        string memory json = Base64.encode(packedJson);
        return string(abi.encodePacked('data:application/json;base64,', json));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function exists(uint256 tokenId) public view override returns (bool) {
        return _exists(tokenId);
    }
}
