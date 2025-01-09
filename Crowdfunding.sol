// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 pledged;
        bool completed;
    }

    mapping(uint256 => Campaign) public campaigns;
    uint256 public campaignCount;

    function createCampaign(uint256 goal) public {
        campaignCount++;
        campaigns[campaignCount] = Campaign(msg.sender, goal, 0, false);
    }

    function pledge(uint256 campaignId) public payable {
        Campaign storage campaign = campaigns[campaignId];
        require(!campaign.completed, "Campaign already completed");
        campaign.pledged += msg.value;
    }

    function withdraw(uint256 campaignId) public {
        Campaign storage campaign = campaigns[campaignId];
        require(msg.sender == campaign.creator, "Not the campaign creator");
        require(campaign.pledged >= campaign.goal, "Goal not reached");
        require(!campaign.completed, "Already completed");

        campaign.completed = true;
        payable(campaign.creator).transfer(campaign.pledged);
    }
}
