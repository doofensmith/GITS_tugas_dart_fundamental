// @dart=2.9

import 'dart:io';

//main meethod untuk eksekusi
main(List<String> args) {
  //buat akun
  var list_akun = [];
  //list_akun = buat_akun();
  list_akun.add(Akun(0, "Wahyu", 500000));
  list_akun.add(Akun(1, "Spongebob", 10000));
  list_akun.add(Akun(2, "Sendi", 20000));

  //perulangan program
  loop_program:
  while (true) {
    //memilih akun yang digunakan untuk transaksi
    //pertama - tama menampilkan dulu semua akun yang ada
    tampil_akun(list_akun, "tampil semua", true);
    //id akun yang akan digunakan untuk transaksi
    var id_akun;
    //memilih akun
    loop_pemilihan_akun:
    while (true) {
      stdout.write("Pilih akun berdasar ID : ");
      id_akun = int.parse(stdin.readLineSync());
      print("");
      //kondisi ketika jika akun yang dipiih tidak ada
      if (id_akun >= 0 && id_akun < list_akun.length) {
        break loop_pemilihan_akun;
      } else {
        print("Akun tidak ada. Silahkan pilih yang tersedia.\n");
      }
    }

    //menu utama, menggunakan perulangan
    loop_menu_utama:
    while (true) {
      //menampilkan menu utama
      print("--------------------------------------\n"
          "=== ATM Sederhana ===\n"
          "Silahkan pilih menu:\n"
          "1. Info akun dan saldo\n"
          "2. Transfer\n"
          "3. Tarik tunai\n"
          "4. Setor tunai\n"
          "5. Selesai transaksi\n");

      //pilih menu
      stdout.write("Pilih menu: ");
      var menu_utama = int.parse(stdin.readLineSync());
      print("");

      //fungsionalitas menu, dengan percabangan
      switch (menu_utama) {
        case 1:
          {
            info_akun(list_akun[id_akun]);
            break;
          }
        case 2:
          {
            transfer(list_akun[id_akun], list_akun);
            break;
          }
        case 3:
          {
            tarik_tunai(list_akun[id_akun]);
            break;
          }
        case 4:
          {
            setor_tunai(list_akun[id_akun]);
            break;
          }
        case 5:
          {
            print("Terimakasih telah menggunakan ATM ini.\n");
            //kondisi melanjutkan program atau tidak
            stdout.write("Ingin melanjutkan program ATM ? (y/n) : ");
            var lanjut = stdin.readLineSync();
            print("");
            if (lanjut.toLowerCase() == 'y') {
              break loop_menu_utama;
            } else {
              break loop_program;
            }
            break;
          }
        default:
          {
            print("Menu tidak tersedia.\n");
          }
      }
    }
  }
}

//metode untuk membuat akun
List buat_akun() {
  //akun disimpan dalam list
  var list_akun = [];

  //nomor id akun
  int id = 0;

  //menu pembuatan akun dengan perulangan
  loop_buat_akun:
  while (true) {
    //menu pembuatan akun
    print("--------------------------------------\n"
        "Pembuatan Akun ID: $id\n"
        "1. Buat akun\n"
        "2. Selesai\n");
    stdout.write("Pilih menu: ");
    var menu_buat = int.parse(stdin.readLineSync());
    print("");

    //fungsionalitas menu
    switch (menu_buat) {
      case 1:
        {
          //input data awal akun
          stdout.write("Nama akun : ");
          String nama_akun = stdin.readLineSync();
          stdout.write("Saldo awal : ");
          var saldo_awal = int.parse(stdin.readLineSync());
          //buat akun
          Akun akun = new Akun(id, nama_akun, saldo_awal);
          //simpan akun ke list
          list_akun.add(akun);
          //tambah nilai id
          id++;
          break;
        }

      case 2:
        {
          break loop_buat_akun;
          break;
        }
      default:
        {
          print("Menu tidak tersedia.\n");
        }
    }
  }
  //return list
  return list_akun;
}

//method untuk menampilkan akun
void tampil_akun(
    List list_akun, var id_yang_tidak_ditampilkan, bool tampil_saldo) {
  print("--------------------------------------\n"
      "List Akun");
  for (var i = 0; i < list_akun.length; i++) {
    if (id_yang_tidak_ditampilkan == i) {
      continue;
    } else {
      print("\nID Akun\t\t: ${list_akun[i].getId()}");
      print("Nama Akun\t: ${list_akun[i].getNama()}");
      if (tampil_saldo) {
        print("Saldo Akun\t: ${list_akun[i].getSaldo()}\n");
      }
    }
  }
}

//metode untuk fungsi mada menu utama transfer
void transfer(Akun akun, List list_akun) {
  print("--- Transfer ---");
  //tahap pertama transfer adalah memilih akun yang dituju
  print("Pilih akun yang dituju:");
  tampil_akun(list_akun, akun.getId(), false);
  stdout.write("\nID akun yang dituju : ");
  var id_akun_tujuan = int.parse(stdin.readLineSync());
  //kondisi akun yang dipilih
  if (id_akun_tujuan == akun.getId() ||
      id_akun_tujuan < 0 ||
      id_akun_tujuan >= list_akun.length) {
    print("Akun tidak ditemukan.\n");
  } else {
    stdout.write("Masukkan jumlah transfer (min 10rb) : ");
    var jumlah_transfer = int.parse(stdin.readLineSync());
    //kondisi jumlah transfer kurang dari 10rb atau negatif
    if (jumlah_transfer < 10000 || jumlah_transfer <= 0) {
      print("Minimal transfer ke akun lain 10rb.\n");
    } else {
      //kondisi jika saldo tidak mencukupi
      if (jumlah_transfer > akun.getSaldo()) {
        print("Saldo anda tidak mencukupi.\n");
      } else {
        //transaksi berhasil
        //akun tujuan saldo bertambah
        list_akun[id_akun_tujuan]
            .setSaldo(list_akun[id_akun_tujuan].getSaldo() + jumlah_transfer);
        //akun saya saldo berkurang
        akun.setSaldo(akun.getSaldo() - jumlah_transfer);
        print(
            "Transaksi berhasil. Transfer anda akan diteruskan ke penerima.\n");
      }
    }
  }
}

//metode untuk fungsi pada menu utama tarik tunai
//hanya bisa mengunakan uang kelipatan 50rb
void tarik_tunai(Akun akun) {
  print("--- Tarik Tunai ---");
  stdout.write("Masukkan jumlah tarik tunai : ");
  var saldo_diambil = int.parse(stdin.readLineSync());
  print("");
  //kondisi cek uang kelipatan 50rb dan penarikan 0 atau negatif
  if (saldo_diambil % 50000 != 0 || saldo_diambil <= 0) {
    print("Penarikan di ATM ini hanya uang pecahan 50rb.\n");
  } else {
    if (saldo_diambil > akun.getSaldo()) {
      print("Saldo anda tidak mencukupi.\n");
    } else {
      akun.setSaldo(akun.getSaldo() - saldo_diambil);
      print("Transaksi berhasil. Silahkan ambil uang anda.\n");
    }
  }
}

//metode untuk fungsi pada menu utama setor tunai
//hanya bisa mengunakan uang kelipatan 50rb
void setor_tunai(Akun akun) {
  print("--- Setor Tunai ---");
  stdout.write("Masukkan jumlah setor tunai : ");
  var saldo_ditambahkan = int.parse(stdin.readLineSync());
  print("");
  //kondisi cek uang kelipatan 50rb dan penarikan 0 atau negatif
  if (saldo_ditambahkan % 50000 != 0 || saldo_ditambahkan <= 0) {
    print("Setor tunai di ATM ini hanya uang pecahan 50rb atau 100rb.\n");
  } else {
    //berhasil menambah saldo
    akun.setSaldo(akun.getSaldo() + saldo_ditambahkan);
    print("Transaksi berhasil. Saldo anda sudah ditambahkan.\n");
  }
}

//metode untuk fungsi pada menu utama info akun dan saldo
void info_akun(Akun akun) {
  print("--- Informasi Akun ---\n"
      "Nama akun\t: ${akun.getNama()}\n"
      "Saldo\t\t: Rp. ${akun.getSaldo()}\n");
}

//kelas akun digunakan untuk mempermudah
//menyimpan data akun seperti nama dan saldo
class Akun {
  var id;
  String nama;
  var saldo;

  //konstruktor
  Akun(var id, String nama, var saldo) {
    this.id = id;
    this.nama = nama;
    this.saldo = saldo;
  }

  //getter n setter
  getId() {
    return id;
  }

  void setId(var id) {
    this.id = id;
  }

  String getNama() {
    return this.nama;
  }

  void setNama(String nama) {
    this.nama = nama;
  }

  getSaldo() {
    return saldo;
  }

  void setSaldo(var saldo) {
    this.saldo = saldo;
  }
}
