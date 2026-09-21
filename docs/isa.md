# ISA

This processor implements a 15-instruction subset of RV32I. It is not a
fully compliant RV32I processor.

## Architectural State

- The processor has 32 general-purpose registers, `x0` through `x31`.
- Each register is 32 bits wide (`XLEN = 32`).
- `x0` always reads as zero and ignores writes.
- Integer arithmetic wraps modulo 2^32.
- Instructions are 4 bytes long.

## Supported Instructions

### Register ALU

- **ADD rd, rs1, rs2** — Adds the 32-bit values in `rs1` and `rs2` and writes the low 32 bits of the result to `rd`.

- **SUB rd, rs1, rs2** — Subtracts the value in `rs2` from the value in `rs1` and writes the low 32 bits of the result to `rd`.

- **AND rd, rs1, rs2** — Performs a bitwise AND of `rs1` and `rs2` and writes the result to `rd`.

- **OR rd, rs1, rs2** — Performs a bitwise OR of `rs1` and `rs2` and writes the result to `rd`.

- **XOR rd, rs1, rs2** — Performs a bitwise XOR of `rs1` and `rs2` and writes the result to `rd`.

- **SLL rd, rs1, rs2** — Logically shifts `rs1` left by the amount specified by the low five bits of `rs2` and writes the result to `rd`.

- **SRL rd, rs1, rs2** — Logically shifts `rs1` right by the amount specified by the low five bits of `rs2`, shifting zeros into the upper bits, and writes the result to `rd`.

### Immediate and Constant

- **ADDI rd, rs1, imm** — Adds the sign-extended immediate value to `rs1` and writes the low 32 bits of the result to `rd`.

- **LUI rd, imm** — Places the instruction's upper immediate into the upper bits of `rd`, with the lower 12 bits set to zero.

### Memory

- **LW rd, imm(rs1)** — Loads a 32-bit word from memory at address `rs1 + sign-extended imm` and writes it to `rd`.

- **SW rs2, imm(rs1)** — Stores the 32-bit value in `rs2` to memory at address `rs1 + sign-extended imm`.

### Control Flow

- **BEQ rs1, rs2, imm** — If `rs1` equals `rs2`, sets the next PC to the current instruction's PC plus the signed immediate offset; otherwise execution continues at `PC + 4`.

- **BNE rs1, rs2, imm** — If `rs1` does not equal `rs2`, sets the next PC to the current instruction's PC plus the signed immediate offset; otherwise execution continues at `PC + 4`.

- **JAL rd, imm** — Writes `PC + 4` to `rd` when `rd` is nonzero and jumps to the current instruction's PC plus the signed immediate offset.

- **JALR rd, imm(rs1)** — Writes `PC + 4` to `rd` when `rd` is nonzero and jumps to `rs1 + sign-extended imm` with bit 0 of the target address cleared.

## Alignment

- Executed instruction targets must be 4-byte aligned.
- `LW` and `SW` addresses must be 4-byte aligned.
- Branch and `JAL` immediates are signed byte offsets relative to the
  instruction's own PC.
- `JALR` clears bit 0 of its computed target address.

## Unsupported Features

This implementation does not provide full RV32I compliance.

The required RTL does not include:

- Multiplication or division
- Floating-point instructions
- Compressed instructions
- Atomic instructions
- Interrupts
- Privileged CSRs
- Operating-system boot
- Virtual memory
- Architectural exception handling