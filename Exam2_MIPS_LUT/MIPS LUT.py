import pandas as pd
import tkinter as tk
from tkinter import simpledialog, messagebox, scrolledtext


class MIPS_LUT:
    def __init__(self, result_box):
        try:
            self.MIPS = pd.read_csv('Mips_Instruction_Set.csv', index_col=0)
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load MIPS Instruction Set CSV: {e}")
            self.MIPS = pd.DataFrame()

        try:
            self.registers = pd.read_csv('Register_LUT.csv', index_col=0)
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load Register LUT CSV: {e}")
            self.registers = pd.DataFrame()

        self.result_box = result_box  # Store reference to result box

    def display_result(self, title, content):
        """Clears and updates the result display."""
        self.result_box.config(state=tk.NORMAL)
        self.result_box.delete("1.0", tk.END)
        self.result_box.insert(tk.END, f"{title}\n{'=' * 40}\n{content}")
        self.result_box.config(state=tk.DISABLED)

    def find_opcode(self):
        if self.MIPS.empty:
            messagebox.showerror("Error", "MIPS Instruction Set data is not loaded.")
            return
        opcode = simpledialog.askstring("Input", "Enter Opcode:")
        if opcode:
            try:
                opcode = int(opcode)
                filtered_opcode = self.MIPS[self.MIPS['opcode'] == opcode]
                result = filtered_opcode.to_string(index=False) if not filtered_opcode.empty else "No match found."
                self.display_result("Opcode Result", result)
            except ValueError:
                messagebox.showerror("Error", "Invalid Opcode! Please enter a valid integer.")

    def find_function(self):
        if self.MIPS.empty:
            messagebox.showerror("Error", "MIPS Instruction Set data is not loaded.")
            return
        function = simpledialog.askstring("Input", "Enter Function Name:")
        if function:
            filtered_function = self.MIPS[self.MIPS['mnemonic'].str.lower() == function.lower()]
            result = filtered_function.to_string(index=False) if not filtered_function.empty else "No match found."
            self.display_result("Function Result", result)

    def find_register(self):
        if self.registers.empty:
            messagebox.showerror("Error", "Register LUT data is not loaded.")
            return
        register_number = simpledialog.askstring("Input", "Enter Register Number:")
        if register_number:
            try:
                register_number = int(register_number)
                filtered_register = self.registers[self.registers['Number'] == register_number]
                result = filtered_register.to_string(index=False) if not filtered_register.empty else "No match found."
                self.display_result("Register Result", result)
            except ValueError:
                messagebox.showerror("Error", "Invalid Register Number! Please enter an integer.")

    def dec_to_hex(self):
        dec = simpledialog.askstring("Input", "Enter Decimal Number:")
        if dec:
            try:
                dec = int(dec)
                hexa = hex(dec)[2:].upper()  # Convert to hex and remove '0x'
                self.display_result("Hexadecimal Result", f"Decimal: {dec}\nHexadecimal: {hexa}")
            except ValueError:
                messagebox.showerror("Error", "Invalid input! Please enter an integer.")


# GUI Setup
def create_gui():
    root = tk.Tk()
    root.title("MIPS Lookup Tool")
    root.geometry("400x400")
    root.resizable(False, False)

    # Title Label
    tk.Label(root, text="MIPS Lookup Tool", font=("Arial", 14, "bold")).pack(pady=10)

    # Frame for buttons
    button_frame = tk.Frame(root)
    button_frame.pack(pady=10)

    # Result display
    result_box = scrolledtext.ScrolledText(root, height=10, width=50, state=tk.DISABLED, font=("Courier", 10))
    result_box.pack(padx=10, pady=10)

    # MIPS Lookup Instance
    mips_lookup = MIPS_LUT(result_box)

    # Buttons
    buttons = [
        ("Find Opcode", mips_lookup.find_opcode),
        ("Find Function", mips_lookup.find_function),
        ("Find Register", mips_lookup.find_register),
        ("Decimal to Hex", mips_lookup.dec_to_hex),
    ]

    for text, command in buttons:
        tk.Button(button_frame, text=text, command=command, width=20, font=("Arial", 10)).pack(pady=5)

    root.mainloop()


# Run the GUI
create_gui()
