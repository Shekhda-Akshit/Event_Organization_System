//Event Organization Contract

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract EventContract
{
    struct Event 
    {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping (uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory _name,uint _date,uint _price,uint _ticketCount) external {
        require(_date>block.timestamp,"You can organize Event for Future Date");
        require(_ticketCount> 0,"You can create Event only if TicketCount is Greater Then 0");

        events[nextId]=Event(msg.sender,_name,_date,_price,_ticketCount,_ticketCount);
        nextId++;
    }

    function buyTicket(uint id,uint quantity) external payable{
        require(events[id].date !=0,"Event Doesnot Exist");//check event exist or not
        require(block.timestamp<events[id].date,"Event is Over");

        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"Ether njot Enough For Payament");
        require(_event.ticketRemain>=quantity,"Not Enough Tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;

    }

    function transferTicket(uint id,uint quantity,address to)external{
        require(events[id].date !=0,"Event Doesnot Exist");//check event exist or not
        require(block.timestamp<events[id].date,"Event is Over");
        require(tickets[msg.sender][id]>=quantity,"You Do Not Have Enough Tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}
