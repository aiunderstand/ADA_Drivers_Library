------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2015-2016, AdaCore                     --
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

--  Take advantage of the DMA2D to accelerate some graphical operations on
--  bitmap surfaces

with System;
with HAL.Bitmap;  use HAL.Bitmap;
with STM32.DMA2D;

package STM32.DMA2D_Bitmap is

   type DMA2D_Bitmap_Buffer is new Bitmap_Buffer with null record;
   type Any_DMA2D_Bitmap_Buffer is access all DMA2D_Bitmap_Buffer'Class;

   overriding procedure Set_Pixel
     (Buffer : in out DMA2D_Bitmap_Buffer;
      Pt     : Point;
      Value  : UInt32);

   overriding procedure Set_Pixel_Blend
     (Buffer : in out DMA2D_Bitmap_Buffer;
      Pt     : Point;
      Value  : HAL.Bitmap.Bitmap_Color);

   overriding function Pixel
     (Buffer : DMA2D_Bitmap_Buffer;
      Pt     : Point) return UInt32;

   overriding procedure Fill
     (Buffer : in out DMA2D_Bitmap_Buffer;
      Color  : UInt32);

   overriding procedure Fill_Rect
     (Buffer : in out DMA2D_Bitmap_Buffer;
      Color  : UInt32;
      Area   : Rect);

   overriding procedure Copy_Rect
     (Src_Buffer  : HAL.Bitmap.Bitmap_Buffer'Class;
      Src_Pt      : Point;
      Dst_Buffer  : in out DMA2D_Bitmap_Buffer;
      Dst_Pt      : Point;
      Bg_Buffer   : HAL.Bitmap.Bitmap_Buffer'Class;
      Bg_Pt       : Point;
      Width       : Natural;
      Height      : Natural;
      Synchronous : Boolean)
     with Pre =>
       Dst_Buffer.Color_Mode in HAL.Bitmap.ARGB_8888 .. HAL.Bitmap.ARGB_4444;

   overriding procedure Wait_Transfer (Buffer : DMA2D_Bitmap_Buffer);

   Null_Buffer : constant DMA2D_Bitmap_Buffer :=
                   (Addr       => System.Null_Address,
                    Width      => 0,
                    Height     => 0,
                    Color_Mode => HAL.Bitmap.L_8,
                    Swapped    => False);

   function To_DMA2D_Buffer
     (Buffer : HAL.Bitmap.Bitmap_Buffer'Class) return STM32.DMA2D.DMA2D_Buffer
     with Inline;

end STM32.DMA2D_Bitmap;
