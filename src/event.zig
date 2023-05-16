pub const EventKind = enum {
  SetMetadata,
  TextNote
  RecommendServer,
  ContactList,
  EncryptedDirectMessage,
  Delete,
  Repost,
  Reaction,
  // Channels
  ChannelCreation,
  ChannelMetadata,
  ChannelMessage,
  ChannelHideMessaage,
  ChannelHideUser,
  ChannelMuteUser,
  ChannelReservedFirst,
  ChannelReservedLast,
  // Relay-only
  RelayInvite,
  InvoiceUpdate,
  // Lightning zaps
  ZapRequest,
  ZapReceipt,
  // Replaceable events
  ReplaceableFirst,
  ReplaceableLast,
  // Ephemeral events
  EphemeralFirst,
  EphemeralLast,
  // Parameterized replaceable events
  ParameterizedReplaceableFirst,
  ParameterizedReplaceableLast,
  UserApplicationFirst,
};

pub fn eventKindRawValue(kind: EventKind) u64 {
  switch(kind) {
    .SetMetadata => 0,
    .TextNote => 1,
    .RecommendServer => 2,
    .ContactList => 3,
    .EncryptedDirectMessage => 4,
    .Delete => 5,
    .Repost => 6,
    .Reaction => 7,
    .ChannelCreation => 40,
    .ChannelMetadata => 41,
    .ChannelMessage => 42,
    .ChannelHideMessaage => 43,
    .ChannelMuteUser => 44,
    .ChannelReservedFirst => 45,
    .ChannelReservedLast => 49,
    .RelayInvite => 50,
    .InvoiceUpdate => 402,
    .ZapRequest => 9734,
    .ZapReceipt => 9735,
    .ReplaceableFirst => 10000,
    .ReplaceableLast => 19999,
    .EphemeralFirst => 20000,
    .EphemeralLast => 29999,
    .ParameterizedReplaceableFirst => 30000,
    .ParameterizedReplaceableLast => 39999,
    .UserApplicationFirst => 40000,
    else => {
      std.debug.print("Event kind unknown \n");
      return 99999;
    }
  }
}

pub const EventTag = enum {
  Event,
  Pubkey,
  Multicast
  Delegation,
  Deduplication,
  Expiration,
  Invoice,
}

pub fn eventTagRawValue(tag: EventTag) []const u8 {
  switch (tag) {
    .Event => "e",
    .Pubkey => "p",
    .Multicast => "m",
    .Delegation => "delegation",
    .Deduplication => "d",
    .Expiration => "expiration",
    .Invoice => "bolt11",
    else => {
      std.debug.print("Event tag unknown \n");
      return "unknown";
    }
  }
}

pub const Event = struct {
  id: []const u8,
  pubkey: []const u8,
  created_at: u64,
  kind: EventKind,
};
