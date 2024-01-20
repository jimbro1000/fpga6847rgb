# Synthetic 6847 #

This project contains a System Verilog design
to replace the Motorola 6847 with a small, modern
FPGA solution

## Source Code ##

The solution is coded in AMD Vivado 2023

## Background ##

When Motorola created the 6847 VDG it was aimed
at creating a cheap solution that fitted with
the Motorola reference architecture for the 
68xx processors. Combined with the 6883 SAM,
a CPU and RAM very little more was needed to
create a working computer but this came at the
price of complexity and freedom of configuration
of the display.

Within the context of the early 8 bit computers
it makes a high degree of sense, removing lots
of discrete logic from the board and providing a
standard cost-effective solution.

The process of simplification also means that
the generated video output is aimed firmly at
the NTSC market using a simplified Y-C output.

The resulting signal is inherentlly noisy and
suffers from heavy artifacting between colours,
it also ties the CPU clock to the necessary
frequency to generate NTSC video output.

For those systems that used the 6847 it is a
relatively complex affair to achieve a video
signal suitable for modern digital TVs and 
monitors.

There are mechanisms for converting Y-C video
to RGB, VGA or HDMI and do so remarkably well.

This project does something different - instead
of sampling the output from the 6847 to create
a RGB component signal, the aim here is to
completely replace the 6847 and provide a native
RGB signal. This can be converted back to composite
for compatibility as desired or needed.

## Requirements ##

The code is being developed against an AMD Arty7
FPGA - significant overkill for the needs of this
project, but I have an Arty7 dev kit board...

Ultimately the design has only small requirements
and should fit into a very modest FPGA

## Progress ##

The project is 95% implemented but is untested
in real hardware to verify operation