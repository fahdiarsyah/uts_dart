class Todo {
  int? id;
  String nama;
  String deksripsi;
  bool done;

  Todo(this.nama, this.deksripsi, {this.done = false, this.id});

  static List<Todo> dummyData = [
    Todo("Latihan nyetir", "Menyetir mobil jam 7", done: true),
    Todo("Olahraga", "Badminton jam 8 malam"),
  ];

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'nama': nama,
      'deskripsi': deksripsi,
      'done': done
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      map['nama'] as String,
      map['deskripsi'] as String,
      done: map['done'] == 0 ? false : true,
      id: map['id'],
    );
  }
}