package require PWI_Glyph 2.17.0
source [file join [file dirname [info script]] ".." "pwio.glf"]

foreach selType {Block Domain Connector} {
    if { ![getSelection $selType selectedEnts errMsg] } {
        puts $errMsg
        continue;
    }
    puts "$selType selection:"
    foreach ent $selectedEnts {
        set baseType [entBaseType $ent subType]
        puts "  [$ent getName]($ent) baseType='$baseType' subType='$subType'"
    }
}
