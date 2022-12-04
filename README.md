# vrf-signatured

This is a very simple example of how VRFs can be used.

Imagine we have a need of random number for the contracts, which should not be abused by miners.

What we want to do is generate the randomness ourselves.

You create an account and associate it to the backend. Backend privately exposes API to get proof signatures.

You send the data, i.e. `address` of the user, backend generates the `random` number and a `signature`.

You pass those to a VRF-aware function. profit!

## Audits
The contract was audited by OpenAI, so if you're a fan of Terminators trilogy, you may use it in production:
![photo_2022-12-04 15 35 53](https://user-images.githubusercontent.com/35642018/205493571-3cbaa325-8a1a-45a0-bbe2-e36dc02743bb.jpeg)


## Installation

```
forge install [user]/[repo]
```

## Local development

This project uses [Foundry](https://github.com/gakonst/foundry) as the development framework.

### Dependencies

```
make update
```

### Compilation

```
make build
```

### Testing

```
make test
```
