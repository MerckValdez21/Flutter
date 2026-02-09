import 'package:sqflite/sqflite.dart' ;

class DatabaseHelper {
  //Initialize Variable for Database file
  static final _dbName = 'student.db';
  //Initialize private database connection link/nullable
  Database? _db;
  //Create a private method to open the Database file
  Future<Database> _database() async{
    final existing = _db;
    if(existing != null) return existing;
    //Get the path of the Database file
    final path = await getDatabasesPath(); //emulated/0/student.db
    //Initialize variable to hold the returned value of Database Configuration
    final db = await openDatabase(
      //Path of Database file
        '$path/$_dbName',
      //Version of Database file
      version: 1,
      //Property that will call the contruction of Database TABLE
      onCreate: (db, version) async{
          //Query to Construct student Table
          await db.execute("""
          CREATE TABLE IF NOT EXISTS students(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fullName TEXT NOT NULL,
          username TEXT NOT NULL,
          password TEXT NOT NULL,
          dataAdded DATETIME NOT NUL DEFAULT CURRENT_TIMESTAMP
          )
          """);
          //You can add another table construction below
        await db.execute("""
        
        """);
      }


    );

    _db = db;
    return db;
  }
  //Method to insert data to students table CREATE
  Future<int> insertStudent(String fullName, String username, String password) async{
    //Initialize database Connection Link
    final db = await _database();
    //Prepare pair of data('columnName': sourceFromParameter)
    final data = {'fullName': fullName, 'username': username, 'password': password};
    return await db.insert('students', data);
  }
  //Method to Read Data from the Table - READ
  Future<List<Map<String, dynamic>>> getAllStudents() async{
    //Initialize database connection link
    final db = await _database();
    //Query to get all data from a students table
    return await db.query('students', orderBy: 'fullName ASC');
    //return await db.rawQuery("SELECT * FROM students ORDER BY fullName ASC");
  }
  //Method to Update data into the students Table - UPDATE
  Future<int> updateStudent(int studentID, String fullName, String username, String password) async{
    //Initialize database Connection Link
    final db = await _database();
    //Prepare updated data
    final data = {'fullName': fullName, 'username': username, 'password': password};
    //Execute the update to change data of a student with id coming from the parameter
    return await db.update('students', data, where: 'id: ?', whereArgs: ['studentID']);
    //return await db.rawUpdate("UPDATE students SET fullName = ?, username = ?, password = ? VALUES('$fullName', '$username', '$password' WHERE id = '$studentID')");
  }
  //Method to delete student - DELETE
  Future<int> deleteStudent(int id) async{
    //Initialize Database Connection Link
    final db = await _database();
    return await db.delete('students', where: 'id = ?', whereArgs: ['$id']);
    //return await db.rawDelete("DELETE FROM students WHERE id = '$id'");
  }
  //Method to select User from Database with Condition - loginUser
  Future<List<Map<String, dynamic>>> loginUser(String username, String password) async{
    //Initialize Database Connection Link
    final database = await _database();

    return await database.query('students', where: 'username = ? AND password = ?', whereArgs: [username, password]);

  }

  }