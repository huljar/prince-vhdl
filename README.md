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

## Xilinx Vivado project file

The Vivado project file *(&ast;.xpr)* is configured to use the *Digilent Zybo*
FPGA board for synthesis. This board is not available by default in Vivado
(at least not if you are using the WebPACK edition). To obtain the required
board files for the *Zybo* (and other boards by Digilent), refer to
[this wiki entry](https://reference.digilentinc.com/reference/software/vivado/board-files).

## License
The code is licensed under the terms of the MIT license. For more
information, please see the [LICENSE.md](LICENSE.md) file.
