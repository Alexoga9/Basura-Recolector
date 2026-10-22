$archivos = @(Get-ChildItem -LiteralPath 'Entidades/Basura/Caja/Obstaculos' -Recurse -Filter '*.tres') + @(Get-ChildItem -LiteralPath 'Escenarios/Mundos' -Filter '*.tscn')
foreach ($archivo in $archivos) {
    $texto = [IO.File]::ReadAllText($archivo.FullName)
    if ($archivo.Name -eq 'piedra cesped claro.tres') {
        $texto = [regex]::Replace($texto, '(?ms)\[sub_resource type="GDScript".*?(?=\[sub_resource)', '')
        $texto = $texto.Replace('script = SubResource("GDScript_vbpxe")', 'script = ExtResource("3_presentacion")')
        $texto = $texto.Replace('[sub_resource type="AtlasTexture" id="AtlasTexture_86fdr"]', "[ext_resource type=`"Script`" path=`"res://Recursos/LootDefinicion.gd`" id=`"3_presentacion`"]`n`n[sub_resource type=`"AtlasTexture`" id=`"AtlasTexture_86fdr`"]")
    }
    $nuevo = [regex]::Replace($texto, '(?ms)(\[(?:sub_resource type="Resource"[^\]]*|resource)\]\r?\n)(.*?)(?=\n\[|\z)', {
        param($m)
        $contenido = $m.Groups[2].Value
        $perfil = 0
        if ($contenido -match 'nombre = "Arbol') { $perfil = 1 }
        elseif ($contenido -match 'nombre = "(?:Piedra|Pe.on)') { $perfil = 2 }
        elseif ($contenido -match 'nombre = "hierba') { $perfil = 3 }
        if ($perfil -gt 0 -and $contenido -notmatch 'perfil_mundo =') {
            $contenido = $contenido.TrimEnd() + "`nperfil_mundo = $perfil`n"
        }
        return $m.Groups[1].Value + $contenido
    })
    if ($nuevo -ne [IO.File]::ReadAllText($archivo.FullName)) {
        [IO.File]::WriteAllText($archivo.FullName, $nuevo, [Text.UTF8Encoding]::new($false))
        Write-Output $archivo.Name
    }
}
