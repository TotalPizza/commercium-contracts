// SPDX-License-Identifier: MIT
// @author FreshPizza

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                             //
//   Main contract that acts as a security layer and the main contact point for any trader/protocol utilizing the Commercium.  //
//                                                                                                                             // 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#[contract]
mod Hub {

    /////////////////////////////
    //         Storage         //
    /////////////////////////////

    struct Storage {
        trade_executor: felt,
        solver_registry: felt,
    }

    /////////////////////////////
    //       Constructor       //
    /////////////////////////////

    //@notice initialize the HUB contract
    //@param _owner - The initial owner of the Hub contract
    #[constructor]
    fn constructor(
        _owner: felt, _execution_hash: felt
    ) {
        trade_executor::write(_execution_hash);
        // Set owner
        // owner::write(_owner);
        return ();
    }

    ////////////////////////
    //       Views        //
    ////////////////////////

    // @notice get the address of the utilized solver registry
    // @return solver registry address
    #[view]
    fn solver_registry() -> felt {
        solver_registry::read()
    }

    // @notice get the contract hash of the utilized trade executor
    // @return trade executor hash
    #[view]
    fn trade_executor() -> felt {
        trade_executor::read()
    }

    // @notice This function returns the expected return amount for a given trade when using the default solver
    // @param _amount_in - The number of tokens that are supposed to be sold
    // @param _token_in - The address of the token that would be sold
    // @param _token_out - The address of the token that would be bought
    // @return amount - The estimated amount of tokens received
    #[view]
    fn get_amount_out(
        _amount_in: uint256, 
        _token_in: felt,
        _token_out: felt
    ) -> u256 {
        let (amount_out) = Hub.get_solver_amount(
            _amount_in=_amount_in, _token_in=_token_in, _token_out=_token_out, _solver_id=1
        );
        amount_out;
    }

    ////////////////////////////
    //       Externals        //
    ////////////////////////////

    // @notice Swap an exact amount of a token for largest possible amount of another token.
    //         This function makes use of the default solver
    // @param _amount_in - The number of tokens that are supposed to be sold
    // @param _amount_out_min - The minimum number of _token_out that have to be bought (fails if not reached)
    // @param _token_in - The address of the token that would be sold
    // @param _token_out - The address of the token that would be bought
    // @param _to - The receiver address of the bought tokens
    // @return received_amount - The token return amounts for each solver
    #[external]
    fn  swap_exact_tokens_for_tokens(
        _amount_in: uint256, 
        _amount_out_min: uint256, 
        _token_in: felt,
        _token_out: felt,
        _to: felt
    ) -> uint256 {
        // Execute swap with solver 1 as the default
        received_amount: uint256 = Hub.swap_with_solver(
            _token_in, _token_out, _amount_in, _amount_out_min, _to, 1
        );
        received_amount;
    }

    // @notice Swap between two tokens by providing the exact routers and token address to be used. Aka the exat path to take.
    // @param _routers - An array of routers to be used for the trades
    // @param _path - An array of token pairs to trade
    // @param _amounts - An array of token amounts (in %) to sell
    // @param _amount_in - The initial token to sell
    // @param _min_amount_out - The minimum amount of tokens to receive (will be the path.token_out of the last item in the path array)
    // @return received_amount - The token return amounts for each solver
    #[external]
    fn swap_with_path(
        _routers_len: felt,
        _routers: Router*,
        _path_len: felt,
        _path: Path*,
        _amounts_len: felt,
        _amounts: felt*,
        _amount_in: uint256,
        _min_amount_out: uint256,
    ) -> uint256 {
        // Reentracy guard
        let received_amount: uint256 = Hub.swap_with_path(
            _routers_len=_routers_len,
            _routers=_routers,
            _path_len=_path_len,
            _path=_path,
            _amounts_len=_amounts_len,
            _amounts=_amounts,
            _amount_in=_amount_in,
            _min_amount_out=_min_amount_out,
        );

        // Reentracy guard end
        return received_amount;
    }

    ////////////////////////
    //       Admin        //
    ////////////////////////

    // @notice Set the address of the solver registry which will be used to validate solver IDs
    // @param _new_registry - The address of the new solver registry 
    #[external]
    fn set_solver_registry(
        _new_registry: felt
    ) -> () {
        //Only owner
        Hub.set_solver_registry(_new_registry);
    }

    // @notice Set the new execution logic for trades
    // @param _execution_hash - The class hash of the new transaction execution logic
    #[external]
    fn set_executor(
        _execution_hash: felt
    ) {
        //Only owner
        Hub_trade_executor.write(_execution_hash);
    }
}