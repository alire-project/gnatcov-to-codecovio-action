with Ada.Text_IO;

package body Plop is

   procedure Check (A : Integer) is
   begin
      if A >= 0 then
         Ada.Text_IO.Put_Line ("A >= 0");
      else
         Ada.Text_IO.Put_Line ("A < 0");
      end if;
   end Check;

end Plop;
