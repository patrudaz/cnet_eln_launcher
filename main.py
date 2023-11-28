import os
import tkinter as tk
from tkinter import ttk, messagebox
import subprocess

PROJECT_PATH = os.getcwd()
SCRIPTS_PATH = PROJECT_PATH + "\scripts"

def launch_game():
    # Replace the following command with the CMD command to launch your game
    os.chdir(SCRIPTS_PATH)
    cmd_command = "run.bat"
    subprocess.Popen(cmd_command, shell=True)

def reset_map():
    # Replace the following command with the CMD command to reset your map
    os.chdir(SCRIPTS_PATH)
    cmd_command = "reset_map.bat"
    subprocess.Popen(cmd_command, shell=True)

def save_options():
    # Add code to save the selected options to a configuration file or perform any necessary actions
    messagebox.showinfo("Options Saved", "Options have been saved.")

def open_options_window():
    options_window = tk.Toplevel(root)
    options_window.title("Options")

    # Generic parameters
    ttk.Label(options_window, text="Graphics Quality:").grid(row=0, column=0, padx=10, pady=5)
    quality_var = tk.StringVar()
    quality_combobox = ttk.Combobox(options_window, textvariable=quality_var, values=["Low", "Medium", "High"])
    quality_combobox.grid(row=0, column=1, padx=10, pady=5)
    quality_combobox.set("Medium")

    ttk.Label(options_window, text="Sound Volume:").grid(row=1, column=0, padx=10, pady=5)
    volume_var = tk.DoubleVar()
    volume_scale = ttk.Scale(options_window, from_=0, to=100, variable=volume_var, orient="horizontal")
    volume_scale.grid(row=1, column=1, padx=10, pady=5)
    volume_scale.set(50)

    ttk.Label(options_window, text="Fullscreen:").grid(row=2, column=0, padx=10, pady=5)
    fullscreen_var = tk.BooleanVar()
    fullscreen_checkbox = ttk.Checkbutton(options_window, variable=fullscreen_var)
    fullscreen_checkbox.grid(row=2, column=1, padx=10, pady=5)

    # Save button
    save_button = ttk.Button(options_window, text="Save Options", command=save_options)
    save_button.grid(row=3, column=0, columnspan=2, pady=10)

# Main window
root = tk.Tk()
root.title("Minecraft Launcher")

# Styling
root.geometry("400x250")
root.configure(bg="#bdc3c7")  # Light gray background color

# Font
button_font = ("Helvetica", 12)

# Buttons
launch_game_button = tk.Button(root, text="Launch Game", command=launch_game, bg="#2ecc71", fg="white", font=button_font, width=20)
launch_game_button.pack(pady=10)

reset_map_button = tk.Button(root, text="Reset Map", command=reset_map, bg="#e74c3c", fg="white", font=button_font, width=20)
reset_map_button.pack(pady=10)

options_button = tk.Button(root, text="Options", command=open_options_window, bg="#3498db", fg="white", font=button_font, width=20)
options_button.pack(pady=10)

# Run the Tkinter event loop
root.mainloop()
