import json
import os
import sys
import tkinter as tk
from tkinter import ttk, messagebox
import subprocess

PROJECT_PATH = os.getcwd()
FILE_PATH = os.path.join(PROJECT_PATH, "_internal")
SCRIPTS_PATH = os.path.join(PROJECT_PATH, "_internal", "scripts")
OPTIONS_FILE = os.path.join(PROJECT_PATH, "options.json")
WIN_EXTENSION = ".bat"
MAC_EXTENSION = ".sh"
MAC_PREFIX = "./macos_"
LINUX_PREFIX = "./linux_"

# Default options
DEFAULT_OPTIONS = {
    "renderer": "OpenGL"
}


def launch_game():
    # Replace the following command with the CMD command to launch your game
    os.chdir(SCRIPTS_PATH)
    print("Current path:", os.getcwd())

    # Load options from JSON file or use defaults
    update_parameters()

    # set up script name
    run_script = script_pre + "run" + script_ext
    if quality_var.get() == "OpenGL":
        run_script = script_pre + "run_OpenGL" + script_ext

    run_command = (run_script + " " + FILE_PATH)
    print("command:", run_command)
    subprocess.Popen(run_command, shell=True)


def reset_map():
    # Replace the following command with the CMD command to reset your map
    os.chdir(SCRIPTS_PATH)

    prefix = script_pre
    if script_pre != "":
        prefix = "./"

    run_command = prefix + "reset_map" + script_ext
    print("command:", run_command)
    subprocess.Popen(run_command, shell=True)


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
    global quality_var, options_window, root
    options_window = tk.Toplevel(root)
    options_window.title("Options")

    # Generic parameters
    frame = tk.Frame(options_window)
    frame.grid(row=0, column=0, padx=5, pady=5)
    label = tk.Label(frame, text="Renderer:")
    label.pack()

    frame = tk.Frame(options_window)
    frame.grid(row=0, column=1, pady=5)
    quality = ttk.Combobox(frame, textvariable=quality_var, values=["OpenGL", "Software"])
    quality.set("Software")
    quality.pack()

    # Add a label above the combobox that gives information about the renderer
    frame = tk.Frame(options_window)
    frame.grid(row=0, column=2, padx=5, pady=5)
    rec_label = tk.Label(frame, text="(OpenGL is recommended)")
    rec_label.pack()

    # Load options from JSON file or use defaults
    update_parameters()

    # Save button
    frame = tk.Frame(options_window)
    frame.grid(row=1, columnspan=3, pady=10)
    save_btn = tk.Button(frame, text="Save Options", command=save_options)
    save_btn.pack()


def quit_app():
    root.destroy()
    exit()


# Identify which OS we are running on
print("sys.platform:", sys.platform)
print("Project Path:", PROJECT_PATH)
script_ext = MAC_EXTENSION
script_pre = MAC_PREFIX
if sys.platform == "win32":
    script_ext = WIN_EXTENSION
    script_pre = ""
elif sys.platform == "linux":
    script_pre = LINUX_PREFIX

if script_pre != "":
    print("We will use", script_pre, "as prefix to run scripts with extension", script_ext)
else:
    print("We will use scripts with extension", script_ext)

# Main window
root = tk.Tk(className='Minecraft Launcher for CNet')
root.resizable(False, False)
root['padx'] = 100
root['pady'] = 10

# Buttons
launch_btn = tk.Button(root, text="Launch Game", command=launch_game, fg='green', width=15)
launch_btn.pack()

map_btn = tk.Button(root, text="Reset Map", command=reset_map, fg='blue', width=15)
map_btn.pack(pady=10)

options_btn = tk.Button(root, text="Options", command=open_options_window, fg='orange', width=15)
options_btn.pack()

quit_btn = tk.Button(root, text="Quit", command=quit_app, width=10)
quit_btn.pack(pady=10)

# Define quality_var globally to be accessed in save_options and update_parameters
quality_var = tk.StringVar()
options_window = None

# Run the Tkinter event loop
root.mainloop()
