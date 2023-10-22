module suila_bsa23::badge {
  use sui::object::{Self, UID};
  use sui::transfer;
  use sui::tx_context::{Self, TxContext};
  use sui::clock::{Self, Clock};

  use std::string::{utf8, String};

  // The creator bundle: these two packages often go together.
  use sui::package;
  use sui::display;

  /// ===== Constants =====

	/// ===== Errors =====

  // ======= Structs =======

  // For creating badges
  struct CertifiedIssuerCap has key {
    id: UID
  }

  // Badge
  struct Badge has key, store {
    id: UID,
    name: String,
    img_url: String,
    issuer: address,
    receiver: address,
    difficulty_level: u64,
    confidence_level: u64,
    valid_until: u64, // timestamp
  }

  // otw
  struct BADGE has drop {}

  // ======= Initializers =======
  fun init(otw: BADGE, ctx: &mut TxContext) {
    let issuer_cap_id = object::new(ctx);
    let sender = tx_context::sender(ctx);

    transfer::transfer(CertifiedIssuerCap { id: issuer_cap_id }, sender);

    let keys = vector[
        utf8(b"name"),
        utf8(b"image_url"),
        utf8(b"description"),
        utf8(b"creator"),
    ];

    let values = vector[
        // For `name` we can use the `Hero.name` property
        utf8(b"{name}"),
        // For `image_url` we use an IPFS template + `img_url` property.
        utf8(b"{img_url}"),
        // Description is static for all `Hero` objects.
        utf8(b"A badge that you can put on that boring wall."),
        // Creator field can be any
        utf8(b"Team SuiLa")
    ];

    // Claim the `Publisher` for the package!
    let publisher = package::claim(otw, ctx);

    // Get a new `Display` object for the `Hero` type.
    let display = display::new_with_fields<Badge>(
        &publisher, keys, values, ctx
    );

    // Commit first version of `Display` to apply changes.
    display::update_version(&mut display);

    transfer::public_transfer(publisher, tx_context::sender(ctx));
    transfer::public_transfer(display, tx_context::sender(ctx));
  }

  public entry fun mint_badge(
    _: &CertifiedIssuerCap,
    clock: &Clock,
    receiver: address,
    valid_time: u64, // in ms
    difficulty_level: u64,
    confidence_level: u64,
    ctx: &mut TxContext,
  ) {
    let badge_id = object::new(ctx);
    let issuer = tx_context::sender(ctx);

    transfer::transfer(Badge {
      id: badge_id,
      issuer,
      receiver,
      valid_until: clock::timestamp_ms(clock) + valid_time,
      name: utf8(b"A badge :)"),
      img_url: utf8(b"https://juststickers.in/wp-content/uploads/2017/06/try-harder-badge.png"), 
      difficulty_level,
      confidence_level,
    }, receiver)
  }
}