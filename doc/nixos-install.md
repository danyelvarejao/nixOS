# Instalar o NixOS no PC principal

Guia para instalar o host `desktop` do zero. **Isto apaga o disco inteiro.**

O disco alvo é o **XPG GAMMIX S70 de 954 GB**, declarado por modelo e serial em
`nix/system/desktop/default.nix`. O Windows fica no WD_BLACK e não é citado na configuração.

## Layout

Definido em `nix/system/modules/disk.nix`:

| Partição | Tamanho | Sistema |
| -------- | ------- | ------- |
| ESP      | 1 GB    | FAT32   |
| swap     | 32 GB   | swap    |
| root     | resto   | ext4    |

O disco fica sem criptografia.

## O que você precisa

- ISO do NixOS gravada em um pendrive.
- Internet na máquina durante a instalação.
- Repositório `nixOS` publicado no GitHub, para clonar sem login.

## Instalação

Inicie pelo pendrive usando o menu de boot da placa-mãe. O Secure Boot já está desligado.
Vire root com `sudo -i`.

### 1. Confirme o disco

```sh
ls -l /dev/disk/by-id/ | grep nvme-XPG_GAMMIX_S70_BLADE_2P47291792F9
```

Tem que aparecer exatamente esse disco. Se o comando não mostrar nada, pare: o serial na
configuração não corresponde à máquina.

### 2. Clone o repositório

```sh
git clone https://github.com/danyelvarejao/nixOS /tmp/nixOS
cd /tmp/nixOS
```

### 3. Gere o hardware real

```sh
nixos-generate-config --no-filesystems --show-hardware-config \
  > nix/system/desktop/hardware.nix
git add nix/system/desktop/hardware.nix
```

Sem o `git add`, o flake não enxerga o host `desktop`.

### 4. Ajuste o `stateVersion`

Em `nix/system/desktop/default.nix` e `nix/home/desktop/default.nix`, use a release da ISO que
está instalando. Depois disso, nunca mais mude esse valor.

```sh
git add -A
```

### 5. Apague, particione e monte o disco

```sh
nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake .#desktop
```

O comando pede confirmação antes de apagar.

### 6. Instale

```sh
nixos-install --no-root-passwd --no-channel-copy --flake .#desktop
nixos-enter --root /mnt -c 'passwd danyel'
```

### 7. Copie o repositório e reinicie

```sh
mkdir -p /mnt/home/danyel/Projects
cp -a /tmp/nixOS /mnt/home/danyel/Projects/nixOS
chown -R 1000:100 /mnt/home/danyel/Projects
reboot
```

Remova o pendrive. No firmware, deixe **Linux Boot Manager** como primeira opção. O Windows
continua disponível pelo menu de boot da placa-mãe.

## Primeiro boot

Faça login no TTY1. O Hyprland inicia em seguida. Abra o terminal e salve o hardware gerado:

```sh
gh auth login
cd ~/Projects/nixOS
git add -A
git commit -m "Adiciona o hardware do desktop"
git push
```

Coloque os hosts SSH privados em `~/.ssh/config.local`, que fica fora do Git.

## Se algo der errado

- No menu do `systemd-boot`, escolha uma geração anterior.
- Para reparar pelo pendrive, monte o sistema de novo e entre nele:

```sh
cd /tmp/nixOS
nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode mount --flake .#desktop
nixos-enter --root /mnt
```
