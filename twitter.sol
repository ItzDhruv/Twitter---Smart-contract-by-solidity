// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
contract twitter{
    address owner;
    uint public maxTweetSize = 200;
    struct tweet{
        uint id;
        address user;
        string content;
        uint timestamp;
        uint likes;
    }

    mapping(address => tweet[]) public tweets;

 // Define the events
    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event TweetUnliked(address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    constructor(){
        owner=msg.sender;
    }

    modifier onlyOwner(){
        require(owner==msg.sender,"You are not owner");
        _;
    }

    function changeTwitLength(uint newTweetLength) public onlyOwner{
    maxTweetSize=newTweetLength;
    }

    function getTotalLikes(address author) external view returns(uint) {
        uint totalLikes = 0;
        for(uint i = 0; i < tweets[author].length; i++) {
            totalLikes += tweets[author][i].likes;
        }
        return totalLikes;
    }
 
       function createTweet(string memory _content) public {
        require(bytes(_content).length <= maxTweetSize, "Tweet is too long");

        tweet memory newTweet = tweet({
            id: tweets[msg.sender].length,
            user: msg.sender,
            content: _content,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.user, newTweet.content, newTweet.timestamp);
    }
    
   
 function likeTweet(address author, uint256 id) external {  
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");

        tweets[author][id].likes++;

        // Emit the TweetLiked event
        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        require(tweets[author][id].likes > 0, "TWEET HAS NO LIKES");
        
        tweets[author][id].likes--;

        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes );
    }

    function getTweet( uint _i) public view returns (tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (tweet[] memory ){
        return tweets[_owner];
    }

}
