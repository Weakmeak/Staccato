using Godot;
using System;
using System.IO;
using GImage = Godot.Image;
using System.Drawing;


public partial class InfoGetter : Node
{
    void GetInfo(string path)
    {
        var tfile = TagLib.File.Create(path);
        string title = tfile.Tag.Title;
        string artist = tfile.Tag.FirstPerformer;
        string album = tfile.Tag.Album;
        GD.Print(tfile.Tag.Pictures.Length > 0 ? "Has Image" : "No Image");
        TimeSpan duration = tfile.Properties.Duration;
        //GD.Print("Title: " + title + "\nArtist: " + artist + "\nAlbum: " + album + "\nduration:", duration);

        var sd = (Node)GD.Load("res://Classes/SongData.gd").Call("new");
        ImageTexture tex;

        if (tfile.Tag.Pictures.Length > 0)
        {
            MemoryStream ms = new MemoryStream(tfile.Tag.Pictures[0].Data.Data);
            //System.Drawing.Image image = System.Drawing.Image.FromStream(ms);
            System.Drawing.Image cover = System.Drawing.Image.FromStream(ms);
            var img = GImage.CreateFromData(cover.Width, cover.Height, false, GImage.Format.R8, tfile.Tag.Pictures[0].Data.Data);
            tex = ImageTexture.CreateFromImage(img);
            sd.Call("setup", title, artist, album, tex);
        }
    }
}
