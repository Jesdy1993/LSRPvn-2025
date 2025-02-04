stock LoadTextUpJob() {
	Create3DTextLabel("Khu vuc Pizza\n/pizza 'lamviec' de bat dau lay xe lam viec\n/pizza 'lay' de lay banh pizza", COLOR_WHITE, 2098.5432,-1800.6925,13.3889, 10, 0, 0);
	Create3DTextLabel("Khu vuc Trucker\n/truck 'lamviec' de bat dau lay xe lam viec", COLOR_WHITE, 2507.7554,-2120.0732,13.5469, 10, 0, 0);
	CreateDynamicPickup(19132, 23, 2098.5432,-1800.6925,13.3889);
	CreateDynamicPickup(19132, 23, 2507.7554,-2120.0732,13.5469);
    return 1;
}