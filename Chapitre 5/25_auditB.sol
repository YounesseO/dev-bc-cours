// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract Crowdsale {
    
  uint256 public savedBalance = 0; // Total amount raised in ETH
  mapping (address => uint256) public balances; // Balances in incoming Ether
  // Event to record each time Ether is paid out
  event PayEther(
  address indexed _receiver,
  uint256 indexed _value,
  uint256 indexed _timestamp
  );
  // function to receive ETH
  receive() payable external {
      balances[msg.sender] += msg.value;
      savedBalance += msg.value;
      emit PayEther(address(this), msg.value, block.timestamp);
  }
   // refund investisor
  function withdrawPayments() public{
      address payable payee = payable(msg.sender);
      uint256 payment = balances[payee];
      require(payment != 0);
      require(address(this).balance >= payment);
    
      savedBalance -= payment;
      balances[payee] = 0;
    
      payee.call{value:payment};
      emit PayEther(payee, payment, block.timestamp);
  }
}
