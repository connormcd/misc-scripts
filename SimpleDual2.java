//
//  Standard disclaimer - anything in here can be used at your own risk.
//
//  It is very likely you'll need to edit the script for correct usernames/passwords etc.
//
//  No warranty or liability etc etc etc. See the license file in the git repo root
//
//  *** USE AT YOUR OWN RISK ***
//

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.ZonedDateTime;

import oracle.jdbc.internal.OraclePreparedStatement;

public class SimpleDual2 {
     public static void main(String[] args) {
         Connection con = null;
         Statement stmt = null;
         ResultSet rs = null;
         int v1;

         try {
             Class.forName("oracle.jdbc.driver.OracleDriver");
             con =  DriverManager.getConnection("jdbc:oracle:thin:scott/tiger@//localhost:1530/pdb21a");
             long startTime = System.nanoTime();
             PreparedStatement pstmt = con.prepareStatement("select 1 x from dual");
             for (int obj = 1; obj <= 200000; obj++)
             {
                 rs = pstmt.executeQuery();
                 while(rs.next()) {
                   v1 = rs.getInt(1);
                 }
             }
             pstmt.close();
             long duration = ( System.nanoTime() - startTime ) / 1000000;
             System.out.print("200000 iterations, " + duration + " ms\n");
         } catch (ClassNotFoundException e) {
             e.printStackTrace();
         } catch (SQLException e) {
             e.printStackTrace();
         }
     }
}


