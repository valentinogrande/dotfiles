-- ─── Window rules (Hyprland 0.55+, Lua) ──────────────────────────────────
-- Equivalente a las reglas del setup i3. hyprlang ya no soporta window
-- rules; desde 0.55 son Lua vía hl.window_rule().
--
-- Estas reglas SOLO se aplican si Hyprland carga una config Lua. No se
-- pueden mezclar con la config hyprlang (hyprland.conf) vía `source` —
-- el source parsea el .lua como hyprlang y falla. Para usarlas hay que
-- migrar hyprland.conf a Lua. Mientras tanto queda como referencia.

hl.window_rule({ match = { class = "^(pavucontrol)$" },        float = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ match = { class = "^(file-roller)$" },         float = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" },     float = true })
hl.window_rule({ match = { class = "^(galculator)$" },          float = true })
hl.window_rule({ match = { class = "^(gpick)$" },               float = true })
hl.window_rule({ match = { title = "^(btop)$" },                float = true, size = { 1000, 600 } })
hl.window_rule({ match = { title = "^(Open File)(.*)$" },       float = true })
