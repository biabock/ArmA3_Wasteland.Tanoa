// infoPage.sqf
// by CRE4MPIE
// ver 0.1
// 2015-02-01 01:20pm
// contributions from BIStudio Forums, by CRE4MPIE
//<t align='center'><t size='1'><t shadow= 1 shadowColor='#000000'>fb.com/a3brothers</t><br />
//<t align='right'><img size='6' shadow = 0 image='addons\logo\logo.paa'/></t>";

sleep 30;   //delay before message is displayed after logging in
	
_text = "
<t align='center'><t shadow= 1 shadowColor='#FF0000'><t size='1.2'><t color='#ddbb22'>ArmaBrothers.com Wasteland Tanoa</t>
<br />
<t align='center'><t size='1'><t shadow= 1 shadowColor='#000000'>www.ArmaBrothers.com</t><br />
<t align='center'><t size='1'><t shadow= 1 shadowColor='#000000'>ts.armabrothers.com</t><br />
<br />
<t align='center'><t size='1.2'><t shadow= 1 shadowColor='#000000'>Keyboard Shortcuts</t><br />
<br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\windows.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Player Names</t><br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\end.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Insert/Remove Earplugs</t><br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\h.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Holster Weapon</t><br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\del.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Emergency Eject</t><br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\v.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Open/Cut Parachute</t><br />
<br />
<t align='center'><t size='1.2'><t shadow= 1 shadowColor='#0000ff'>Have fun and respect other players. Hacking or exploiting will get you banned</t>
<br />";


hint parseText format ["<t align='center'>Welcome %2</t><br />%1",_text, name player];