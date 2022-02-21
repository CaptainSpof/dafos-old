{ self, hmUsers, config, pkgs, ... }:
{
  home-manager.users = { inherit (hmUsers) daf; };

  age.secrets = {
    daf.file = "${self}/agenix/daf.age";
  };

  users.users.daf = {
    uid = 1111;
    description = "Cédric Da Fonseca";
    isNormalUser = true;
    extraGroups = [ "audio" "wheel" ];
    password = "daf";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkMUUwRW95/DuanXq8qh3Jfjo5RIkKUvx3NPGc6P8A0 daf@dafbox"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7YCmRYdXWhNTGWWklNYrQD5gUBTFhvzNiis5oD1YwV daf@daftop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGBJKhslXRQ4Bt8Nu3/YK799UsUpzpP6sDVkVw36nLR daf@dafpi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2j9R7kk4o0FiCN0HED4gjzFun8TnybrsCAVTgGxwqb root@nixos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaCrVCrtF7kJjqILLTpE/pBr9XoyRbPXN/wgHIHO3FPQc1lKelJG0q/k31jA4WxyYpdMivJFMkewWwCnM8l52qgdUrJkVZMYXPXVpRGwxkXJs4B4Ud7TjFvUAzQXNQIpKRGky9PneVb0x20DRt4Ddm05Mqv4MaCP8ys5ava0nb2zgBhXx9xW18ZKds+gOLUn5/+y4ppdOSBu8rdnfy2+aYEJTX+H0Hg1qNkwyK2+C0JpfFH3fQ2k0UBq/s3rn3+yiHQRvo7ZO5WT3cVA0tOx2CJt4L6nLP2D7C4y8VIbsQYDcjy8Bb+CdE82gYCQQu1F8xUCcdZdk/Zs1Qqpp+7mDXduI0xVMQEK/XEDzaYDK//9/JH3t5k0UuZWmmFuDssr6uDl5zw/qzLp898JxJO3HVIcswvM9SJGMGpL7MRxzGoRJjsaYhKehTOhOEyIlyZscbD8k3mGjGB8BNGnmBs1w+79upS2TfPx9pEEZyFNl354A/fd6piNreI0XFZMew3Sllq/aoq6eu1gel0s1oonvoHrdlJ7zlj/brkT4INh7iGRIh6dHk6ias0NhnjTLlu71sEQQh1x6MY3Qkvwn4lQOF4pSr2C2YS5m7M6cijRDnglfVngs/xWcwYaDpUSP2Mfmd28EG0LlOkUsLOIvYChSY0ePKsGaIu8AXp5qR6MNF3w== root@nixos"
    ];
    shell = pkgs.zsh;
    # passwordFile = "/run/secrets/daf";
  };
  # TODO: find a way to set options per user
  # users.git.user.name = "CaptainS";
  # profiles.git.user.email = "captain.spof@gmail.hihi";
}
