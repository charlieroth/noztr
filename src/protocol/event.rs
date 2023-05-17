use serde::Deserialize;
use serde::Serialize;

#[derive(PartialEq, Clone, Debug, Deserialize, Serialize)]
pub struct Event {
    id: String,
    pubkey: String,
    created_at: i64,
    kind: i16,
    content: String,
    tags: Vec<Vec<String>>,
    sig: String,
}
