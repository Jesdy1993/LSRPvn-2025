Dialog:BuyStandFood(playerid, response, listitem, inputtext[]) //tåntî
{
	if (!response)	return 1;

	new price_food[4] = {PRICE_BURGER, PRICE_PIZZA, PRICE_CHICKEN, PRICE_HOTDOG}, name_food[4][8] = {"burger", "pizza", "chicken", "hot-dog"};

	if (GetCash(playerid) < price_food[listitem])				return SendNotCash(playerid);
	if (GiveInvItem(playerid, INV_BURGER + listitem, 1) == -1)	return SendErrorMessage(playerid, "Tui do da day.");

	SendSyntaxMessage(playerid, "Ban da mua %s voi gia $%i.", name_food[listitem], price_food[listitem]);
	GiveCash(playerid, -price_food[listitem]);
	return 1;
}