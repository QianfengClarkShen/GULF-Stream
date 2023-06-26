proc addip {ipName displayName} {
    set vlnv_version_independent [lindex [get_ipdefs -all *${ipName}* -filter {UPGRADE_VERSIONS == ""}] end]
    return [create_bd_cell -type ip -vlnv $vlnv_version_independent $displayName]
}
