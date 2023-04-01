# sequence-detector-0010

The code consists of 3 modules; the sequence detector, the testvector generator,
and the testbench. The testvector generator pushes the serial string 010010110100100101101001 from
LSB to MSB to the x input of the sequence detector. From the simulation waveform, the output z is 1 for
a clock pulse after a 0010 is detected. Comments are also in the code which describe what is going on at each position.

Relevant code is contained in \3320_Project1.srcs, .xpr project file should be run in Xilinx Vivado.
