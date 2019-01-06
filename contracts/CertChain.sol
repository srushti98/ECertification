pragma solidity 0.5.0;

contract CertChain {
    uint public certificate_counter;

    // Structure
    struct Certificate {
        string ipfsHash;
        uint timeOfIssue;
        address issuer;
        address recipient;
        string ctype;
        string cname;
        string cdesc;
    }

    // Mappings
    mapping(string => address) issuerOfCertificate;
    mapping(address => string) issuer;
    mapping(address => string) recipient;
    mapping(string => address[]) allRecipientOfCertificate;
    mapping(uint => Certificate) certificateIdentifier;
    mapping(address => uint[]) recipientCertificates;
    mapping(address => uint[]) issuerCertificates;
    mapping(address => bool) isIssuer;
    mapping(address => bool) isRecipient;
    mapping(string => address) recipient_hash_mapping; 
    mapping(string => bool) isRecipient_hash_mapping;

    // Events
    event IssuerRegistered(address indexed issuer, string IPFS_hash);
    event RecipientRegistered(address indexed recipient, string IPFS_hash);
    event CertificateRegistered(address indexed issuer, string IPFS_hash);
    event CertificateIssued(uint indexed certificate, address indexed issuer, address indexed recipient);

    // Functions
    function registerIssuer(string memory IPFS_hash) public {
        require((isIssuer[msg.sender] == false), "Issuer already registered");
        issuer[msg.sender] = IPFS_hash;
        isIssuer[msg.sender] = true;
        emit IssuerRegistered(msg.sender, IPFS_hash);
    }

    function registerRecipient(string memory IPFS_hash) public {
        require(isRecipient[msg.sender] == false, "Recipient already registered");
        recipient[msg.sender] = IPFS_hash;
        isRecipient[msg.sender] = true;
        emit RecipientRegistered(msg.sender, IPFS_hash);
    }

    function registerCertificate(string memory IPFS_hash) public {
        require(isIssuer[msg.sender] == true, "Issuer not registered to register a certificate");
        issuerOfCertificate[IPFS_hash] = msg.sender;
        isRecipient_hash_mapping[IPFS_hash] = false;  
        emit CertificateRegistered(msg.sender, IPFS_hash);
    }

    function issueCertificate(address _recipient, string memory certificate_hash,string memory c_name,string memory c_type,string memory c_desc, uint temp_flag) public {
        require(isIssuer[msg.sender] == true, "Issuer not registered to register a certificate");
        require(isRecipient[_recipient] == true, "Recipient not registered to be issued a certificate");
        require(issuerOfCertificate[certificate_hash] == msg.sender, "Issuer not registered to issue this certificate");
        require(isRecipient_hash_mapping[certificate_hash] == false, "Duplicate certificate");
        recipient_hash_mapping[certificate_hash] = _recipient; 
        isRecipient_hash_mapping[certificate_hash] = true;   
        Certificate memory cert;
        uint temp1;
        uint id = ++certificate_counter;
        cert.ipfsHash = certificate_hash;
        cert.timeOfIssue = now;
        cert.issuer = msg.sender;
        cert.recipient = _recipient;
        cert.ctype=c_type;
        cert.cname=c_name;
        cert.cdesc=c_desc;
        certificateIdentifier[id] = cert;
        temp1 = id + temp_flag;
        // recipientCertificates[_recipient].push(id);
        // issuerCertificates[msg.sender].push(id);
         recipientCertificates[_recipient].push(id);
         issuerCertificates[msg.sender].push(temp1);
        allRecipientOfCertificate[certificate_hash].push(_recipient);
        emit CertificateIssued(id, msg.sender, _recipient);
    }

    function getIssuerOfCertificate(string memory IPFS_hash) public view returns (address) {
        return issuerOfCertificate[IPFS_hash];
    }

    function getIssuer(address _issuer) public view returns (string memory) {
        return issuer[_issuer];
    }

    function getRecipient(address _recipient) public view returns (string memory) {
        return recipient[_recipient];
    }

    function getAllRecipientOfCertificate(string memory IPFS_hash) public view returns (address[] memory) {
        return allRecipientOfCertificate[IPFS_hash];
    }

    function getRecipientCertificates(address _recipient) public view returns (uint[] memory) {
        return recipientCertificates[_recipient];
    }

    function getIssuerCertificates(address _issuer) public view returns (uint[] memory) {
        return issuerCertificates[_issuer];
    }

    function getCertificateIdentifier(uint _id) public view returns (string memory, uint, address, address, string memory, string memory, string memory){
        Certificate memory cert = certificateIdentifier[_id];
        return (cert.ipfsHash, cert.timeOfIssue, cert.issuer, cert.recipient, cert.ctype,cert.cname,cert.cdesc);
    }

}
