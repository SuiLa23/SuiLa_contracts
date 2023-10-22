// module suila_bsa23::question {
//   use sui::object::{Self, UID, ID};
//   use sui::transfer;
//   use sui::tx_context::{Self, TxContext};
//   use sui::dynamic_object_field as ofield;
//   use sui::clock::{Self, Clock};
//   use sui::coin::{Coin};
//   use sui::sui::{Self, SUI};
  

//   /// ===== Constants =====
//   const RECEIVING_ACCOUNT: address = 0x123; 

// 	/// ===== Errors =====

//   // ======= Structs =======

//   struct Question has key {
//     id: UID,
//     difficulty: u64,
//     sensitivity: u64,
//     validity: bool,
//   }

//   // ======= Initializers =======
//   // fun init(ctx: &mut TxContext) {
//   // }

//   // ======= Wall CRUD =======
//   // Create
//   /// Anyone can create a new store for their favorite NFTs, 
//   /// and the creator can claim the ownership of the store later by submitting an request to Lootex
//   public entry fun mint_question(
//     coin: Coin<SUI>, 
//     ctx: &mut TxContext,
//   ) {
//     let question_id = object::new(ctx);
//     let sender = tx_context::sender(ctx);

//     sui::transfer(coin, RECEIVING_ACCOUNT);
//     transfer::transfer(Question {
//       id: question_id,
//       difficulty: 0,
//       sensitivity: 0,
//       validity: false,
//     }, sender);
//   }
// }