// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GasContract {

    error Err();

    uint256 internal immutable totalSupply; // cannot be updated
    mapping(address => uint256) public balances;
    mapping(address => uint8) public whitelist;
    address internal immutable contractOwner;
    address[5] public administrators;


    struct ImportantStruct {
        uint256 amount;
        bool paymentStatus;
    }
    mapping(address => ImportantStruct) public whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);
    event Transfer(address recipient, uint256 amount);
    
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
        

        for (uint256 ii = 0; ii < administrators.length; ii++) {
            administrators[ii] = _admins[ii];
            
        }
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        return balances[_user];
    }


    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public  {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
    }

    function addToWhitelist(
        address _userAddrs,
        uint256 _tier
    ) public {
        if (!(msg.sender == contractOwner)) {
            revert Err();
        }
        if (_tier > 254) {
            revert Err();
        }
        whitelist[_userAddrs] = uint8(_tier);

        if (_tier > 3) {
            whitelist[_userAddrs] = 3;
        }

        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount
    ) public  {
        whiteListStruct[msg.sender] = ImportantStruct(
            _amount,
            true
        );
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        balances[msg.sender] += whitelist[msg.sender];
        balances[_recipient] -= whitelist[msg.sender];

        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256) {
        return (
            whiteListStruct[sender].paymentStatus,
            whiteListStruct[sender].amount
        );
    }
}
