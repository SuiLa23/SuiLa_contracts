module suila_bsa23::wall {
  use sui::object::{Self, UID, ID};
  use sui::transfer;
  use sui::tx_context::{Self, TxContext};
  use sui::dynamic_object_field as ofield;

  use std::string::{utf8, String};

  // The creator bundle: these two packages often go together.
  use sui::package;
  use sui::display;

  use suila_bsa23::badge::{Badge, CertifiedIssuerCap};

  /// ===== Constants =====

	/// ===== Errors =====

  // ======= Structs =======

  // Wall of badges
  struct Wall has key {
    id: UID,
    name: String,
    img_url: String,
  }

  // otw
  struct WALL has drop {}

  // ======= Initializers =======
  fun init(otw: WALL, ctx: &mut TxContext) {
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
        utf8(b"A pure wall that looks & behaves like a wall. What are you expecting?"),
        // Creator field can be any
        utf8(b"Team SuiLa")
    ];

    // Claim the `Publisher` for the package!
    let publisher = package::claim(otw, ctx);

    // Get a new `Display` object for the `Hero` type.
    let display = display::new_with_fields<Wall>(
        &publisher, keys, values, ctx
    );

    // Commit first version of `Display` to apply changes.
    display::update_version(&mut display);

    transfer::public_transfer(publisher, tx_context::sender(ctx));
    transfer::public_transfer(display, tx_context::sender(ctx));
  }

  // ======= Wall CRUD =======
  // Create
  /// Anyone can create a new store for their favorite NFTs, 
  /// and the creator can claim the ownership of the store later by submitting an request to Lootex
  public entry fun mint_wall(_: &CertifiedIssuerCap, to: address, ctx: &mut TxContext) {
    let wall_id = object::new(ctx);

    transfer::transfer(Wall { 
      id: wall_id, 
      name: utf8(b"A Wall :)"),
      img_url: utf8(b"https://images.unsplash.com/photo-1531685250784-7569952593d2?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8d2FsbHxlbnwwfHwwfHx8MA%3D%3D"), 
    }, to);
  }

  public entry fun equip_badge(
    wall: &mut Wall, 
    badge: Badge, 
  ) {
    // Attach Badge to the Wall through badge id
    ofield::add<ID, Badge>(&mut wall.id, object::id(&badge), badge);
  }
  
  public entry fun unequip_badge(
    wall: &mut Wall, 
    badge_id: ID,
    ctx: &mut TxContext,
  ) {
    let badge = ofield::remove<ID, Badge>(&mut wall.id, badge_id);
    let sender = tx_context::sender(ctx);
    
    transfer::public_transfer(badge, sender);
  }
}