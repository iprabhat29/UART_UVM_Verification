# UART_UVM_Verification
UART Design and Verification using SV/UVM1.1

The objective of this paper is to verify the Universal Asynchronous Receiver/Transmitter (UART) protocol
using Universal Verification Methodology (UVM). The UART allows serial communication between two systems running
in different operating-frequencies, by converting parallel data into serial form and transmitting serially in frames. The frames
are collected in the receiver by receiving bit-by-bit of a frame. Once the frame is collected, it converts the serial data into
parallel data. This UART IP core is designed compatible with the industry standard National Semiconductors 16550A
device. It is verified using UVM test bench methodology. The main aim of this project is to get 100% functional
coverage by doing regression test cases. The UART also generates interrupts, which indicate errors, during transmission of
data. The errors may arise due to mismatches in framing of transmitted data, parity-detection, etc. 

