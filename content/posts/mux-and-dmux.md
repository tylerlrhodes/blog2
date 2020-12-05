---
title: "Mux and DMux - \"forking\""
date: 2018-08-05T17:26:53-04:00
draft: false
series: tech
tags: [
      "nand2tetris"
]
---

For those of you unfamiliar, the Nand2Tetris course is a project based
course available on Coursera.  In the course you build a basic
computer platform, known as "Hack," which can run programs written in
its machine language.

The course is based upon the book written by the professors, called,
"The Elements of Computing Systems," and the first part of the course
entails building the Hack computer from nothing but NAND gates and
data flip flops provided.

This is a fun exercise, and based upon soom boolean logic you build
different chips which will be used in the final construction of the
Hack computer.

In addition to building some simple logic chips, you also build a
number of chips for multiplexing and demultiplexing.  Exploring how
these chips work and understanding them is key to being able build the
ALU, memory chips, and CPU later in the course.

I won't go into how they are built in the course, but I will say that
the book gives the hint in their construction to think of "forks" when
building the multi-way Mux and DMux chips (the construction of the
Mux16 and DMux16 are simple once you get the two basic chips).

The Mux and DMux chips which are "2-Way" chips both take a selector.
In the case of the Mux, the selector dictates which input signal is
set to the output.  It multiplexes the input (which in the case of the
2-way Mux is two input signals) into a single output.  For the DMux,
it does the reverse, based upon a selector, it sends the input signal
to the correct output.

I made the diagrams below to help thinking about the "forking."
Starting from the 2-way Mux (at the bottom) you can see the "selector"
in the bottom boxes.  The 2-way Mux takes a 1 bit selector, and based
upon its value, the corresponding box's value will be set to the
output of the Mux (I didn't draw the output, but if the selector is
set to 1, then the second box with a value of 2 would be ouput in the
case of the 2-way Mux).

The forking starts to be a little more apparent with the 4-way Mux.
The 4-way Mux takes a selector which is a two bit value, which allows
for the multiplexor to select one of four input signals to output.
The key is to notice how the different bits of the selector impact
the selection of the output.  In the case of the 4-way, you can see
that the high bit selection effectively controls whether the first two
inputs or the second two inputs are selected.  Then the low bit
controls which of the inputs is taken from the group that the high bit
dictated.

The 8-way Mux follows the same principle.  You can look at the diagram
and see how the different bits impact the selection.  It follows the
same "forking" as the 4-way, except that this time, the high bit picks
which group of 4 is selected.  Then, the next two bits have the same
function as with the 4-way, resulting in the correct signal being
selected to output.

The DMux follows the exact same principle, but in reverse.  I included
the DMux4Way chip in the diagram below.  Based on the same forking
that is done with the multiplexors the input is routed to the correct
output.


![Mux and DMux diagram](/images/Mux8Way-Diagram.png)

The Mux and DMux chips are used in the construction of the other chips
in the book including the ALU, Bit, Register, Ram8 and so on.
Creatively using these chips in conjunction with the "control" signals
that are used as inputs allow for all of the chips in the book to be
built (while also using the logic chips and other chips built).


