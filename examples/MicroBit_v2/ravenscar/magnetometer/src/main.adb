with LSM303AGR; use LSM303AGR;
with MicroBit.Accelerometer;
with MicroBit.Console; use MicroBit.Console;
use MicroBit;
procedure Main is

    Data: All_Axes_Data;
    Heading : Angle;
    MinX, MinY, MinZ, MaxX, MaxY, MaxZ : Axis_Data := 0;
begin
   loop
    Data := Accelerometer.MagData;

    if Data.X < MinX then
      MinX := Data.X;
    end if;

    if Data.Y < MinY then
      MinY := Data.Y;
end if;

    if Data.Z < MinZ then
      MinZ := Data.Z;
end if;

   if Data.X > MaxX then
      MaxX := Data.X;
      end if;

   if Data.Y > MaxY then
      MaxY := Data.Y;
      end if;

   if Data.Z > MaxZ then
      MaxZ := Data.Z;
      end if;

    Put_Line ("MIN X Y Z;" & MinX'Img & MinY'Img & MinZ'Img);
    Put_Line ("MAX X Y Z;" & MaxX'Img & MaxY'Img & MaxZ'Img);

   --   Put_Line ("MAG;" &
   --               "X,"  & Data.X'Img & ";" &
   --               "Y,"  & Data.Y'Img & ";" &
   --               "Z,"  & Data.Z'Img);

    Heading := AcceleroMeter.Heading;
         Put_Line("Heading;" & Heading'Img);
    delay 0.5;
   end loop;
end Main;
