import base64
import getpass
import hashlib
import os

# As per https://github.com/qbittorrent/qBittorrent/blob/7487cd7e6ddb94b458a9d55db252bbe1ab7fb59e/src/base/utils/password.cpp#L50
iterations = 100_000

# 4x32 bits words = 16 bytes: https://github.com/qbittorrent/qBittorrent/blob/7487cd7e6ddb94b458a9d55db252bbe1ab7fb59e/src/base/utils/password.cpp#L92
salt_size = 16

# Prompt user for password
password = "admin"

# Generate a cryptographically secure pseudorandom salt
salt = os.urandom(salt_size)

# PBKDF2 w/ SHA512 hmac
h = hashlib.pbkdf2_hmac("sha512", password.encode(), salt, iterations)

# Base64 encode and join salt and hash
print(f"Hash: {base64.b64encode(salt).decode()}:{base64.b64encode(h).decode()}")