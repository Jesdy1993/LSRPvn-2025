public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid) 
{
    if(pTemp[playerid][pCallStatus] == 2)
    {
        if (keyid == 0x5A && callstream[playerid]) SvAttachSpeakerToStream(callstream[playerid], playerid);
    }
    else
    {
        if (keyid == 0x5A && lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);
    }
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if(pTemp[playerid][pCallStatus] == 2)
    {
        if (keyid == 0x5A && callstream[playerid]) SvDetachSpeakerFromStream(callstream[playerid], playerid);
    }
    else
    {
        if (keyid == 0x5A && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
    }
}

Voice_OnPlayerConnect(playerid)
{
    if ((lstream[playerid] = SvCreateDLStreamAtPlayer(20.0, SV_INFINITY, playerid, 0xff0000ff, "")))
    {
		SendSyntaxMessage(playerid, "Neu micro cua ban phat ra am thanh khong tot, micro cua ban se tu dong bi tat tieng.");
		SendSyntaxMessage(playerid, "Ban co the nhan Z de giao tiep voi nhung nguoi choi khac.");
        SvAddKey(playerid, 0x5A);
    }
    return 1;
}

Voice_OnPlayerDisconnect(playerid)
{
    if(lstream[playerid])
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }
    return 1;
}