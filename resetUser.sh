#!/bin/bash

# Name des aktuellen Benutzers
CURRENT_USER=$(whoami)

# Überprüfen, ob der aktuelle Benutzer Administratorrechte hat
if [ "$CURRENT_USER"!= "root" ]; then
    echo "Dieses Skript muss als root ausgeführt werden."
    exit 1
fi

# Name des Benutzers, der gelöscht werden soll
USER_TO_DELETE="cc"

# Name des neuen Benutzers
NEW_USER="new_cc"

# Passwort für den neuen Benutzer
NEW_PASSWORD="IhrPasswortHier"

# Löschen des vorhandenen Benutzers
echo "Benutzer $USER_TO_DELETE wird gelöscht..."
sudo -u postgres psql -c "DROP USER IF EXISTS \"$USER_TO_DELETE\";"

# Erstellen des neuen Benutzers
echo "Neuer Benutzer $NEW_USER wird erstellt..."
sudo -u postgres psql -c "CREATE USER \"$NEW_USER\" WITH PASSWORD '$NEW_PASSWORD';"

# Überschreiben der Daten des alten Benutzers mit denen des neuen Benutzers
# Dies ist ein Platzhalterbefehl, da die genaue Syntax von der Datenbankstruktur abhängt
echo "Daten des alten Benutzers werden überschrieben..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO \"$NEW_USER\";"

# Löschen aller Daten des alten Benutzers
# Dies ist ein Platzhalterbefehl, da die genaue Syntax von der Datenbankstruktur abhängt
echo "Alle Daten des alten Benutzers werden gelöscht..."
sudo -u postgres psql -c "TRUNCATE TABLE mytable CASCADE;"

echo "Prozess abgeschlossen."

