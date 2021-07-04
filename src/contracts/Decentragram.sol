// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


contract Decentragram {
  // Code goes here...

  string public name = "Decentragram";

  


  uint public imageCount = 0;
  //store images
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  //create images
  function uploadImage(string memory _imgHash, string memory _description) public {
    require(bytes(_imgHash).length > 0, "image cannot be empty");
    require(bytes(_description).length > 0, "description cannot be empty");
    require(msg.sender != address(0x0), "cannot be an empty requester");

    //increment image index
    imageCount++;
    //add image to contract
    address payable _payableSender = payable(msg.sender);


    images[imageCount] = Image(imageCount, _imgHash, _description, 0, _payableSender);
    emit ImageCreated(imageCount, _imgHash, _description, 0, _payableSender);
  }


  //tip images
  function tipImageOwner(uint _id) public payable {
    //checks
    require(_id > 0 && _id <= imageCount, "image cannot be empty");

    //get cached value
    Image memory _image = images[_id];

    //get to addr
    address payable _author = _image.author;
    //xfer value sent to author
    payable(address(_author)).transfer(msg.value);
    //calculate new tip total amount
    _image.tipAmount = _image.tipAmount + msg.value;
    //update record
    images[_id] = _image;

    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);

  }
  
}