# q-option-pricing

Option pricing library for q by [KX](https://kx.com), includes implementations for:

- Black Scholes
- Monte Carlo
- Cox-Ross-Rubenstein binomial
- Garman–Kohlhagen

## Get Started

Install kdb+ from [kx.com](https://kx.com) and [rlwrap](https://kx.com/blog/unwrapping-rlwrap/)

Move to the q-option-pricing directory

```shell
cd ./q-option-pricing/
```

Start q (example for macOS)

```shell
rlwap ~/q/m64/q
```

Load the library

```q
\l ./loadall.q
```

Examples of calculating the price of a call

```q
q).bs.c.price[420;420.04;0.8;0.17;0.05]
34.02261
q).mc.c.price[420;420.04;0.8;0.17;0.05;1000]
33.89279
q).crr.c.price[420;420.04;0.8;0.17;0.05;1000]
34.01666
```
