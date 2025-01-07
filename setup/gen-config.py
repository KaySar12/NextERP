#!/usr/bin/env python3
import configparser
import shutil
import os
from dotenv import set_key
from pathlib import Path

current = os.getcwd()
shutil.copyfile('../odoo.conf.sample', '../odoo.conf')
shutil.copyfile('../testing_env/env.template', '../testing_env/.env')
env_file_path = Path("../testing_env/.env")
config = configparser.ConfigParser()
config.read('../odoo.conf')
config['options']['db_host'] = 'localhost'
config['options']['db_user'] = 'nextzen'
config['options']['db_password'] = 'Smartyourlife123@*'
config['options']['db_port'] = '5432'
# Save some values to the file.
set_key(dotenv_path=env_file_path, key_to_set="PG_USER", value_to_set="nextzen")
set_key(dotenv_path=env_file_path, key_to_set="PG_PASS", value_to_set="Smartyourlife123@*")
set_key(dotenv_path=env_file_path, key_to_set="PG_PORT", value_to_set="5432")
# Write changes back to '../odoo.conf'
with open('../odoo.conf', 'w') as configfile:
    config.write(configfile)