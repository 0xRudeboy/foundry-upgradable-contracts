// SPDX-License-Identifier: MIT

// Be sure to check out solidity-by-example
// https://solidity-by-example.org/delegatecall

pragma solidity ^0.8.19;

/*
IMPORTANT NOTES

- Think of delegate call as borrowing a function and running it inside the origin contract for example: setVars in CONTRACT A does not have any variable setters
but because its delegate calling CONTRACT B it will borrow its functionality and implement it within itself setting the variables in CONTRACT A without affecting any states in CONTRACT B

- Its important to remember that the storage layout must be the same for the delegate call to work. Delegate call does not recognize variable names or types it only recognizes the storage slot so for ex: if the variable where named different in CONTRACT A "numbers" instead of "num" it would still work fine because it will just take that same slot so long as num and numbers are in the same storage slot.

- Even if no variables are present/declared in CONTRACT A, the values will still be assigned to it's storage slots
*/

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    /* 
    Point number 2 of the example shown visually

    uint256 public firstValue;
    address public somethingElse;
    uint256 public wooooo;

    this would still work fine provided we intend the variables to be assigned to the same storage slots

        num -> firstValue
        sender -> somethingElse
        value -> wooooo

    we can also look at it this way:

        storageSlot[0] = _num;
        storageSlot[1] = msg.sender;
        storageSlot[2] = msg.value;
    
    running in the contract A

    *************************************************************************************
    Here's anotther scenario:

    What if we changed the type of num from uint256 to a bool?

    when running the delegate call passing in 22 as a parameter, the value assigned to the bool will return true when called as opposed to 22

    because when 22 is set to the storage slot index 0, solidity is going to read it expecting a bool and anything other than zero will return true
    */
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _contract, uint256 _num) public payable {
        // A's storage is set, B is not modified.
        // (bool success, bytes memory data) = _contract.delegatecall(
        (bool success,) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        if (!success) {
            revert("delegatecall failed");
        }
    }
}
