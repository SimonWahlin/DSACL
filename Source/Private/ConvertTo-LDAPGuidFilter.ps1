function ConvertTo-LDAPGuidFilter {
    [CmdletBinding()]
    param (
        [guid]$Guid
    )
    process {
        '\{6}{7}\{4}{5}\{2}{3}\{0}{1}\{11}{12}\{9}{10}\{16}{17}\{14}{15}\{19}{20}\{21}{22}\{24}{25}\{26}{27}\{28}{29}\{30}{31}\{32}{33}\{34}{35}'-f([string[]]$Guid.ToString().ToCharArray())
    }
}
