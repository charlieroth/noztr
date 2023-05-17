use serde::Deserialize;
use serde::Serialize;

#[derive(PartialEq, Clone, Debug, Deserialize, Serialize)]
pub struct Event {
    pub id: String,
    pub pubkey: String,
    pub created_at: i64,
    pub kind: i16,
    pub content: String,
    pub tags: Vec<Vec<String>>,
    pub sig: String,
}
