#!/usr/bin/env python3
import configparser
import shutil
import os
from dotenv import set_key
from pathlib import Path
import socket
import secrets
import string

def generate_password(length=16):
    """Generates a random password of specified length."""
    alphabet = string.ascii_letters + string.digits
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def find_available_port(start_port=5432):
    """Finds an available port starting from the given port."""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        while True:
            try:
                sock.bind(('localhost', start_port))
                return start_port
            except OSError as e:
                if e.errno == 98:  # Address already in use
                    start_port += 1
                else:
                    raise

def main():
    """
    Generates a random password and finds an available port.
    Updates the Odoo configuration file and .env file with these values.
    """
    db_port = find_available_port()
    db_pass = generate_password(24)
    db_user = "nextzen"
    print(f"Available port found: {db_port}")
    print(f"Database password generated: {db_pass}")

    # Copy template files
    shutil.copyfile('odoo.conf.sample', 'odoo.conf')
    shutil.copyfile('testing_env/env.template', 'testing_env/.env')

    # Update Odoo configuration file
    config = configparser.ConfigParser()
    config.read('odoo.conf')
    config['options']['db_host'] = "localhost"
    config['options']['db_user'] = db_user
    config['options']['db_password'] = db_pass
    config['options']['db_port'] = str(db_port)
    with open('odoo.conf', 'w') as configfile:
        config.write(configfile)

    # Update .env file
    env_file_path = Path("testing_env/.env")
    set_key(dotenv_path=env_file_path, key_to_set="PG_USER", value_to_set=db_user)
    set_key(dotenv_path=env_file_path, key_to_set="PG_PASS", value_to_set=db_pass)
    set_key(dotenv_path=env_file_path, key_to_set="PG_PORT", value_to_set=str(db_port))

if __name__ == "__main__":
    main()
