import pandas as pd
import numpy as np
import tkinter as tk
from tkinter import simpledialog, messagebox

class MIPS_LUT:
    def __init__(self):
        self.MIPS = pd.read_csv('https://csvbase.com/calpaterson/opcodes-6502', index_col=0)
        self.registers = pd.read_csv('Register_LUT.csv', index_col=0)

    def find_opcode(self):
        opcode = int(simpledialog.askstring("Input", "Enter Opcode:"))
        if opcode:
            filtered_opcode = self.MIPS[self.MIPS['opcode'] == opcode]
            messagebox.showinfo("Opcode Result", filtered_opcode.to_string() if not filtered_opcode.empty else "No match found.")

    def find_function(self):
        function = str(simpledialog.askstring("Input", "Enter Function Name:"))
        if function:
            filtered_function = self.MIPS[self.MIPS['mnemonic'] == function]
            messagebox.showinfo("Function Result", filtered_function.to_string() if not filtered_function.empty else "No match found.")

    def find_register(self):
        try:
            register_number = int(simpledialog.askstring("Input", "Enter Register Number:"))
            filtered_register = self.registers[self.registers['Number'] == register_number]
            messagebox.showinfo("Register Result", filtered_register.to_string() if not filtered_register.empty else "No match found.")
        except ValueError:
            messagebox.showerror("Error", "Invalid Register Number! Please enter an integer.")

    def dec_to_hex(self):
        try:
            dec = int(simpledialog.askstring("Input", "Enter Decimal Number:"))
            hexa = hex(dec)[2:].upper()  # Convert to hex and remove '0x' prefix
            messagebox.showinfo("Hexadecimal Result", f"Decimal: {dec}\nHexadecimal: {hexa}")
        except ValueError:
            messagebox.showerror("Error", "Invalid input! Please enter an integer.")

# GUI Setup
def create_gui():
    mips_lookup = MIPS_LUT()

    root = tk.Tk()
    root.title("MIPS Lookup Tool")
    root.geometry("300x250")

    tk.Label(root, text="Select an Option:", font=("Arial", 12)).pack(pady=10)

    tk.Button(root, text="Find Opcode", command=mips_lookup.find_opcode).pack(pady=5)
    tk.Button(root, text="Find Function", command=mips_lookup.find_function).pack(pady=5)
    tk.Button(root, text="Find Register", command=mips_lookup.find_register).pack(pady=5)
    tk.Button(root, text="Decimal to Hex", command=mips_lookup.dec_to_hex).pack(pady=5)

    root.mainloop()

# Run the GUI
create_gui()
