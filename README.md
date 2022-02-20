# EnigmaPS
Enigma I PowerShell simulator

This is an Enigma I simulator I wrote, after seeing [this](https://www.youtube.com/watch?v=ybkkiGtJmkM) wonderfull animation by Jared Owen. It simulates the most common Enigma type, Wehrmacht Enigma I with 5 possible rotors.

I am not a programmer, so I am sorry if the code is poorly written. Various bits and pieces may be from other websites, I was learing as I was typing. Feel free to improve the code. I used a PowerShell ISE, one thing already there in Windows. GUI may display differently depending on screen resolution, scaling, and whether you run it from Powershell or Powershell ISE. I did not know hot to easily make it visually consistent, so it is up to you to adjust sizes and positions in the code.

Rotors are set through a drop-down menus, plugboard pairs through text box input. Changing settings mid typing is allowed as is theoretically with the real Enigma. Deleting text or characters from the input message works as a kind of "undo" for the settings as well. Program also automatically filters message and plugboard input keys and ignores "impossible" characters.

I have also uploaded a simpler, non-GUI version of the simulator, see [EnigmaPSdemo](https://github.com/longarivero/EnigmaPSdemo).
