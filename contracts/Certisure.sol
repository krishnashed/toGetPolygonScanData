// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Certisure is Ownable, AccessControl {
    struct Certificate {
        string name;
        string organization;
        string url;
        address assignedBy;
    }

    mapping(address => Certificate[]) public holderToCertificates;
    mapping(address => uint256) holderCertificateCount;

    bytes32 ISSUER_ROLE = keccak256("ISSUER_ROLE");
    bytes32 HOLDER_ROLE = keccak256("HOLDER_ROLE");

    function test() public pure returns (string memory) {
        return "Hello World";
    }

    modifier onlyHolder() {
        if (hasRole(HOLDER_ROLE, msg.sender)) {
            _;
        } else {
            _setupRole(ISSUER_ROLE, msg.sender);
            _;
        }
    }

    function assignIssuerRole(address _newIssuerAddress) public onlyOwner {
        _setupRole(ISSUER_ROLE, _newIssuerAddress);
    }

    function substring(
        string memory str,
        uint256 startIndex,
        uint256 endIndex
    ) public pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }

    function checkURL(string memory _url) private pure returns (bool) {
        require(bytes(_url).length > 21);
        string memory ipfsPrefix = "https://ipfs.io/ipfs/";
        string memory urlPrefix = substring(_url, 0, 21);
        return (keccak256(abi.encodePacked((ipfsPrefix))) ==
            keccak256(abi.encodePacked((urlPrefix))));
    }

    function _assignCertificate(
        string memory _name,
        string memory _organization,
        string memory _url,
        address _assignTo
    ) public onlyRole(ISSUER_ROLE) {
        require(bytes(_name).length > 0);
        require(bytes(_url).length > 0);
        require(_assignTo != address(0));
        require(msg.sender != address(0));
        require(checkURL(_url));

        holderToCertificates[_assignTo].push(
            Certificate(_name, _organization, _url, msg.sender)
        );

        holderCertificateCount[msg.sender] =
            holderCertificateCount[msg.sender] +
            1;
    }

    function _getCertificates()
        public
        onlyHolder
        returns (Certificate[] memory)
    {
        address holder = msg.sender;
        return holderToCertificates[holder];
    }
}
