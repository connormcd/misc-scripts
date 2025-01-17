import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.ZonedDateTime;

import oracle.jdbc.internal.OraclePreparedStatement;

public class FetchSize {
     public static void main(String[] args) {
         Connection con = null;
         Statement stmt = null;
         ResultSet rs = null;
         int v1;
         int cnt = 0;
         String v2;
         try {
             Class.forName("oracle.jdbc.driver.OracleDriver");
             con =  DriverManager.getConnection("jdbc:oracle:thin:MYUSER/MYPASS@//MYHOST/MYDB");
             stmt = con.createStatement();
             System.out.print("Creating test table\n");
             try { stmt.execute("drop table tmp_fetch_demo purge"); } catch (SQLException e) {}
             stmt.execute("create table tmp_fetch_demo as select a.* from all_objects a, ( select 1 from dual connect by level <= 50) ");
             System.out.print("Done.\n");

             stmt.execute("alter session set tracefile_identifier = FETCH");
             stmt.execute("alter session set sql_trace = true");

             if ( Integer.parseInt(args[0]) > 0 )
             {
                 stmt.setFetchSize(Integer.parseInt(args[0]));
             }
             rs = stmt.executeQuery("select object_id, object_name from tmp_fetch_demo");
             System.out.print("Querying all rows\n");
             long startTime = System.nanoTime();
             while(rs.next()) {
                 v1 = rs.getInt(1);
                 v2 = rs.getString(2);
                 cnt = cnt + 1;
             }
             long duration = ( System.nanoTime() - startTime ) / 1000000;
             System.out.print("Rows fetched " + cnt + ", " + duration + " ms\n");
             int  tp = ( 500000 / (int) duration * 1000 );
             System.out.print("Throughput " + tp + "/sec\n");

         } catch (ClassNotFoundException e) {
             e.printStackTrace();
         } catch (SQLException e) {
             e.printStackTrace();
         }
     }
}