# 🖩 Simple Calculator — 8086 Assembly Language

> **COAL Project** | Computer Organization & Assembly Language  
> **Author:** Mazhar Ali  |  **Tool:** EMU8086  |  **Interrupts:** DOS INT 21H

-----

## 📋 About the Project

A fully functional command-line calculator built in **8086 Assembly Language**, capable of performing all four basic arithmetic operations on single-digit numbers. This project demonstrates low-level programming concepts including:

- CPU registers (`AX`, `AL`, `BL`, `DX`, `DS`)
- Arithmetic instructions (`ADD`, `SUB`, `MUL`, `DIV`)
- DOS Interrupts (`INT 21H`) for input and output
- ASCII-to-numeric conversion (`SUB AL, 48` / `ADD AL, 48`)
- Conditional jumps (`JE`, `JNS`, `JLE`, `JMP`)
- Macros for cleaner code structure

-----

## ⚙️ Features

|Operation     |Instruction|Notes                                   |
|--------------|-----------|----------------------------------------|
|Addition      |`ADD`      |Result displayed directly               |
|Subtraction   |`SUB`      |Handles negative results with `-` sign  |
|Multiplication|`MUL`      |Supports two-digit results (e.g. 9×9=81)|
|Division      |`DIV`      |Division-by-zero error handled          |

-----

## 🖥️ Sample Output

```
============================
   Simple Calculator 8086
============================

Enter First Number  (0-9): 9
Enter Second Number (0-9): 3

----------------------------
Select Operation:
  1. Addition      (+)
  2. Subtraction   (-)
  3. Multiplication(*)
  4. Division      (/)
----------------------------
Your choice: 3

Result = 27
```

-----

## 🚀 How to Run

### Requirements

- **EMU8086** emulator ([download here](http://emu8086.com))
- Windows OS (EMU8086 runs on Windows)

### Steps

1. **Clone or download** this repository
   
   ```
   git clone https://github.com/your-username/8086-Calculator-Assembly-COAL.git
   ```
1. **Open EMU8086**
1. Click **File → Open** and select `calculator.asm`
1. Click the **Emulate** button (or press `F5`)
1. Click **Run** (or press `F9`) in the emulator window
1. Follow the on-screen prompts:
- Enter first digit (0–9)
- Enter second digit (0–9)
- Choose operation (1/2/3/4)

-----

## 🧠 Key Concepts Explained

### ASCII Conversion

```asm
; Reading input: keyboard gives ASCII, we need numeric
mov  ah, 01h
int  21h        ; AL = ASCII character (e.g. '4' = 52)
sub  al, 48     ; AL = numeric value  (e.g. 52 - 48 = 4)

; Displaying output: we have numeric, screen needs ASCII
add  al, 48     ; AL = ASCII character (e.g. 4 + 48 = 52 = '4')
mov  dl, al
mov  ah, 02h
int  21h        ; displays '4'
```

### DOS Interrupts Used

|Interrupt|AH Value|Purpose                            |
|---------|--------|-----------------------------------|
|`INT 21H`|`01H`   |Read single character from keyboard|
|`INT 21H`|`02H`   |Print single character to screen   |
|`INT 21H`|`09H`   |Print `$`-terminated string        |
|`INT 21H`|`4CH`   |Terminate the program              |

### Register Roles

|Register|Role in this project                              |
|--------|--------------------------------------------------|
|`AX`    |Load data segment address; holds result of MUL/DIV|
|`AL`    |Primary 8-bit operand for all arithmetic          |
|`BL`    |Second operand for MUL / DIV                      |
|`DX`    |Points to string address for INT 21H output       |
|`DS`    |Data segment register (initialized at start)      |

-----

## 📁 Repository Structure

```
8086-Calculator-Assembly-COAL/
│
├── calculator.asm        ← Main source code (open this in EMU8086)
├── README.md             ← This file
├── Report.pdf            ← Full COAL project report
└── Presentation.pptx     ← Project presentation slides
```

-----

## 📚 Viva Q&A

**Q: Why subtract 48 from input?**  
A: ASCII value of `'0'` is 48, `'1'` is 49, etc. Subtracting 48 converts the character code to its actual numeric value.

**Q: Which interrupt handles output?**  
A: `INT 21H`. With `AH=09H` it prints a string; with `AH=02H` it prints a single character.

**Q: What does `AH=09H` do?**  
A: Selects the “Display String” DOS function — prints a `$`-terminated string stored at the address in `DX`.

**Q: What is the role of the DS register?**  
A: `DS` (Data Segment) holds the base address of the `.data` section so the program can access variables.

**Q: How does MUL handle two-digit results?**  
A: `MUL BL` stores the result in `AX` (16-bit). We then `DIV` by 10 to split tens and units digits for display.

-----

## ⚠️ Limitations

- Supports **single-digit input only** (0–9)
- Division shows **quotient only** (remainder not displayed)
- Text-based console interface (no GUI)

-----

## 🔮 Future Improvements

- [ ] Multi-digit number input
- [ ] Display division remainder
- [ ] Scientific operations (using 8087 FPU)
- [ ] Input validation for non-numeric characters
- [ ] Loop back to menu after each calculation

-----

## 📄 License

This project is open-source and free to use for educational purposes.

-----

*Prepared for COAL subject | EMU8086 Emulator*