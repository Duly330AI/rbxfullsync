# rbxfullsync – VS Code → Roblox Studio (Rojo)

**Ziel:** Dateien im Repo sind die Quelle der Wahrheit. Rojo spiegelt sie live nach Roblox Studio.
Eine 2‑Wege‑Synchronisation (Studio → Dateien) existiert nicht; einmalige Importe erfolgen über `.rbxlx` + `rbxmk`.

## Setup

1. **Tools installieren**
   ```bash
   aftman install
   wally install
   ```

2. **Live-Sync starten**
   ```bash
   rojo serve
   ```
   In Roblox Studio das Rojo-Plugin öffnen und **Connect** klicken.

3. **Testen**
   - Starte Roblox Studio – im Output sollten Meldungen von `ServerInit` und `ClientInit` erscheinen.

## Struktur

```
src/
  shared/               -> ReplicatedStorage/Shared
  server/               -> ServerScriptService/*
  client/               -> StarterPlayer/StarterPlayerScripts/*
  workspace/            -> Workspace/* (statische Szenen)
  lighting/             -> Lighting/*
  startergui/           -> StarterGui/*
  replicatedfirst/      -> ReplicatedFirst/*
  replicatedstorage/    -> ReplicatedStorage root
  models/               -> ReplicatedStorage/Models/*
```

## Einmaliger Import aus Studio (optional)

1. In Studio: **File → Save to File...** als `place.rbxlx` speichern.
2. Mit `rbxmk` extrahieren (Beispiel):
   ```bash
   rbxmk run -i place.rbxlx -e "select $.Workspace > writeDir src/workspace; select $.ReplicatedStorage.Models > writeDir src/models"
   ```

## Hinweise
- Bitte ab jetzt nur im Repo ändern (nicht im Studio editieren).
- Dynamische Inhalte generieren (Code/Generatoren) statt manuell platzieren.
