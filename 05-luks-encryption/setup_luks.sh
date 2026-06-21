#!/bin/bash
# LUKS Disk Encryption Runbook - VM3 | Author: Nicolas Hoyos
#
# NOTE: This is a documented runbook, not a hands-off script. A few steps
# (luksFormat, luksOpen) are interactive and prompt for a passphrase, so run
# these one at a time and read the comments rather than executing the file.
#
# SAFETY: Never commit the keyfile, passphrase, or any private key to a repo.

# 1. Create a 100 MB file to act as a fake disk (so no real partition is touched)
dd if=/dev/zero of=secret.img bs=1M count=100

# 2. Attach the file to a loop device so Linux treats it as a real disk
sudo losetup --find --show secret.img          # prints e.g. /dev/loop3

# 3. Encrypt the device (installs the LUKS "safe"). Prompts: type YES, then a passphrase
sudo cryptsetup luksFormat /dev/loop3

# 4. Open the encrypted device, exposing it as an unlocked mapper device
sudo cryptsetup luksOpen /dev/loop3 secret_volume

# 5. Build an ext4 filesystem INSIDE the unlocked volume (always the mapper, never loop3)
sudo mkfs.ext4 /dev/mapper/secret_volume

# 6. Mount it and write a test file to prove it stores data
sudo mkdir /mnt/secure
sudo mount /dev/mapper/secret_volume /mnt/secure
echo "encrypted volume test data" | sudo tee /mnt/secure/secret.txt
sudo cat /mnt/secure/secret.txt

# 7. Lock it back up: unmount, then close (the close removes the mapper door)
sudo umount /mnt/secure
sudo cryptsetup luksClose secret_volume

# 8. PROOF: search the raw file for the plaintext (should find nothing, exit code 1)
sudo grep -a "encrypted volume test data" secret.img; echo "grep exit code: $?"
sudo hexdump -C secret.img | head -20          # raw bytes are scrambled noise

# --- Keyfile automation (unlock + mount without typing a passphrase) ---

# 9. Create a random 4 KB keyfile and lock it down to root only
sudo dd if=/dev/urandom of=/root/luks-keyfile bs=4096 count=1
sudo chmod 600 /root/luks-keyfile

# 10. Register the keyfile as a second valid key (prompts for the existing passphrase)
sudo cryptsetup luksAddKey /dev/loop3 /root/luks-keyfile

# 11. Configure /etc/crypttab and /etc/fstab (see crypttab.example and fstab.example)

# 12. Test the automation without rebooting:
sudo cryptdisks_start secret_volume            # reads crypttab, unlocks via keyfile
sudo mount /mnt/secure                          # reads fstab, mounts it
ls /mnt/secure                                  # secret.txt is back -> chain works
