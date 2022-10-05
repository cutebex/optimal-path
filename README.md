# etherlands-alpha
Let's do a little recap on the uniswap constant function market maker(CFMM) model, assume there is a trading pair for coin A and B, reserve for A is , reserve for B is , now we use  amount of A to trade for  amount of B, assume the fee is , the following equation holds:

$(R_0 + r\Delta_a)(R_1 - \Delta_b) = R_0R_1$

The equation means that the product of the reserves $R_0R_1$ remains constant during the trade, this is why we call it constant function market maker.

Now assume we have found a circle path: A->B->C->A, how do we find the optimal input amount? This is an optimization problem: $$ \begin{align} & max ({\Delta_a}' - \Delta_a) \\ & s.t. \ & R_n > 0, \Delta_n > 0 \\ & (R_0 + r\Delta_a)(R_1 - \Delta_b) = R_0R_1 \tag1 \\ & ({R_1}' + r\Delta_b)(R_2 - \Delta_c) = {R_1}'R_2 \tag2 \\ & ({R_2}' + r\Delta_c)(R_3 - {\Delta_a}') = {R_2}'{R_1}' \tag3 \end{align} $$ Equation (1) holds during the trade from A to B, (2) holds during the trade from B to C, and (3) holds during the trade from C to A. It seems pretty simple since we only have 3 equations now, we can get the representation for ${\Delta_a}'$ in ${\Delta_a}$, then calculate the derivative of ${\Delta_a}' - \Delta_a$ to find out what the optimal ${\Delta_a}$ is.

What if the path is longer? A->B->C->...->A. We need a general solution for arbitrary length path.

Consider the A->B->C situation, maybe there is not a trading pair directly from A to C, but with B as the bridge, we can trade A for C, we say there is a virtual trading pool for A and C, can we get the reserves parameter $E_0, E_1$ for this virtual pool?

All we need to do is find the representation for $E_0, E_1$ in $R_0, R_1, {R_1}', R_2$, i.e. the pool parameters of A->B and B->C.

According to equation(1)(2), we have: $$ \Delta_b = \frac{R_1r\Delta_a}{R_0+r\Delta_a} \tag4 $$