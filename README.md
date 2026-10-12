# Starcrossed

Pick two zodiac signs, get a playful compatibility score, and seal the reading on BOT Chain so anyone can look it up by ID.

*For entertainment only.*

## Status

| | |
|---|---|
| Live site | _TBD_ |
| Contract (BOT Chain mainnet, chain ID 677) | [`0x35b05ce3b8254C4BAFaE7AE912b1018dF5e71376`](https://scan.botchain.ai/address/0x35b05ce3b8254C4BAFaE7AE912b1018dF5e71376) |
| Contract (testnet, chain ID 968) | _not deployed yet_ |

## Project layout

- `index.html` — the whole frontend (ethers.js v6 from CDN, no build step, no backend)
- `contracts/Starcrossed.sol` — the contract (Solidity ^0.8.20)
- `deploy.html` — one-click deploy from MetaMask (compiled bytecode embedded)
- `build/Starcrossed.standard-input.json` — compiler input for explorer verification

## Run locally

```bash
python3 -m http.server 4577
```

Then open http://localhost:4577. Until a contract address is configured the site runs in **preview mode**: scores come from the mirrored table and "sealing" is simulated in your browser's localStorage, so every screen can be reviewed before deploying.

## Deploy the contract

The contract compiles with Solidity 0.8.20 (optimizer 200 runs, EVM `paris`) and has been dry-run against both BOT Chain RPCs.

**Easiest: the built-in deploy page**

1. Run the site locally and open http://localhost:4577/deploy.html in a browser with MetaMask.
2. Click **Deploy to Testnet (968)**, confirm in MetaMask, and try the app at http://localhost:4577/?net=testnet (on localhost the app picks up the address you just deployed automatically).
3. Click **Deploy to Mainnet (677)** — about 0.01 BOT in gas.
4. Paste each address into the matching `contract: ''` field in the `NETWORKS` config near the top of the script in `index.html`, and into the Status table above. Preview mode switches off for that network.

**Or Remix:** paste `contracts/Starcrossed.sol` into https://remix.ethereum.org, compile with 0.8.20 and EVM version `paris`, deploy with *Injected Provider – MetaMask*.

| Network | Chain ID | RPC | Explorer |
|---|---|---|---|
| Testnet | 968 | https://rpc.bohr.life | https://scan.bohr.life |
| Mainnet | 677 | https://rpc.botchain.ai | https://scan.botchain.ai |

To verify the source on the explorer, use "Standard JSON input" with `build/Starcrossed.standard-input.json` and compiler `v0.8.20+commit.a1b79de6`.

## How it works

- The score comes from a fixed 12×12 table stored in the contract (`TABLE`, 144 bytes, symmetric), so it can't be faked from the frontend. `compatibility(a, b)` is a free call used for the preview; `seal(a, b)` stores the reading and emits `ReadingSealed`.
- `?id=N` loads a reading straight from the contract over the public RPC — no wallet needed.
- "My readings" lists what the connected wallet has sealed, newest first.
- Blurbs, strengths and weaknesses, and score bands live in the frontend.
- Date of birth is optional. It picks the sign and adds decan and cusp detail to the reading. It never leaves the browser: it is not stored, not put in share links, and not sent on-chain.
- No tokens, no payments, no admin, no personal data.
