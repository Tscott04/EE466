import tkinter as tk
from tkinter import messagebox


def hex_to_bin(hex_instr):
    return bin(int(hex_instr, 16))[2:].zfill(32)


def bin_to_hex(bin_instr):
    return hex(int(bin_instr, 2))[2:].zfill(8).upper()


def format_binary_spaced(bin_instr):
    return ' '.join(bin_instr[i:i + 4] for i in range(0, len(bin_instr), 4))


def decode_mips():
    try:
        instr = entry_instr.get().strip()

        if len(instr) == 8 and all(c in '0123456789ABCDEFabcdef' for c in instr):
            binary_instr = hex_to_bin(instr)
        elif len(instr) == 32 and all(c in '01' for c in instr):
            binary_instr = instr
        else:
            messagebox.showerror("Input Error",
                                 "Please enter a valid 32-bit binary or 8-character hexadecimal instruction.")
            return

        opcode = binary_instr[:6]
        rs = binary_instr[6:11]
        rt = binary_instr[11:16]
        rd = binary_instr[16:21]
        shamt = binary_instr[21:26]
        funct = binary_instr[26:]
        immediate = binary_instr[16:]

        instruction_type = "R-type" if opcode == "000000" else "I-type"
        formatted_binary = format_binary_spaced(binary_instr)
        result = f"Instruction Type: {instruction_type}\nHex: {bin_to_hex(binary_instr)}\nBinary: {formatted_binary}\n"

        if instruction_type == "R-type":
            result += f"Opcode: {opcode} (000000) [0x{int(opcode, 2):X}]\nRS: {rs} ({int(rs, 2)})\nRT: {rt} ({int(rt, 2)})\nRD: {rd} ({int(rd, 2)})\nShamt: {shamt} ({int(shamt, 2)})\nFunct: {funct} ({int(funct, 2)})"
        else:
            result += f"Opcode: {opcode} [0x{int(opcode, 2):X}]\nRS: {rs} ({int(rs, 2)})\nRT: {rt} ({int(rt, 2)})\nImmediate: {immediate} ({int(immediate, 2)})"

        result_label.config(text=result)
    except Exception as e:
        messagebox.showerror("Error", str(e))


# GUI Setup
root = tk.Tk()
root.title("MIPS Instruction Decoder")

frame = tk.Frame(root)
frame.pack(padx=20, pady=20)

tk.Label(frame, text="Enter 32-bit Binary or 8-character Hex Instruction:").grid(row=0, column=0)
entry_instr = tk.Entry(frame, width=40)
entry_instr.grid(row=0, column=1)

tk.Button(frame, text="Decode", command=decode_mips).grid(row=1, columnspan=2, pady=10)

result_label = tk.Label(frame, text="Result:")
result_label.grid(row=2, columnspan=2)

root.mainloop()
