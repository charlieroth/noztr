use std::collections::{HashMap, HashSet};
use serde::Deserialize;
use serde::Serialize;

#[derive(PartialEq, Clone, Debug, Deserialize, Serialize)]
struct Filter {
    ids: Option<Vec<String>>,
    authors: Option<Vec<String>>,
    kinds: Option<Vec<String>>,
    tags: Option<HashMap<char, HashSet<String>>>,
    since: Option<u64>,
    until: Option<u64>,
    limit: Option<u64>,
}