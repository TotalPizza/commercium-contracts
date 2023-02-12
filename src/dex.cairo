
// Stores all relevant Dex information
struct Dex {
    // ID
    id: u8,
    // Factory address
    factory: felt,
    // Trade fee
    fee: u16,
    // Price Curve (ENUMS: 0 = UniV2, 1 = UniV3, 2 = Curve)
    curve: u8,
}

// Dex trait
trait DexTrait {
    // Create a new Dex
    fn new(call_context: CallContext) -> ExecutionContext;
    // Get the returned amount for a given token swap
    fn get_amount_out(ref self: Dex);
}

// Dex implementation.
impl DexImpl of DexTrait {

    // Compute the intrinsic gas cost for the current transaction and increase the gas used.
    // TODO: Implement this. For now we just increase the gas used by a hard coded value.
    fn get_amount_out(ref self: Dex) {
    }
}