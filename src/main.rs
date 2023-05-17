mod protocol {
    pub mod event;
    pub mod filter;
    pub mod kind;
    pub mod message;
}

use crate::protocol::message::{MessageData, Message};
use crate::protocol::event::Event;
use std::collections::VecDeque;

pub type Request = VecDeque<MessageData>;

fn main() {
    println!("Hello noztr");
}

pub fn deserialize_request(message: &str) -> Request {
    let request: VecDeque<MessageData> = match serde_json::from_str(message) {
        Err(err) => {
            panic!("Parsing message data error: {}", err);
        }
        Ok(request) => request,
    };

    return request;
}

pub fn categorize_request(request: Request) -> Event {
    let result = match Message::from_request(request) {
        Err(err) => {
            panic!("unsupported message data format: {}", err);
        }
        Ok(message) => match message {
            Message::Event(event) => {
               event
            },
        },
    };

    return result;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_event_request() {
        let message: &str = r#"
        [
            "EVENT",
            {
                "id": "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65",
                "pubkey": "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93",
                "created_at": 1673347337,
                "kind": 1,
                "content": "Walled gardens became prisons, and nostr is the first step towards tearing down the prison walls.",
                "tags": [
                    ["e", "3da979448d9ba263864c4d6f14984c423a3838364ec255f03c7904b1ae77f206"],
                    ["p", "bf2376e17ba4ec269d10fcc996a4746b451152be9031fa48e74553dde5526bce"]
                ],
                "sig": "908a15e46fb4d8675bab026fc230a0e3542bfade63da02d542fb78b2a8513fcd0092619a2c8c1221e581946e0191f2af505dfdf8657a414dbca329186f009262"
            }
        ]"#;

        let request: Request = deserialize_request(message);
        assert_eq!(request.len(), 2);

        let event: Event = categorize_request(request);
        assert_eq!(event.id, "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65");
        assert_eq!(event.tags.len(), 2);
    }

    #[test]
    fn parses_req_request() {
        let message: &str = r#"
        [
            "REQ",
            "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65",
            {
                "ids": [
                    "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65",
                    "3da979448d9ba263864c4d6f14984c423a3838364ec255f03c7904b1ae77f206",
                ]
            }
        ]"#;
        
        let request: Request = deserialize_request(message);
        assert_eq!(request.len(), 2);
    }
}
