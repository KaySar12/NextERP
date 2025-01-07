#!/usr/bin/env python3
import argparse
import configparser
import shutil
import os
from dotenv import set_key
from pathlib import Path
import socket
import secrets
import string
import color_log
def generate_password(length=16):
    """Generates a random password of specified length."""
    alphabet = string.ascii_letters + string.digits
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def find_available_port(start_port=80):
    """Finds an available port starting from the given port."""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        while True:
            try:
                sock.bind(('localhost', start_port))
                color_log.Show(3,f" {start_port} is Open")
                return start_port
            except OSError as e:
                if e.errno == 98:  # Address already in use
                    print(f"{start_port} already in use , Try other port ...")
                    start_port += 1
                else:
                    raise

def main():
    """
    Generates a random password and finds an available port.
    Updates the Odoo configuration file and .env file with these values.
    """
    parser = argparse.ArgumentParser(description="Generate Odoo configuration")
    parser.add_argument('--db_port', type=int, help='')
    parser.add_argument('--db_user', type=str, help='')
    parser.add_argument('--deploy_path', type=str, help='')
    parser.add_argument('--db', type=str, help='')
    parser.add_argument('--image', type=str, help='')
    parser.add_argument('--tag', type=str, help='')
    parser.add_argument('--addons', type=str, help='')
    parser.add_argument('--config', type=str, help='')
    parser.add_argument('--container', type=str, help='')
    parser.add_argument('--backup', type=str, help='')
    args = parser.parse_args()
    db_port = args.db_port
    db_pass = "smartyourlife"
    db_user = args.db_user
    base_dir= args.deploy_path
    db_name=args.db
    image=args.image
    tag=args.tag
    container=args.container
    addons=args.addons
    config_path=args.config
    app_port = 10017
    backup = args.backup
    # Copy template files
    os.makedirs(f"{base_dir}/etc", exist_ok=True)
    color_log.Show(3,f"Copy {base_dir}/odoo.conf.template to {base_dir}/etc/odoo.conf")
    shutil.copyfile(f'{base_dir}/odoo.conf.template', f'{base_dir}/etc/odoo.conf')
    shutil.copyfile(f'{base_dir}/env.template', f'{base_dir}/.env')

    # Update Odoo configuration file
    config = configparser.ConfigParser()
    config.read(f'{base_dir}/etc/odoo.conf')
    config['options']['db_host'] = "db"
    config['options']['db_user'] = db_user
    config['options']['db_password'] = db_pass
    config['options']['db_port'] = str(db_port)
    config['options']['addons_path'] = "/mnt/extra-addons"
    config['options']['data_dir'] = "/var/lib/odoo"
    config['options']['proxy_mode'] = "True"
    with open(f'{base_dir}/etc/odoo.conf', 'w') as configfile:
        config.write(configfile)

    # Update .env file
    env_file_path = Path("deployment/.env")
    set_key(dotenv_path=env_file_path, key_to_set="COMPOSE_PROJECT_NAME", value_to_set=f"odoo-{tag}",quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="PG_PORT", value_to_set=find_available_port(5432),quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="PG_DB", value_to_set=db_name,quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="PG_USER", value_to_set=db_user,quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="PG_PASS", value_to_set=db_pass,quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="ODOO_CONFIG", value_to_set=config_path,quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="ODOO_ADDONS", value_to_set=addons,quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="ODOO_PORT", value_to_set=find_available_port(app_port),quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="ODOO_IMAGE", value_to_set=image,quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="ODOO_TAG", value_to_set=tag,quote_mode="never")
    set_key(dotenv_path=env_file_path, key_to_set="ODOO_CONTAINER", value_to_set=container,quote_mode="never")
    if (backup == 'community'):
        set_key(dotenv_path=env_file_path, key_to_set="ODOO_BACKUP", value_to_set=f'{base_dir}/backup/ce',quote_mode="never")
    if (backup == 'enterprise'):
        set_key(dotenv_path=env_file_path, key_to_set="ODOO_BACKUP", value_to_set=f'{base_dir}/backup/enterprise',quote_mode="never")
if __name__ == "__main__":
    main()
