use crate::Request;
use crate::protocol::event::Event;
use serde::Deserialize;
use serde::Serialize;

#[derive(PartialEq, Clone, Debug, Deserialize, Serialize)]
pub enum MessageCategory {
    EVENT,
    REQ,
}

#[derive(PartialEq, Clone, Debug, Deserialize, Serialize)]
#[serde(untagged)]
pub enum MessageData {
    MsgType(MessageCategory),
    Event(Event),
}

pub enum Message {
    Event(Event),
}

impl Message {
    pub fn from_request(mut request: Request) -> Result<Message, &'static str> {
        match request.pop_front().unwrap() {
            MessageData::MsgType(msg) => match match msg {
                MessageCategory::EVENT => Message::from_event(request),
                MessageCategory::REQ => Message::from_request_subscription(request),
            } {
                None => Err("Could not decode message"),
                Some(message) => Ok(message),
            },
            _ => Err("Could not decode message"),
        }
    }

    pub fn from_event(mut request: Request) -> Option<Message> {
        if let MessageData::Event(event) = request.pop_front().unwrap() {
            Some(Message::Event(event))
        } else {
            None
        }
    }

    pub fn from_request_subscription(mut request: Request) -> Option<Message> {
        if let MessageData::
    }
}
