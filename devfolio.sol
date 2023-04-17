//SPDX-License-Identifier:MIT
pragma solidity ^0.8.1;

contract Devfolio {
    struct Organizer {
        string name;
        string email;
        string password;
        bool authorized;
    }

    struct Participant {
        string name;
        string company_name;
        string no_ex_code;
        bool githublink;
        bool linkedinlink;
        bool twitterlink;
        string email;
        string ph_no;
    }

    struct Hackathon {
        string name;
        string tagline;
        string theme;
        uint256 max_players;
        uint256 app_open;
        uint256 app_close;
        string venue;
        string email;
        string phone_number;
    }

    address public organizer;
    uint256 public projectCount;
    enum Login { Organizer, Participant }
    Login public login;

    mapping(address => Hackathon[]) public projects;
    mapping(address => Organizer) public organizers;
    mapping(address => Participant) public participants;

    constructor() {
        organizer = msg.sender;
    }

    modifier onlyOrganizer() {
        require(login == Login.Organizer, "Access denied. Organizer login required.");
        _;
    }

    modifier onlyParticipant() {
        require(login == Login.Participant, "Access denied. Participant login required.");
        _;
    }

    function organizerLogin(string memory email, string memory password) public {
        require(msg.sender == organizer, "Only the organizer can log in as an organizer.");
        require(keccak256(bytes(organizers[msg.sender].email)) == keccak256(bytes(email)), "Invalid email.");
        require(keccak256(bytes(organizers[msg.sender].password)) == keccak256(bytes(password)), "Invalid password.");
        login = Login.Organizer;
    }

    // function participantLogin(string memory name, string memory dob) public {
    //     require(keccak256(bytes(participants[msg.sender].name)) == keccak256(bytes(name)), "Invalid name.");
    //     require(keccak256(bytes(participants[msg.sender].dob)) == keccak256(bytes(dob)), "Invalid date of birth.");
    //     login = Login.Participant;
    // }

    function createProject(
        string memory _name,
        string memory _tagline,
        string memory _theme,
        uint256 _max_players,
        uint256 _app_open,
        uint256 _app_close,
        string memory _venue,
        string memory _email,
        string memory _phone_number
    ) public onlyOrganizer {
        Hackathon memory newProject = Hackathon(
            _name,
            _tagline,
            _theme,
            _max_players,
            _app_open,
            _app_close,
            _venue,
            _email,
            _phone_number
        );
        projects[msg.sender].push(newProject);
        projectCount++;
    }

    function applyForProject(
        string memory name,
        string memory company_name,
        string memory no_ex_code,
        bool githublink,
        bool linkedinlink,
        bool twitterlink,
        string memory email,
        string memory ph_no
    ) public onlyParticipant {
        Participant storage participant = participants[msg.sender];
        participant.name = name;
        participant.company_name = company_name;
        participant.no_ex_code = no_ex_code;
        participant.githublink = githublink;
        participant.linkedinlink = linkedinlink;
        participant.twitterlink = twitterlink;
        participant.email = email;
        participant.ph_no = ph_no;
    }
}
