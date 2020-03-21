program TesteSoftplanQ1;

uses
  Vcl.Forms,
  uTesteSoftplanQ1 in 'uTesteSoftplanQ1.pas' {frmTesteSoftplanQ1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTesteSoftplanQ1, frmTesteSoftplanQ1);
  Application.Run;
end.
