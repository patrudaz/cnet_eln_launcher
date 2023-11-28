import json
import os
import tkinter as tk
from tkinter import ttk, messagebox
import subprocess

PROJECT_PATH = os.getcwd()
SCRIPTS_PATH = os.path.join(PROJECT_PATH, "scripts")
OPTIONS_FILE = os.path.join(PROJECT_PATH, "options.json")

# Default options
DEFAULT_OPTIONS = {
    "renderer": "OpenGL"
}

def launch_game():
    # Replace the following command with the CMD command to launch your game
    os.chdir(SCRIPTS_PATH)
    cmd_command = "run.bat" if quality_var.get() == "Software" else "run_OpenGL.bat"
    subprocess.Popen(cmd_command, shell=True)

def reset_map():
    # Replace the following command with the CMD command to reset your map
    os.chdir(SCRIPTS_PATH)
    cmd_command = "reset_map.bat"
    subprocess.Popen(cmd_command, shell=True)

def save_options():
    global quality_var, options_window
    options = {
        "renderer": quality_var.get(),
        # Add other options as needed
    }

    # Save options to JSON file
    with open(OPTIONS_FILE, "w") as file:
        json.dump(options, file)

    messagebox.showinfo("Options Saved", "Options have been saved.")

    # Close the options window
    options_window.destroy()

def update_parameters():
    # Read options from JSON file or use defaults if the file doesn't exist
    try:
        with open(OPTIONS_FILE, "r") as file:
            options = json.load(file)
    except FileNotFoundError:
        options = DEFAULT_OPTIONS

    # Update global parameters
    quality_var.set(options.get("renderer", DEFAULT_OPTIONS["renderer"]))
    # Add other parameters as needed

def open_options_window():
    global quality_var, options_window
    options_window = tk.Toplevel(root)
    options_window.title("Options")

    # Generic parameters
    ttk.Label(options_window, text="Renderer:").grid(row=0, column=0, padx=10, pady=5)
    quality_combobox = ttk.Combobox(options_window, textvariable=quality_var, values=["OpenGL", "Software"])
    quality_combobox.grid(row=0, column=1, padx=10, pady=5)
    quality_combobox.set("OpenGL")

     # Add a label above the combobox that gives information about the renderer
    ttk.Label(options_window, text="OpenGL is recommended.").grid(row=0, column=2, padx=10, pady=5)


    # ttk.Label(options_window, text="Sound Volume:").grid(row=1, column=0, padx=10, pady=5)
    # volume_var = tk.DoubleVar()
    # volume_scale = ttk.Scale(options_window, from_=0, to=100, variable=volume_var, orient="horizontal")
    # volume_scale.grid(row=1, column=1, padx=10, pady=5)
    # volume_scale.set(50)
    #
    # ttk.Label(options_window, text="Fullscreen:").grid(row=2, column=0, padx=10, pady=5)
    # fullscreen_var = tk.BooleanVar()
    # fullscreen_checkbox = ttk.Checkbutton(options_window, variable=fullscreen_var)
    # fullscreen_checkbox.grid(row=2, column=1, padx=10, pady=5)

    # Load options from JSON file or use defaults
    update_parameters()

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

# Define quality_var globally to be accessed in save_options and update_parameters
quality_var = tk.StringVar()
options_window = None

options_button = tk.Button(root, text="Options", command=open_options_window, bg="#3498db", fg="white", font=button_font, width=20)
options_button.pack(pady=10)

# Run the Tkinter event loop
root.mainloop()
