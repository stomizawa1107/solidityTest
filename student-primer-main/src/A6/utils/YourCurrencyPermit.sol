// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import '@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

contract YourCurrencyPermit is ERC20Permit {
    constructor(
        string memory name,
        uint256 initialSupply,
        address[] memory testers
    )
        ERC20(name, "1")
        ERC20Permit(name)
    {
        uint256 len = testers.length;
        for(uint256 i = 0; i < len;) {
            _mint(testers[i], initialSupply * (10 ** decimals())/ len);
            unchecked { ++i; }
        }
    }

}
