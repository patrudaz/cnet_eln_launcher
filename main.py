import json
import os
import sys
import tkinter as tk
from tkinter import ttk, messagebox
from tkinter.scrolledtext import ScrolledText
import subprocess


FILE_PATH = os.path.join(os.getcwd(), "_internal")
SCRIPTS_PATH = os.path.join(os.getcwd(), "_internal", "scripts")
OPTIONS_FILE = os.path.join(os.getcwd(), "options.json")
BAT_EXT = ".bat"
SH_EXT = ".sh"
MAC_PREFIX = "./macos_"
LINUX_PREFIX = "./linux_"

# Default options
DEFAULT_OPTIONS = {
    "renderer": "Software"
}


def log(msg):
    global log_view

    log_view.configure(state='normal')
    log_view.insert(tk.END, msg + '\n')
    log_view.configure(state='disabled')
    log_view.yview(tk.END)


def run_subprocess(cmd):
    try:
        # Run bash script
        subprocess.Popen(cmd, shell=True)
    except subprocess.CalledProcessError as e:
        log(f"Error: {e}")


def launch_game():
    global platform

    # Replace the following command with the CMD command to launch your game
    log("Launching game...")
    log("File path: " + FILE_PATH)
    log("Current path: " + os.getcwd())

    os.chdir(SCRIPTS_PATH)
    log("changed to: " + os.getcwd())

    # Load options from JSON file or use defaults
    update_parameters()

    # set up script name
    run_script = script_pre + "run" + script_ext
    if (platform == "win32") and (quality_var.get() == "OpenGL"):
        run_script = script_pre + "run_OpenGL" + script_ext

    # run_command = (run_script + " " + FILE_PATH)
    run_command = (run_script + " ..")
    log("command: " + run_command)

    run_subprocess(run_command)


def reset_map():
    # Replace the following command with the CMD command to reset your map
    log("\nResetting map...")
    log("Current path: " + os.getcwd())
    os.chdir(SCRIPTS_PATH)
    log("changed to: " + os.getcwd())

    prefix = script_pre
    if script_pre != "":
        prefix = "./"

    run_command = prefix + "reset_map" + script_ext
    log("command: " + run_command)

    run_subprocess(run_command)


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


def linux_rights():
    # Changing the rights of _internal folder
    run_subprocess("SUDO_ASKPASS =${HOME}/.ssh/secrets/.supwd.sh")
    run_subprocess("export SUDO_ASKPASS")
    run_subprocess("sudo chmod -R u+r+w+x,g+r+w+x,o+r-w+x ../_internal")
    run_subprocess("sudo chmod a+w ../_internal/scripts/sh_log_cnet.txt")


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


# Checking OS
platform = sys.platform
script_ext = SH_EXT
script_pre = MAC_PREFIX
logo = "_internal/icon"
if platform == "win32":
    script_ext = BAT_EXT
    script_pre = ""
    logo = logo + ".ico"
elif platform == "linux":
    script_pre = LINUX_PREFIX
    logo = "@" + logo + ".xbm"

    # Changing rights, permissions & xattr
    linux_rights()
else:
    logo = logo + ".icns"

    # Changing rights, permissions & xattr
    app_path = os.path.join(os.getcwd(), "../../..")
    run_subprocess(os.getcwd() + "/remxttr.sh -R " + app_path + "CNetMinecraftLauncher.app")

# Main window
root = tk.Tk(className='Minecraft Launcher for CNet')
root.resizable(False, False)
root.iconbitmap(logo)
root.protocol("WM_DELETE_WINDOW", root.quit)
root['padx'] = 20
root['pady'] = 10

# Buttons: Because activebackground and bg do not work on macOS, we check the platform to create different button's layout
if (platform == "win32") or (platform == "linux"):
    launch_btn = tk.Button(root, text="LAUNCH GAME", command=launch_game, bg='#00C043', activebackground='#139A42',  fg='black', width=20, font=('Consolas', 24))
    map_btn = tk.Button(root, text="RESET MAP", command=reset_map, bg='#E30067', activebackground='#A5014B', fg='black', width=14, font=('Consolas', 16))
    quit_btn = tk.Button(root, text="QUIT", bg='#E4080A', activebackground='#8B0102', fg='black', command=root.quit, width=10, font=('Consolas', 12))

    if platform == "win32":
        options_btn = tk.Button(root, text="OPTIONS", command=open_options_window, bg='#15A8F8', activebackground='#0E76AE', fg='black', width=14, font=('Consolas', 16))
        options_btn.grid(row=1, column=1, pady=5, sticky='w')
else:
    launch_btn = tk.Button(root,  text="Launch Game", command=launch_game, fg='green', width=15)
    map_btn = tk.Button(root, text="Reset Map", command=reset_map, fg='blue', width=15)
    quit_btn = tk.Button(root, text="Quit", command=root.quit, width=10)

launch_btn.grid(row=0, column=0, columnspan=2, pady=15, sticky='s')
map_btn.grid(row=1, column=0, sticky='e', pady=5)
quit_btn.grid(row=2, columnspan=2, pady=10)

log_view = ScrolledText(root, state=tk.DISABLED)
log_view.configure(font='TkFixedFont', bg='gray2', fg='green3', height=10, width=80)
log_view.grid(row=3, columnspan=2, pady=20)

# Identify which OS we are running on
log(f"sys.platform: {sys.platform}")
log("Project Path: " + os.getcwd())

if script_pre != "":
    log("We will use `" + script_pre + "` as prefix to run scripts with extension " + script_ext)
else:
    log("We will use scripts with extension " + script_ext)

# Define quality_var globally to be accessed in save_options and update_parameters
quality_var = tk.StringVar()
options_window = None

# Run the Tkinter event loop
root.mainloop()

log("Asta la vista, baby!")

# log_file.close()
