## The Uber Stack
How We Interact with Computers
Digital Components
“Digital”
-   DIGITAL - Digital means discrete. 
-   Digital representation is comprised of a limited number of data points to encode information. 
-   Most of our electronic devices use Digital techniques to work with data and information
Since we have a limited number of data points to work with, it means that many representations are approximations of the real thing
## What are computers made of?
-   Primarily Transistors
-   Invented in 1951, the Transistor is the basic electrical building block for all modern electronics
-   “the greatest invention of the 20th century”
-   For Digital applications, transistors are packaged in what is known as Integrated Circuits (ICs)
-   As many as 30+ Billion Transistors can be packaged in a single large  IC today
## Anatomy of a Transistor
-   Transistors are fabricated using silicon (derived from quartz) and tiny amounts of impurities such as selenium or gallium arsenide to create what is called a “semiconductor”
-   Semiconductors allow us to control the flow of electrical charge (electrons) very precisely.  
-   Billions of semiconductors can be placed on an integrated circuit using a process called photolithography
## Transistor Functionality
-   In various circuits Transistors can be made to:
-   Amplify or Attenuate electrical signals
-   Invert electrical signals
-   Store electrical voltage values
-   Switch electrical signals off and on
-   Transistors can be combined to create logic circuits commonly known as  “GATES”
-   Gates are packed into Integrated Circuits commonly known as “Chips”
## Simple Silicon Semiconductor Devices
-   It could only add and subtract 4 bits at a time.
AMD Athlon64 Processor
## Use of Logic Gates in Computers
-   Primary Uses:    
-   Switches and logic circuits that can be switched between 0 and 5 volts.  In this way a Switch can signify a “bit”   that is a 1 or a 0
Storage of voltage levels equivalent to 0 or 5 volts.  In this way a “bits” of memory can be implemented or  pixels on an LCD display on a laptop can be created
## AND and OR Gates
![2or](https://lh4.googleusercontent.com/tPPueKTVxTT5T9xp547TjtX9IslVvCtF58MQvrnO1WMompqApao-knk53GO_7Fwkq3Jm9xSXCJ5KiKq5xxxlu-Q-5Lg4GDPYzhBFRdV2nFKjb4NHAnBgwkg25mZSUmzeUQg4P2CEs-ATk4M=s2048)![2and](https://lh3.googleusercontent.com/D3x0qKjM1RcbJWbPoDGD8ogFUaVPe9byQai6oyd-98SOiswYfQROEYkzQn2nOO8W6hWJtTXVzSLHuThNbf1tDJKy0F8e4vGxBoaYSZsQMvpgWt6nROyEFS_Yo1XsJmzdV7t_HsaZRI-DFQE=s2048)![2andtuth](https://lh6.googleusercontent.com/V-7yOa8AWP-wCkD9HICbXJwI6uXp18zFAj6nhN8HmVqgnQbdrmkarPPJy0meVBosR4NIGkym5XAnbwM2PxjmlMqtjVwesxFLK0UVuOuCN0lBh-m1rMIK0IY_-G73oMUDv-1RoOVps5Pmg4A=s2048)![truth](https://lh6.googleusercontent.com/T_t4aSjNzm1XoaNd4VgdaAyN43lkQFq0_HVaWeKZYChmpdmaGYVGI3_5h82LZOtIaRdl1rXhrZbCyhhFUkCvhKKGhrDSxHAeB9cknz2mG9qYxHk-no7a0Q9lUFsC5FdUgFkXTd0GJPNgrUU=s2048)
By combining gates we can create useful functions such as a the ability to store a bit of information
-   The purpose of a latch is to allow a data value to be stored temporarily. So that we can hold it and “use” it for awhile…like a “bit” of memory
![Clocked RS NAND latch](https://lh3.googleusercontent.com/ng5onQGc4UiIWobCXDRefs5UoRsrczQhv6frMOOLcLZAZ5h3WB6W3ug8vYIs_whtSL4xmdH-5SfCA2-tuMl7wOD3bncEHWQoF8-zYnK0uPlZmoPZO1ey5SSQxf9J1VhRNN7d5er_5q566RM=s2048)
## Fetch, Decode, Execute Cycle
-   Computer instructions are stored (as bits) in memory.  To run a program, each instruction is:
-   Fetched from memory.
-   Decoded (the computer figures out what it should do based on the number).
-   Then the instruction is executed.
-   The speed at which this cycle occurs is determined by the system clock
## Cycle Times
-   Generally the faster your computer can get through a fetch-decode-execute cycle, the faster it will perform.   
-   Cycle times are measured in “gigahertz”, a billion cycles per second.
-   PCs these days reach 3500 Megahertz or 3.5 Gigahertz (3 billion cycles/sec)
## Memory
-   Each memory unit has its own address    
-   Memory units are organized in groups of  Bytes (8 bits) or Words (16, 24, 32, 64 or 128 bits)
0  1  2  3  4 …………………………………..16 Billion
## Random Access Memory
-   The main computer memory is called RAM (Random Access Memory)
-   It is “random” in that one may access any addressable memory unit independently of any other (and thus in “random” order).
-   In almost all modern machines the smallest single addressable amount of memory is one byte.
-   Memory is measured in megabytes or gigabytes or terabytes (millions, billions or trillions)
## RAM chips on a Circuit board

Dynamic Random Access Memory
-   RAM allows for both reading and writing in memory.  Contrast this with ROM (read-only memory).
-   Most RAM is volatile, or “dynamic”.  When you turn off the power, the contents of RAM is lost.
-   Sometimes one talks about DRAM which is short for dynamic RAM).

## Read Only Memory
-   Read Only Memory can only be read from
-   It’s contents cannot be altered or written over easily
-   This type of memory is used to hold instructions that need to always be there 
- For example, the initial instructions that are executed when your PC is turned on which instructs the machine to load Windows from the disk drive
## Machine Language
-   Every computer CPU has its machine language, the set of basic instructions it knows how to execute. 
- A typical instruction might say, “get the contents of a memory location and put it in the accumulator register” (perhaps in preparation for adding it to another number).
## Machine Instructions
-   Such an instruction would consist of two numbers:    
-   One would be the address of the memory unit to be accessed.
- The other would be the operation code of the instruction - the (somewhat arbitrary) number that refers to a unique and particular type of instruction
## Structure of Instructions
Suppose we used 32 bits to encode a machine language instruction - Information Transfer inside the CPU
- Individual bits in a memory unit are transferred to the CPU in parallel (all at the same time).
- This is opposed to serially (one at at time).
- The same goes for information transferred between registers in the CPU.
- A 64 bit machine can transfer 64 bits in parallel.
## Central Processing Unit
-   manages the instruction-execution cycle    
-   FETCH – DECODE – EXECUTE
-   coordinates the activities of other devices
![Block diagram of a generic computer](https://lh4.googleusercontent.com/cj8RA4uiCdLvmIvkP0QR5tP0KhstW3RB9iQWRTtsv0ur5nH9t7v_7N0ryaEl-z0ieqFmkMxVUOQrmOZGf-UUrgp7SO0C0wokKjoWYIS8fn6v2CVrdA6DcZmkW8tPBz-ASWifphMs7E5X_OQ=s2048)
![Basic computer system](https://lh3.googleusercontent.com/obMAfxY1nRK2ro3OvSStzSv1bXG7oGAusgl8s1oYl8rZHSgOEirQA1llHmwT9AtEk0eNRAhFxY_wu_czdUu641KnXqHOJMcQe7SgIgOAZiXpQFoS2yzTkwSU64wEYTBoPU_gZ9gJC_1hDqE=s2048)
![Data flow](https://lh4.googleusercontent.com/UHOQdDqUbw-zGOuOIc60MP6zuL1BQnTHhHZf2DEjPvxqNYgrrzrezqVGQrfC3p1GhlEnToJfhv0DPppjA64X5R0yJr4h0Wu2-UkLE1pII0lls73Kwt568VyUJ1ocLgU09i5Cnc-c-UdMngE=s2048)
![](https://lh3.googleusercontent.com/ciPI2k80VBfR1ODwDG_82leuj1jET8SzIAlSHirND2moX2IMv5idxLTZvZqhRkVFxaa3zOG0Q_QrvKkHXttK12_whBYkofadRuy5p3Wzg6M1J0JSkHr931tEzYOVLOZ761euj8-JA5kXf6U=s2048)
## Types of Processor Operations
-   Data Movement Operations
-   moving data from memory to the CPU
-   moving data from memory to memory
-   input and output

-   Program Control
-   starting a program
-   halting a program
-   skipping to other instructions
-   testing data to decide whether to skip over some instructions

-   Arithmetic and Logical Operations
-   integer arithmetic
-   comparing two quantities
-   shifting, rotating bits in a quantity
-   testing, comparing, and converting bits

Remember our CPU is at the core
![](https://lh5.googleusercontent.com/5fcMC7UzFL5KvjFziiImumaFnED3uEamPvnoF6TPMU9oSf_TeiHYSssojTbJA5t80sI7Fs0tXW6S4nPUTaKzblAA8DAMr_6VnmXw5QJvZMg_2ajSLGwdk7ncySFTAYh2mLEXRwhG66coEqI=s2048)
Fetch, Decodes, Executes Instructions in sequence
## Von Neumann Architecture
-   based on stored program design    
-   processor system
-   CPU
-   memory
-   input/output system
-   input/output devices
-    storage
![](https://lh3.googleusercontent.com/ZPt-nfTSL576NjUn5l2YxvOVriaJJc_ICZUMRsLqqrrLxpLlJFV-Bj5m0uYPjF-tEJix1C1DBCgBbSQzwf5-Eepl4kGuvkSjGYyTFldXCFE5wRUtTmZVnd-PUjMU-BaA5zrhCz69UbGeQgA=s2048)
Just about everything outside of the CPU/Main Memory falls under the general classification of an “I/O or Peripheral Device”
## I/O Subsystem
-   Input/Output
-   exchanging data and instructions between the user and the computer
-   The user may be a human being, but it may  also be a machine….like a car engine or a valve in a nuclear power plant
## Storage (Non Volatile)
-   auxiliary storage for data and instructions
-   Backup or alternative storage in place of (volatile) RAM   
-   cheaper, mass storage for long term use
-   storage devices (and media) are distinguished by their capacities, speed, and cost
## Memory Storage Systems

![](https://lh6.googleusercontent.com/parumyY3B4g3pv5jPGFMdGV0eLlf5opfFN332GiUur8gnErHTZjH_8oOhpykvCtlgPNPJLvEEoHPr8zcAGWOX73WPj1L92QunO5Ybnlk3FoJCG7xk-oIuHAOtDhPfg6rmivMa6Eu5xWmEsc=s2048)
## Types of Access
-   RANDOM ACCESS (Main Memory, Flash)
-   items are independently addressed
-   access time is constant

-   DIRECT ACCESS (Disc Drives)
-   items are independently addressed in regions
-   access time is variable—though not significantly

-   SEQUENTIAL ACCESS (Tape Systems)
-   items are organized in sequence (linearly)
-   access time is significantly variable


[It’s All 1s and 0s: How Computers Map the Physical World | by Jonathan Mines | Medium](https://medium.com/@jonathanmines/its-all-1s-and-0s-how-computers-map-the-physical-world-18a361fae3a5)  
[Building an 8-bit computer in Logisim (Part 2— Arithmetic) | by Karl Rombauts | Medium](https://medium.com/@karlrombauts/building-an-8-bit-computer-in-logisim-part-2-arithmetic-ae7861c82e79)  
[bit manipulation - Reading two 8 bit registers into 12 bit value of an ADXL362 in C - Stack Overflow](https://stackoverflow.com/questions/51407372/reading-two-8-bit-registers-into-12-bit-value-of-an-adxl362-in-c)  
[logic gates - K-maps for forming 8bit binary to 8bit BCD digital circuit - Electrical Engineering Stack Exchange](https://electronics.stackexchange.com/questions/440910/k-maps-for-forming-8bit-binary-to-8bit-bcd-digital-circuit)  

[Digitalrechner – Wikipedia](https://de.wikipedia.org/wiki/Digitalrechner)  
[Computerhardware für Anfänger – Wikibooks, Sammlung freier Lehr-, Sach- und Fachbücher](https://de.wikibooks.org/wiki/Computerhardware_f%C3%BCr_Anf%C3%A4nger)  
[Instruction cycle - Wikipedia](https://en.wikipedia.org/wiki/Instruction_cycle)  
[Computer Hardware für Anfänger](https://de.wikibooks.org/wiki/Computerhardware_f%C3%BCr_Anf%C3%A4nger)






