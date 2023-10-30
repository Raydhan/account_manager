import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class controle extends GetxController
{
  RxBool temp=false.obs;

  // setting
  RxString que="Security Question 1".obs,que1="Security Question 2".obs;
  //password
  RxString ans="".obs;
  pass(String a)
  {
    ans.value=ans.value+a;
  }

  //database
  static Database? database;
 Future data_b()
  async {

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'account_manager');
     database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE account (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, credit INTEGER, debit INTEGER,balance INTEGER)');
        });
  }



  //view data
  RxList name=[].obs;
  RxList credit=[].obs;
  RxList debit=[].obs;
  RxList balance=[].obs;
  RxList an_id=[].obs;

  Future get_account()
  async{
    name.value.clear();
    credit.value.clear();
    debit.value.clear();
    balance.value.clear();
    an_id.value.clear();

    temp.value=false;

    String qur="select * from account";
    List<Map> m=[];
    m=await database!.rawQuery(qur);

    m.forEach((element) {
      name.value.add(element['name']);
      credit.value.add(element['credit']);
      debit.value.add(element['debit']);
      balance.value.add(element['balance']);
      an_id.value.add(element['id']);
    });
    print("View data:-${m}");
    temp.value=true;
  }

  //add data
  add(String name1)
  async {
    String qyr="insert into account values(null,'$name1',0,0,0)";
    int insert1=await database!.rawInsert(qyr);
    print("insert data :- ${insert1}");
  }

  delete_account(int id)
  {
    String qry="delete from account where id=$id";
    database!.rawDelete(qry);
  }
  update_account(int id,String name1)
  {
    String qur="update account set name='$name1' where id=$id";
    database!.rawUpdate(qur);
  }
}