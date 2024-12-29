# StackPool

## Overview
StackPool is a decentralized liquidity pool smart contract built using the Clarity programming language on the Stacks blockchain. It allows users to deposit and withdraw tokens, earn proportional rewards based on their contributions and staking duration, and promotes fair and transparent liquidity management.

### Features
- **Deposit Liquidity:** Users can add tokens to the pool, increasing the total liquidity.
- **Withdraw Liquidity:** Tokens can be withdrawn, with penalties applied for early withdrawals (before the lock period).
- **Reward Distribution:** Rewards are calculated based on the duration of deposit and proportional to the user's contribution.
- **Pool Statistics:** Users can view their balances, pending rewards, and the total liquidity in the pool.

## Smart Contract Details

### Constants
- `LOCK_PERIOD (u100)`: The minimum number of blocks a user must wait to avoid withdrawal penalties.
- `REWARD_RATE (u10)`: The reward rate per block per token, scaled by 10 for precision.

### Data Variables
- `total-liquidity (uint)`: Tracks the total tokens deposited in the pool.
- `user-balances (map)`: Stores each user's balance and their last deposit block.

### Functions

#### 1. `add-liquidity`
- **Description:** Allows users to add tokens to the liquidity pool.
- **Parameters:**
  - `amount (uint)`: The number of tokens to deposit.
- **Logic:**
  - Updates the user's balance and the total liquidity.
  - Records the block height at the time of deposit.
- **Errors:**
  - `u100`: Amount must be greater than zero.

#### 2. `remove-liquidity`
- **Description:** Allows users to withdraw tokens from the pool.
- **Parameters:**
  - `amount (uint)`: The number of tokens to withdraw.
- **Logic:**
  - Applies a 10% penalty if withdrawal occurs within the lock period.
  - Updates the user's balance and the total liquidity.
- **Errors:**
  - `u101`: Amount must be greater than zero.
  - `u102`: Insufficient balance.
  - `u103`: User has no balance.

#### 3. `calculate-rewards`
- **Description:** Calculates the rewards for a user based on their deposit duration and balance.
- **Parameters:**
  - `user (principal)`: The user’s principal address.
- **Logic:**
  - Rewards are proportional to the deposit amount and the time elapsed since the deposit.
- **Errors:**
  - `u103`: User not found.
  - `u104`: No balance to calculate rewards.

#### 4. `get-pool-stats`
- **Description:** Provides statistics about the pool and a specific user's account.
- **Parameters:**
  - `user (principal)`: The user’s principal address.
- **Returns:**
  - `total-liquidity`: The total tokens in the pool.
  - `user-balance`: The user’s balance.
  - `user-rewards`: The user’s pending rewards.

## Usage

### Deployment
1. Deploy the smart contract to the Stacks blockchain using Clarinet or another compatible tool.
2. Ensure users interact with the contract using their Stacks wallet.

### Interaction
- Use `add-liquidity` to deposit tokens.
- Use `remove-liquidity` to withdraw tokens, adhering to the lock period to avoid penalties.
- Use `get-pool-stats` to monitor liquidity, balances, and rewards.

## Testing
The contract includes comprehensive tests written with Clarinet to verify:
- Correct updates to balances and total liquidity after deposits and withdrawals.
- Proper reward calculations based on deposit duration.
- Handling of edge cases, such as insufficient balances or early withdrawals.

### Sample Tests
- Verify deposits and withdrawals.
- Simulate reward distribution over time.
- Test edge cases for error handling.

## Future Enhancements
- **Frontend Integration:** Build a user-friendly interface for seamless interaction with the smart contract.
- **Advanced Analytics:** Add features for detailed pool activity and user rankings.
- **Multi-token Support:** Expand to support multiple tokens in the liquidity pool.

## License
This project is open-source and available under the MIT License.

