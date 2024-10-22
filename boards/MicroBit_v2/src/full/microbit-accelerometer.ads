------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2018-2019, AdaCore                      --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with LSM303AGR;

package MicroBit.Accelerometer is
   MagMinX : Float := -1.0 ; -- -32767.0;
   MagMinY : Float := -6.0 ; -- -32767.0;
   MagMinZ : Float := -8.0;    --  -32767.0;

   MagMaxX : Float :=  11.0 ; -- 32767.0;
   MagMaxY : Float :=  7.0; -- 32767.0;
   MagMaxZ : Float :=  4.0; -- 32767.0;

   function AccelDataRaw return LSM303AGR.All_Axes_Data_Raw;

   function AccelData return LSM303AGR.All_Axes_Data;
   --  Return the acceleration value for each of the three axes (X, Y, Z)

   function MagData return LSM303AGR.All_Axes_Data;
   --  Return the magneto value for each of the three axes (X, Y, Z)

   function Map ( Value : Float;
                  A1 : Float; -- Range Min (from)
                  A2 : Float; -- Range Max (from)
                  B1 : Float; -- Range Min (to)
                  B2 : Float -- Range Max (to)
                ) return Float;
   -- Return mapped value

   function Heading return LSM303AGR.Angle;
   -- Return the heading based on the magnetometer
end MicroBit.Accelerometer;
