// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Devfolio {

    struct Organizer {
        string email;
        string password;
    }

    struct Participant {
        string name;
        string dob;
        string resume;
        string profession;
        string githubLink;
        string twitterLink;
        string linkedinLink;
    }

    struct Hackathon {
        address organizer;
        string title;
        string community;
        string description;
        uint max_team_size;
        string app_open;
        string app_close;
        address[] participants;
    }

    uint256 public projectCount = 0;
    mapping(uint256 => Hackathon) public hackathons;
    mapping(address => Organizer) public organizers;
    mapping(address => Participant) public participants;

    constructor() {
        organizers[msg.sender] = Organizer("", "");
    }

    modifier onlyOrganizer() {
        require(keccak256(bytes(organizers[msg.sender].email)) != keccak256(bytes("")), "Access denied. Organizer login required.");
        _;
    }

    modifier onlyParticipant() {
        require(keccak256(bytes(participants[msg.sender].name)) != keccak256(bytes("")), "Access denied. Participant login required.");
        _;
    }

//     function organizerLogin(string memory email, string memory password) public {
//     require(organizers[msg.sender].email != "", "Only the organizer can log in as an organizer.");
//     require(keccak256(bytes(organizers[msg.sender].email)) == keccak256(bytes(email)), "Invalid email.");
//     require(keccak256(bytes(organizers[msg.sender].password)) == keccak256(bytes(password)), "Invalid password.");
//     organizers[msg.sender] = Organizer(email, password);
// }

    

    function participantLogin(string memory name, string memory dob) public {
        require(keccak256(bytes(participants[msg.sender].name)) == keccak256(bytes(name)), "Invalid name.");
        require(keccak256(bytes(participants[msg.sender].dob)) == keccak256(bytes(dob)), "Invalid date of birth.");
        participants[msg.sender] = Participant(name, dob, "", "", "", "", "");
    }

    // function setParticipantAge(uint256 age) public onlyParticipant {
    //     participants[msg.sender].age = age;
    // }

    event HackathonCreated(string message);

function createHackathon(
    string memory _title,
    string memory _community,
    uint _max_team_size,
    string memory _description,
    string memory _app_open,
    string memory _app_close
    
) public returns (uint) {
    Hackathon storage newHackathon = hackathons[projectCount];
        newHackathon.organizer = msg.sender;
        newHackathon.title = _title;
        newHackathon.community = _community;
        newHackathon.description = _description;
        newHackathon.max_team_size = _max_team_size;
        newHackathon.app_open = _app_open;
        newHackathon.app_close = _app_close;
        projectCount++;
        emit HackathonCreated("hackathon created successfully");
        return projectCount - 1;
    
    
}

    function getHackathonParticipants(uint256 hackathonId) public view returns (address[] memory) {
    Hackathon storage hackathon = hackathons[hackathonId];
    return hackathon.participants;
    }

    function joinHackathon(uint256 hackathonId) public onlyParticipant {
    require(hackathons[hackathonId].participants.length < hackathons[hackathonId].max_team_size, "Hackathon team is full.");
    uint256 sandy = uint256(keccak256(abi.encodePacked(hackathons[hackathonId].app_open)));
    require(sandy <= block.timestamp, "Hackathon registration has not started yet.");
    uint256 vishal = uint256(keccak256(abi.encodePacked(hackathons[hackathonId].app_close)));
    require(vishal >= block.timestamp, "Hackathon registration has ended.");
    require(!isParticipantAlreadyRegistered(hackathonId, msg.sender), "You have already registered for this hackathon.");
    hackathons[hackathonId].participants.push(msg.sender);
}

function isParticipantAlreadyRegistered(uint256 hackathonId, address participant) internal view returns (bool) {
    Hackathon storage hackathon = hackathons[hackathonId];
    for (uint256 i = 0; i < hackathon.participants.length; i++) {
        if (hackathon.participants[i] == participant) {
            return true;
        }
    }
    return false;
}



    function getHackathonParticipantCount(uint256 hackathonId) public view returns (uint256) {
    Hackathon storage hackathon = hackathons[hackathonId];
    return hackathon.participants.length;
}

    function getAllHackathons() public view returns (uint256[] memory) {
    uint256[] memory allHackathons = new uint256[](projectCount);
    for (uint256 i = 0; i < projectCount; i++) {
        allHackathons[i] = i;
    }
    return allHackathons;
}

   
    
    
}





