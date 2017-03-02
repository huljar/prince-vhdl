# PRINCE block cipher - VHDL implementation

This is an implementation of the PRINCE lightweight block cipher
as described in [this paper](https://eprint.iacr.org/2012/529.pdf).
It encrypts individual blocks of 64 bit length with a 128 bit key.

PRINCE was specifically designed to achieve minimum latency while
still providing good security. In addition, the area requirement
of a hardware implementation should be small enough to allow the
cipher to be used in very constrained environments.

## Design

The authors of PRINCE encourage using a fully-unrolled design, i.e.
having separate components for every round of the cipher, which are
chained together. This ensures minimum latency with acceptable area
overhead; one plaintext block is encrypted in a single clock cycle.

## Implementation

`prince_top` is the top-level module. It performs key whitening
at the start and end of the algorithm. In between, the actual
encryption is performed by calling `prince_core`.

`prince_core` is the actual cipher implementation. It generates
all the components for the 12 rounds of the cipher.

S-Boxes (non-linear layer) and permutation (linear layer) reside
in separate files (`sbox`, `linear_m` etc.).

## License
The code is licensed under the terms of the GNU Lesser General
Public License (LGPL) Version 3. For more information, please see
the LICENSE.md file.
