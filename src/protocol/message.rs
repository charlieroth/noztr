use std::collections::VecDeque;

use crate::protocol::event::Event;
use serde::Deserialize;
use serde::Serialize;

#[derive(PartialEq, Clone, Debug, Deserialize, Serialize)]
pub enum MessageCategory {
    EVENT,
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
    pub fn from_data(mut data: VecDeque<MessageData>) -> Result<Message, &'static str> {
        match data.pop_front().unwrap() {
            MessageData::MsgType(msg) => match match msg {
                MessageCategory::EVENT => Message::from_event(data),
            } {
                None => Err("Could not decode message"),
                Some(message) => Ok(message),
            },
            _ => Err("Could not decode message"),
        }
    }

    pub fn from_event(mut data: VecDeque<MessageData>) -> Option<Message> {
        if let MessageData::Event(event) = data.pop_front().unwrap() {
            Some(Message::Event(event))
        } else {
            None
        }
    }
}
