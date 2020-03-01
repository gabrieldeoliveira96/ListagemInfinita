unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation,
  FMX.Layouts, FMX.Ani;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Rectangle1: TRectangle;
    Circle1: TCircle;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ListView1: TListView;
    Image1: TImage;
    Layout1: TLayout;
    Circle2: TCircle;
    SpeedButton4: TSpeedButton;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    procedure FormShow(Sender: TObject);
    procedure ListView1ScrollViewChange(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    lAbrirBotao: boolean;
    procedure CarregaLista;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{ TForm1 }

procedure TForm1.CarregaLista;
begin

  ListView1.BeginUpdate;
  for var I := 0 to 10 do
  begin
    with ListView1.Items.Add do
    begin
      Text := 'Usuario ' + ListView1.ItemCount.ToString;
      Bitmap := Image1.Bitmap;
    end;
  end;
  ListView1.EndUpdate;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  lAbrirBotao := true;
  Image1.Visible := false;
  Layout1.Position.X := self.Width;
  CarregaLista;
end;

procedure TForm1.ListView1ScrollViewChange(Sender: TObject);
var
  nTop, scrollTot: single;

begin
  nTop := ListView1.GetItemRect(ListView1.ItemCount - 1).top +
    ListView1.ScrollViewPos - ListView1.SideSpace - ListView1.LocalRect.top;
  scrollTot := nTop + ListView1.GetItemRect(ListView1.ItemCount - 1).height -
    ListView1.height;

  if ListView1.ScrollViewPos = scrollTot then
  begin
    if lAbrirBotao then
    begin
      lAbrirBotao := false;
      FloatAnimation1.StartValue := self.Width;
      FloatAnimation1.StopValue := self.Width - Layout1.Width;
      FloatAnimation1.Inverse := false;
      FloatAnimation1.Start;
    end;

    TThread.CreateAnonymousThread(
      procedure
      begin

        TThread.Synchronize(nil,
          procedure
          begin

            self.CarregaLista;

          end);
      end).Start;

  end;

end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  FloatAnimation2.StartValue := ListView1.ScrollViewPos;
  FloatAnimation2.StopValue := 0;
  FloatAnimation2.Inverse := false;
  FloatAnimation2.Start;
  lAbrirBotao := true;

  FloatAnimation1.Inverse := true;
  FloatAnimation1.Start;

end;

end.
