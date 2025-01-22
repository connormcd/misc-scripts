import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class FetchSize {
  public static void main(String[] args) throws SQLException {
    // try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:MYUSER/MYPASS@//MYHOST/MYDB")) {
       try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:MYUSER/MYPASS@//MYHOST/MYDB?defaultRowPrefetch=1000")) {
      try (Statement stmt = con.createStatement()) {
        System.out.println("Creating test table");
        try {
          stmt.execute("drop table tmp_fetch_demo purge");
        }
        catch (SQLException ignored) {
        }

        stmt.execute("create table tmp_fetch_demo as select a.* from all_objects a, ( select 1 from dual connect by level <= 50) ");


//        stmt.execute("""
//            create table tmp_fetch_demo as
//            select a.*
//              from all_objects a, (select 1 from dual connect by level <= 50)""");
        System.out.println("Done.");

// If you want to trace this
//
//        stmt.execute("alter session set tracefile_identifier = FETCH");
//        stmt.execute("alter session set sql_trace = true");

        int newFetchSize;

        if (args.length > 0 && (newFetchSize = Integer.parseInt(args[0])) > 0) {
          System.out.println("Setting JDBC Statement default fetch size to " + newFetchSize);
          stmt.setFetchSize(newFetchSize);
        }
        else if (stmt.getFetchSize() == 10) {
          System.out.println("Keeping default JDBC Statement default fetch size (" + stmt.getFetchSize() + ")");
        }
        else {
          System.out.println("JDBC Statement default fetch size set to " + stmt.getFetchSize() + " using connection string parameter");
        }

        try (ResultSet rs = stmt.executeQuery("select object_id, object_name from tmp_fetch_demo")) {
          System.out.println("Querying all rows");
          long startTime = System.nanoTime();
          long cnt = 0;
          while (rs.next()) {
            int v1 = rs.getInt(1);
            String v2 = rs.getString(2);
            cnt++;
          }

          System.out.println("ResultSet fetch size " + rs.getFetchSize());
          long duration = (System.nanoTime() - startTime) / 1000000L;
          long tp = (long) ((double) cnt / duration * 1000d);
          System.out.printf("Rows fetched %d%nDuration %d ms%nThroughput %d rows/sec%n", cnt, duration, tp);
        }
      }
    }
  }
}
