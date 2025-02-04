CMD:weaponhelp(playerid, params[])
{
	static const dlg[] = "{FFFFFF}\
			/buygun - mua vu khi o cua hang vu khi / o cho den. \n\
			/weapon - chinh sua phan dinh kem vu khi tren nhan vat: \n\
			/weapon edit [slot] - thay doi vi tri cua doi tuong vu khi; \n\
			/weapon bone [slot] - chon phan co the ma vu khi duoc gan vao; \n\
			/weapon hide [slot] - an doi tuong vu khi tren nhan vat; \n\
			/weapon reset [slot] - dat lai ve cai dat ban dau. \n\
			/reload - thay dan vu khi. \n\
			/optics - deo / thao kinh nhin quang hoc. \n\
			/silencer - deo / thao bo giam thanh. \n\
			/ta(ke)p(rime) - lay vu khi chinh. \n\
			/t(ake)s(econd) - lay vu khi phu. \n\
			/t(ake)m(elee) - lay vu khi cam tay. \n\
			/p(ut)g(un) - cat vu khi vao tui do. \n\
			/d(rop)gun - nem vu khi. \n\
			{FF6347} /ammohelp - tro giup dan duoc ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Vu Khi", mes, "Quay lai", "Dong");
	return 1;
}

CMD:ammohelp(playerid, params[])
{
	static const dlg[] = "{ffc46a}M1911 /M1911 (giam thanh){FFFFFF}\nCo san:\n\		
			- .45 ACP (7 rounds)\n\		
			- .45 ACP .ext (14 rounds)\n\n\		
			{ffc46a}Desert Eagle{FFFFFF}\nAvailable magazines:\n\		
			- .50AE (7 rounds)\n\		
			- .50AE .ext (14 rounds)\n\n\		
			{ffc46a}Shotgun /Sawn-off Shotgun{FFFFFF}\nAvailable magazines:\n\		
			- 12-G BIRDSHOT (6 rounds)\n\		
    		- 12-G BUCKSHOT (6 rounds)\n\		
    		- 12-G SLUG (6 rounds)\n\		
    		- 12-G BEANBAG (6 rounds) - non-lethal\n\n\		
			{ffc46a}Tec-9 /MP5 /UZI{FFFFFF}\nAvailable magazines:\n\		
			- 9x19mm (30 rounds)\n\		
			- 9x19mm .ext (60 rounds)\n\n\		
			{ffc46a}Country Rifle /Sniper Rifle{FFFFFF}\nAvailable magazines:\n\		
			- 7.62x51mm (4 rounds�)\n\n\		
			{ffc46a}M4{FFFFFF}\nAvailable magazines:\n\		
			- 5.56x45mm (30 rounds)\n\		
			- 5.56x45mm T (30 rounds)\n\		
			- 5.56x45mm (drum) (60 rounds)\n\		
			- 5.56x45mm (rubber) (30 rounds) - non-lethal\n\n\		
			{ffc46a}AK-47{FFFFFF}\nAvailable magazines:\n\		
			- 7.62x39mm (30 rounds)\n\		
			- 7.62x39mm T (30 rounds)\n\		
			- 7.62x39mm (drum) (60 rounds)";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, None, DIALOG_STYLE_MSGBOX, "Dan duoc", mes, "X", "");
	return 1;
}

CMD:drughelp(playerid, params[])
{
	static const dlg[] = "{FFFFFF}\
				Cac tuong tac co the xay ra ({FF6347} N {FFFFFF} hoac {FF6347} /inv {FFFFFF}> Nhap vao thuoc):\n\
				- Su dung thuoc;\n\
				- Cho thuoc vao hop banh pizza hoac tui Burger Shot;\n\
				- Chia, ket hop, loai bo va cac hanh dong khac.\n\n\
				{FF6347} /plant {FFFFFF} - gieo trong thuoc phien, can sa, coca\n\n\
				Lenh Phong thi nghiem Thuoc:\n\
				{FF6347} /mixdrug {FFFFFF} - mo menu ly tam / chuan bi san hon hop thuoc thu\n\
				{FF6347} /drydrug {FFFFFF} - mo menu don vi lam kho / lay thuoc thu lam kho\n\n\
				{FF6347} /pickupmix {FFFFFF} - nhat mot hon hop thuoc thu tu san nha\n\
				{FF6347} /dropmix {FFFFFF} - dat hon hop thuoc thu tren san\n\n\
				{FF6347} /reactor {FFFFFF} - dua hon hop thuoc thu vao lo phan ung / lay thuoc thanh pham tu lo phan ung\n\
				[!] Su dung {FF6347} /reactor {FFFFFF} de kiem soat nhiet do lo phan ung trong qua trinh tong hop. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Ma Tuy", mes, "Quay lai", "Dong");
	return 1;
}

CMD:techhelp(playerid, params[])
{
	static const dlg[] = "{FFFFFF}\
			/changepass - thay doi mat khau.\n\
			/stats - thong tin nhan vat.\n\
			/(pr) operty - tai san cua nhan vat.\n\
			/id - tim kiem mot nguoi choi.\n\
			/isafk - tim hieu thoi gian AFK cua nguoi choi.\n\
			/mm - menu nguoi choi.\n\
			/setspawn - thay doi vi tri xuat hien.\n\
			/helpme - hoi mot cau hoi.\n\
			/report - gui don khieu nai.\n\
			/request - yeu cau quan ly mot cai gi do.\n\
			/charity - tieu tien.\n\
			/admins - danh sach Quan tri vien.\n\
			/testers - danh sach network testers.\n\
			/tog - cai dat nhan vat. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Ky Thuat", mes, "Quay lai", "Dong");
	return 1;
}
CMD:mainhelp(playerid, params[])
{
	static const dlg[] = "{FFFFFF}\
    		/pay - chuyen tien.\n\
			/time - xem thoi gian.\n\
			/fill - do nhien lieu cho xe tai tram xang.\n\
			/buyfood - mua thuc an.\n\
			/address - tim dia chi cua ngoi nha.\n\
			(/inv) entory - tui do cua nhan vat /house /trunk /glove compartment.\n\
			/clothing - phu kien nhan vat.\n\
			/offclothes - coi quan ao\n\
			/mua - mo menu mua hang.\n\
			/licenses - xuat trinh the ID.\n\
			/coin - tung dong xu.\n\
			/dice - tung xuc xac.\n\
			/(d) rop (gun) - nem vu khi.\n\
			/(p) ickup (item) - nhat vu khi / vat pham.\n\
			/greet - de nghi bat tay.\n\
			/rentbb - thue bien quang cao.\n\
			/ad - gui mot quang cao.\n\
			/cad - quang cao cho cong ty.\n\
			/lastads - quang cao moi nhat.\n\
			/mask - deo / thao mat na.\n\
			/buyclothes - mua quan ao.\n\
			/(d) rop (money) - nem tien xuong dat.\n\
			/frisk - de nghi luc soat nguoi choi.\n\
			/coh - dinh tien vao tay.\n\
			/dmoney [money] - nem tien xuong san.\n\
			/sa - dung hanh dong.\n\
			/setstyle - thay doi Phong cach di bo, HUD, Phong cach chien dau, Noi chuyen.\n\
			/animlist - danh sach hanh dong.\n\
			/removecp - xoa the GPS.\n\
			/note - so tay.\n\
			/tickets - tien phat chua thanh toan.\n\
			(/gr) affity - tao graffiti. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Cac lenh pho bien", mes, "Quay lai", "Dong");
	return 1;
}

CMD:chathelp(playerid, params[])
{
    static const dlg[] = "{FFFFFF}\
						/ame - hanh dong (qua nguoi choi)\n\
						/me - hanh dong (trong tro chuyen)\n\
						/my - Tuong tu nhu /do, nhung o mot dinh dang khac (Vi du: 'Dien thoai cua Ausil_Ausil bi roi') (trong cuoc tro chuyen)\n\
						/do - hanh dong tu ngoi thu ba, mo ta ve su vat.\n\
						/pame - hien thi mo ta ve nhan vat cua ban hoac nhan vat khac trong cuoc tro chuyen.\n\
						/mypame - tao mot mieu ta ve nhan vat.\n\
						(/l) ocal - tro chuyen cuc bo.\n\
						(/s) hout - het to.\n\
						/low - noi nho.\n\
						(/w) hisper - noi thi tham voi mot nguoi choi cu the.\n\
						/b - tro chuyen OOC.\n\
						/ooc - tro chuyen OOC the gioi.\n\
						/pm - gui tin nhan rieng tu. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Tro chuyen", mes, "Quay lai", "Dong");
	return 1;
}

CMD:vehiclehelp(playerid, params[])
{
    static const dlg[] = "{FFFFFF}\
					(/v) ehicle - danh sach lenh phuong tien\n\
					/vmenu - menu de quan ly phuong tien cua ban\n\
					/vfa - menu de tuong tac nhanh voi xe\n\
					/attmenu - quan ly cac tap tin dinh kem tren xe cua ban\n\
					/mycars (/myv) - danh sach tat ca cac phuong tien cua ban\n\
					/register - dang ky xe\n\
					/unregister - xoa xe khoi so dang ky\n\
					(/en) gine - mo dong co\n\
					/lights - bat / tat den xe\n\
					/trunk - mo / dong cop xe\n\
					/hood - mo / dong mui xe\n\
					/setstation (/ss) - thay doi dai phat thanh\n\
					/(wi) ndow - mo / dong cua so xe\n\
					/alarmoff - tat bao thuc\n\
					/unimpound - nhan phuong tien tu cho giam giu\n\
					/delveh - loai bo cac phuong tien bi cuop\n\
					/vtickets - tien phat xe chua thanh toan\n\
					/stealradio - an trom dai\n\
					/dropkey - tha cac khoa trung lap ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Phuong tien", mes, "Quay lai", "Dong");
	return 1;
}

CMD:breakhelp(playerid, params[])
{
    static const dlg[] = "{FFFFFF}\
						AN TROM PHUONG TIEN:\n\
						{FF6347} (Xin luu y rang ban can phai co mot cong viec 'Trom cap o to'.\n\
						Dieu nay duoc thuc hien de han che tinh trang trom cap xe.) {FFFFFF}\n\n\
						/delivercar - thao do cac bo phan co gia tri cua mot chiec xe bi danh cap.\n\
						/dropoff - thoat khoi phuong tien.\n\
						/leavemission - dat lai nhiem vu.\n\n\
						/vbl (n) on ao - hack xe tho bao.\n\
						/vbl (q) yen tinh - hack xe im lang\n\n\
						(/en) gine - bat dau cong cu hack\n\
						(/uns) cramble - de giai ma mot tu (khi cong cu bi tan cong)\n\n\
						/stealradio - an trom dai\n\n\
						AN TROM MOT NGOI NHA:\n\
						(/hbreak) khoa hoac /hbl - pha nha ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro An trom", mes, "Quay lai", "Dong");
	return 1;
}



CMD:radiohelp(playerid, params[])
{
    static const dlg[] = "{FFFFFF}Goi y: Ban co the mua bo dam tai tap hoa 24-7!\n\n\
				/r - noi chuyen bo dam.\n\
				/rr - noi chuyen tren radio vao vi tri.\n\
				/(rl) ow - noi nho vao radio.\n\
				/(rrl) ow - noi vao radio bang nua loi thi tham vao vi tri.\n\
				/auth - dang nhap vao kenh song radio.\n\
				/(ch) annel set - thay doi kenh radio.\n\
				/(ch) annel rent - thay doi kenh radio.\n\
				/setslot - thay doi vi tri radio.\n\
				/(ch) annel leave - roi khoi song radio.\n\
				/(ch) annel sell - ban lan song radio. (50 phan tram se tro lai)\n\
				/newauth - thay doi mat khau kenh.\n\
				/kickoffradio - truc xuat tu kenh.\n\
				/radiomembers - thanh vien cua kenh. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Radio ", mes, "Quay lai", "Dong");
	return 1;
}

CMD:fishhelp(playerid, params[])
{
	static const dlg[] = "{FFFFFF}Goi y: Ban co the ban 300LBs ca.\n\n\
					/myfish - xem so luong ca bat duoc.\n\
					/unloadfish - ban ca kiem tien.\n\
					/fish - nem can cau.\n\
					/stopfish - dung cau ca.\n\
					/fishzone - hien thi cac diem cau ca. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Cau ca", mes, "Quay lai", "Dong");
	return 1;
}

CMD:bankhelp(playerid, params[])
{
	static const dlg[] = "{FFFFFF}\
			/atm - mo menu ATM.\n\
			/balance - kiem tra so du tai khoan.\n\
			/withdraw - rut tien tu tai khoan.\n\
			/deposit - gui tien tu tai khoan.\n\
			/transfer - chuyen tien tu tai khoan.\n\
			/paycheck - rut tien tu tien luong.\n\
			/savings - gui tien vao tai khoan tiet kiem.\n\
			/tickets - thanh toan tien phat. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Ngan Hang", mes, "Quay lai", "Dong");
	return 1;
}

CMD:cellhelp(playerid, params[])
{
    static const dlg[] = "{FFFFFF}Goi y: Ban co the mua dien thoai tai tap hoa 24-7.\n\n\
				/phone - hien thi / an giao dien dien thoai.\n\
				/pc - hien thi con tro chuot.\n\
				/call - goi so duoc chi dinh.\n\
				/loudspeaker - bat / tat loa.\n\
				/low - noi nho vao dien thoai.\n\
				/(p) ickup - nhac dien thoai len. (tra loi dien thoai di)\n\
				/(h) angup - treo len. (ket thuc cuoc goi)\n\
				/sms - viet tin nhan.\n\
				/togphone - bat / tat dien thoai.\n\
				/dropcell - vut dien thoai.\n\
				/showcontact - hien thi mot lien he cu the cho nguoi choi.\n\
				/showcontacts - hien thi tat ca dia chi lien he cho nguoi choi khac. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Dien Thoai", mes, "Quay lai", "Dong");
	return 1;
}

CMD:househelp(playerid, params[])
{
    static const dlg[] = "{FFFFFF} \
			/h buy - mua mot ngoi nha\n\
			/hmenu - menu ngoi nha.\n\
			/lock - mo / dong cua nha.\n\
			/h backdoor - dat cua sau\n\
			/rentroom - thue mot ngoi nha.\n\
			/door - mo mot canh cua dong (/lock - khoa bang chia khoa).\n\
			/dram - pha mot canh cua.\n\
			/furniture - quan ly noi that.\n\
			/grantbuild - cho / lay di kha nang sap xep do dac chung cho nguoi choi.\n\
			/clothes - tu quan ao o nha.\n\
			/cache - thay doi vi tri cua bo nho cache.\n\
			/h upgrade - cai tien nha\n\
			/h withdraw and /h deposit - nhan / gui tien.\n\
			/h sellto - ban nha cho ai do.\n\
			/h sell - ban nha cho nha nuoc. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Nha O", mes, "Quay lai", "Dong");
	return 1;
}

CMD:bizhelp(playerid, params[])
{
	static const dlg[] = "{FFFFFF}\
			/biz buy - mua mot doanh nghiep.\n\
			/biz sell - mot doanh nghiep.\n\
			/biz upgrade - cai tien doanh nghiep.\n\
			/biz info - thong tin ve doanh nghiep.\n\
			/lock - mo / dong doanh nghiep.\n\
			/biz fee - an dinh gia nhap doanh nghiep. (Neu tram xang, chi phi nhien lieu)\n\
			/biz name - thay doi ten doanh n ghiep.\n\
			/biz text - thay doi van ban dang nhap doanh nghiep.\n\
			/biz withdraw - rut tien tu tai khoan doanh nghiep.\n\
			/biz deposit - gui tien vao tai khoan doanh nghiep.\n\
			/biz buyprod - dat hang cho doanh nghiep.\n\
			/biz hire - de nghi mot nguoi choi lam viec trong mot doanh nghiep.\n\
			/biz fire - sa thai mot nguoi choi lam viec trong mot doanh nghiep. ";

	new mes[sizeof(dlg)];
	format(mes, sizeof(mes), dlg);
	
	Dialog_Show(playerid, CmdServer2, DIALOG_STYLE_MSGBOX, "Ho tro Doanh nghiep", mes, "Quay lai", "Dong");
	return 1;
}

CMD:factionhelp(playerid, params[])
{
	if (PlayerInfo[playerid][pFaction] == 0)
		return SCM(playerid, -1, "Ban phai o trong mot to chuc. ");

	SCM(playerid, COLOR_GREEN,"|___________________ Cac lenh cho To chuc ___________________|");

	if (isLeader(playerid))
	{
		if (Factions[PlayerInfo[playerid][pFaction]][fType] == FACTION_GANG || Factions[PlayerInfo[playerid][pFaction]][fType] == FACTION_MAFIA)
			SCM(playerid, COLOR_YELLOWG,"Lenh cho Lanh dao: /editrights /invite /uninvite /giverank /fchat /ranks /towcars /editspawn /editrankname /factionjob");
		else
		    SCM(playerid, COLOR_YELLOWG,"Lenh cho Lanh dao: /editrights /invite /uninvite /giverank /fchat /ranks /towcars /editspawn /editrankname /changebadges");
	}
	
	if (IsPlayerFactionPolice(playerid))
	{
		SCM(playerid, COLOR_WHITE, "[SHERIFF] /cuff /uncuff (/m)egaphone /meg /mdc /(gov)ernment /showbadge");
		SCM(playerid, COLOR_WHITE, "[SHERIFF] (/r)adio (/r 10-27) (/r 10-28) /rlow /bort /(b)ort(l)ist /arrest");
		SCM(playerid, COLOR_WHITE, "[SHERIFF] /detain /revoke /apb /prison /toll /(sp)ike /cctv /exitcctv /tow /rope");
		SCM(playerid, COLOR_WHITE, "[SHERIFF] /impound /callsign /color /open(/gate) /authswat /siren /checkplate ");
		SCM(playerid, COLOR_WHITE, "[SHERIFF] /ram /dram /trace /pull /myrights /setplate /ticket /(v)ehicle(ticket) ");
		SCM(playerid, COLOR_WHITE, "[SHERIFF] /checkfines /checkvfines /ane /radar /carfix /members /zond /flashbang /taser");
		SCM(playerid, COLOR_WHITE, "[SHERIFF] /(f)action(a)ttach /chase /frisktrunk /friskgb /friskprop /frisk /carsign /street /speedcam");
	}
    else if (IsPlayerFactionCity(playerid)) 
	{
		SCM(playerid, COLOR_WHITE,"[CITY] /flist /(d)epartments /(f)action /showbadge /(r)adio /rlow /(m)egaphone /(gov)ernment");
		SCM(playerid, COLOR_WHITE,"[CITY] /bort /(b)ort(l)ist /cuff /uncuff /siren");
	}
	else if (IsPlayerFactionMedic(playerid))
	{
		SCM(playerid, COLOR_WHITE,"[FIRE /flist (/d)epartments (/f)action /showbadge (/r)adio /rlow /bort /(b)ort(l)ist /stretcher");
		SCM(playerid, COLOR_WHITE,"[FIRE] /heal /pull /operation /hpc /siren (/m)egaphone (/gov)ernment /prescribe /therapy /(f)action(a)ttach");
	}
	else if (IsPlayerFactionFire(playerid))
	{
		SCM(playerid, COLOR_WHITE,"[EMS] /flist (/d)epartments (/f)action /showbadge (/r)adio /rlow /bort /(b)ort(l)ist /stretcher");
		SCM(playerid, COLOR_WHITE,"[EMS] /heal /pull /operation /hpc /siren (/m)egaphone (/gov)ernment /(f)action(a)ttach /choke");
	}
	else if (IsPlayerFactionDocs(playerid))
	{
		SCM(playerid, COLOR_WHITE,"[DOC] /flist /(d)epartments /(f)action /showbadge /(r)adio /rlow /(m)egaphone /(gov)ernment");
		SCM(playerid, COLOR_WHITE,"[DOC] /siren /detain /bort /(b)ort(l)ist /cuff /uncuff /frisk /taser /prisonlist /prison /free /isolate");
	}
	else if (IsPlayerFactionNews(playerid))
	{
		SCM(playerid, COLOR_WHITE,"[SAN] /flist /(f)action /news /exitnews /interview /exitinterview");
	}
	else if(IsPlayerFactionMech(playerid))
	{
		SCM(playerid, COLOR_WHITE,"[Mech] /refill /repair /paintcar /attach");
	}
	return 1;
}

CMD:help(playerid, params[])
{
    Dialog_Show(playerid, CmdServer, DIALOG_STYLE_LIST, "Cac lenh cua may chu", "\
	1. Cac lenh ky thuat\n\
	2. Cac lenh chung\n\
	3. Cac lenh tro chuyen\n\
	4. Lenh cho to chuc\n\
	5. Lenh cho nha o\n\
	6. Lenh cho doanh nghiep\n\
	7. Lenh cho phuong tien\n\
	8. Lenh cho ngan hang\n\
	9. Lenh cho dien thoai\n\
	10. Lenh cho vu khi\n\
	11. Lenh cho ma tuy\n\
	12. Lenh cho cong viec\n\
	13. Lenh cho cau ca\n\
	14. Lenh cho bo dam\n\
	15. Lenh cho an trom ",
	"Chon", "Quay lai");
	return 1;
}
