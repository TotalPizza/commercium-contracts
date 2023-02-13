enum Curve {
    UniV2: felt,
    Stable: felt,
    UniV3: felt
}

// Stores all relevant Dex information
struct Dex {
    // Factory address
    factory: felt,
    // Trade fee
    fee: u16,
    // Price curve
    curve: Curve,
}

// Dex trait
trait DexTrait {
    // Create a new Dex
    fn new(factory_address: felt, fee: u16, curve: Curve) -> Dex;
    // Get the returned amount for a given token swap
    fn get_amount_out(ref self: Dex, reserve_in: uin256, reserve_out: uin256, amount_in: u256);
}

// Dex implementation.
impl DexImpl of DexTrait {

    fn new(factory_address: felt, fee: u16, curve: Curve) -> Dex {
        Dex {
            factory: factory_address,
            fee: fee,
            curve: curve,
        }
    }

    // Get reserves of specified pair
    fn get_reserves(ref self: Dex, token_a: felt, token_b: felt) -> (u256, u256) {
        // Get Pair Depending on Factory Interface
        //let pair = self.factory.get_pair(token_a, token_b);

        // Get Reserves Depending on Pair Interface
        //let reserve_a = pair.get_reserve(token_a);
        //let reserve_b = pair.get_reserve(token_b);
        //(reserve_a, reserve_b)
    }

    // Compute the amount of received tokens for a given 
    fn get_amount_out(ref self: Dex, reserve_in: uin256, reserve_out: uin256, amount_in: u256) -> u256 {
        match self.curve {
            Curve::UniV2(x) => {
                let amount_out = uniV2_amount_out(reserve_in, reserve_out, amount_in);
                amount_out
            },
            Curve::Stable(x) => {
                let amount_out = stable_amount_out(reserve_in, reserve_out, amount_in);
                amount_out
            },
            Curve::UniV3(x) => {
                let amount_out = uniV3_amount_out(reserve_in, reserve_out, amount_in);
                amount_out
            },
        }
    }
}