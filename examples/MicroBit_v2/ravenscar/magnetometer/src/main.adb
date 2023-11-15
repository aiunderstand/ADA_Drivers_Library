with LSM303AGR; use LSM303AGR;
with MicroBit.Accelerometer;
with MicroBit.Console; use MicroBit.Console;
use MicroBit;
procedure Main is

    Data: All_Axes_Data;
begin
   loop
    Data := Accelerometer.MagData;
    Put_Line ("MAG;" &
                "X,"  & Data.X'Img & ";" &
                "Y,"  & Data.Y'Img & ";" &
                "Z,"  & Data.Z'Img);

    delay 0.5;
   end loop;
end Main;
