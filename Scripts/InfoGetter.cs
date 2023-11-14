using Godot;
using System;
using System.IO;
using GImage = Godot.Image;
using IronSoftware.Drawing;


public partial class InfoGetter : Node
{
    Variant GetInfo(string path)
    {
        var tfile = TagLib.File.Create(path);
        string title = tfile.Tag.Title;
        string artist = tfile.Tag.FirstPerformer;
        string album = tfile.Tag.Album;
        TimeSpan duration = tfile.Properties.Duration;

        var sd = (Node)GD.Load("res://Classes/SongData.gd").Call("new");
        ImageTexture tex;

        if (tfile.Tag.Pictures.Length > 0)
        {
            AnyBitmap cover = AnyBitmap.FromBytes(tfile.Tag.Pictures[0].Data.Data);
            //GD.Print(cover.BitsPerPixel);
            var img = GImage.CreateFromData(cover.Width, cover.Height, false, GImage.Format.Rgb8, cover.GetRGBBuffer());
            tex = ImageTexture.CreateFromImage(img);
        }
        else
        {
            tex = ImageTexture.CreateFromImage(  GImage.LoadFromFile(  "res://Textures/Placeholder.png"  )  );
        }

        sd.Call("setup", title, artist, album, tex);
        return sd;
    }
}
