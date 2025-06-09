# used to generate export members to put in .psd1 file
Import-Module PSPKI -Force
function Export-Modulefunction {
    (gcm -mo PSPKI -CommandType Function | select -exp name | %{"'$_'"}) -join ",`r`n"
}
function Export-ModuleAlias {
    (gcm -mo PSPKI -CommandType Alias | select -exp name | %{"'$_'"}) -join ",`r`n"
}
