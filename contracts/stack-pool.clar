(define-constant LOCK_PERIOD u100)
(define-constant REWARD_RATE u10) ;; Reward rate per block per token (scaled by 10 for precision)

(define-data-var total-liquidity uint u0)
(define-map user-balances { user: principal } { balance: uint, last-deposit: uint })

;; Add liquidity to the pool
(define-public (add-liquidity (amount uint))
    (begin
        (asserts! (> amount u0) (err u100))
        (let ((user tx-sender)
              (current-block stacks-block-height)) ;; Get current block height
            ;; Update user balance and total liquidity
            (var-set total-liquidity (+ (var-get total-liquidity) amount))
            (map-set user-balances
                { user: user }
                { balance: (+ amount (default-to u0 (get balance (map-get? user-balances { user: user }))))
                  , last-deposit: current-block })
        )
        (ok true)
    )
)

;; Remove liquidity from the pool with penalty if before lock period
(define-public (remove-liquidity (amount uint))
    (begin
        (asserts! (> amount u0) (err u101))
        (let ((user tx-sender))
            (match (map-get? user-balances { user: user })
                user-data
                (let ((current-balance (get balance user-data))
                      (deposit-time (get last-deposit user-data)))
                    (asserts! (>= current-balance amount) (err u102))
                    ;; Calculate penalty if withdrawal is within lock period
                    (let ((penalty (if (< (- stacks-block-height deposit-time) LOCK_PERIOD)
                                      (/ amount u10) ;; 10% penalty
                                      u0)))
                        (var-set total-liquidity (- (var-get total-liquidity) amount))
                        (map-set user-balances
                            { user: user }
                            { balance: (- current-balance amount)
                              , last-deposit: deposit-time })
                        (ok (- amount penalty))
                    )
                )
                (err u103) ;; User has no balance
            )
        )
    )
)

;; Calculate rewards for a user
(define-read-only (calculate-rewards (user principal))
    (match (map-get? user-balances { user: user })
        user-data
        (let ((balance (get balance user-data))
              (deposit-time (get last-deposit user-data)))
            (if (> balance u0)
                (ok (* balance REWARD_RATE (- stacks-block-height deposit-time)))
                (err u104))) ;; No balance
        (err u103)) ;; User not found
)

;; View pool stats including user-specific data
(define-read-only (get-pool-stats (user principal))
    (let ((user-data (map-get? user-balances { user: user })))
        {
            total-liquidity: (var-get total-liquidity),
            user-balance: (default-to u0 (get balance user-data)),
            user-rewards: (match (calculate-rewards user)
                            success-result success-result
                            error-code u0)
        }
    )
)