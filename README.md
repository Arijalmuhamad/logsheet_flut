# Logsheet Automation Flutter Mobile Application


## Getting Started

Logsheet Application adalah aplikasi pencatatan hasil dari pengolahan minyak dari pabrik Downstream dan pembuatan reporting.

## Requirements
* Flutter SDK : >=3.32.0
* Dart SDK: >=3.8.0 <4.0.0
* Android Studio / VS Code
* Git CLI / GitHub Desktop
* Android Emulator / Physical Device

## Langkah Instalasi Project
### 1. GitHub Clone Repository
```
git clone https://github.com/AlvinHartono/logsheet_flut.git
cd logsheet_flut
flutter pub get
```

### 2. Konfigurasi Environment
Tambah/Paste ```.env``` file di ```/lib```
```
DB_HOST=HOST_NAME
DB_PORT=PORT_NUMBER
DB_NAME=DATABASE_NAME
DB_USER=DATANASE_USER
DB_PASSWORD=DATABASE_PASSWORD
```

### 3. Menjalankan Project
Untuk menjalankan aplikasi dapat menggunakan command
```
flutter run
```
atau dengan shortcut ```fn + f5``` di VSCode.
> Pastikan bahwa file key.properties telah dimasukkan ke dalam project dan terletak di logsheet_flut/android/

### 4. Build untuk Production
Android:
```
flutter build apk --release
```
> Pastikan bahwa file upload-keystore.jks telah dimasukkan ke dalam project dan terletak di logsheet_flut/android/app/

>File .env, key.properties, dan upload-keystore.jks berisi kredensial sensitif.
Jika Anda belum memiliki file tersebut, silakan hubungi developer untuk mendapatkan file tersebut dan panduan konfigurasi lebih lanjut melalui kontak resmi proyek atau tim pengembang.
