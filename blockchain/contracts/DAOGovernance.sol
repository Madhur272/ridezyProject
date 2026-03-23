// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DAOGovernance is Ownable {

    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 deadline;
        bool executed;
    }

    uint256 public proposalCount;

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 id, string description);
    event Voted(uint256 proposalId, address voter, bool support);
    event ProposalExecuted(uint256 proposalId);

    uint256 public votingDuration = 7 days;

    // Create proposal
    function createProposal(string memory description) external {

        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            deadline: block.timestamp + votingDuration,
            executed: false
        });

        emit ProposalCreated(proposalCount, description);

        proposalCount++;
    }

    // Vote on proposal
    function vote(uint256 proposalId, bool support) external {

        Proposal storage p = proposals[proposalId];

        require(block.timestamp < p.deadline, "Voting ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;

        if (support) {
            p.votesFor++;
        } else {
            p.votesAgainst++;
        }

        emit Voted(proposalId, msg.sender, support);
    }

    // Execute proposal
    function executeProposal(uint256 proposalId) external {

        Proposal storage p = proposals[proposalId];

        require(block.timestamp >= p.deadline, "Voting ongoing");
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Not approved");

        p.executed = true;

        emit ProposalExecuted(proposalId);

        // Future: trigger actions (fee change, rules update)
    }

    function getProposal(uint256 proposalId) external view returns (Proposal memory) {
        return proposals[proposalId];
    }
}