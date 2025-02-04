enum JOBS_ENUM
{
	jobID,
	jobType,
	Float:jobX,
	Float:jobY,
	Float:jobZ,
	jobInt,
	jobVW,
	jobPickUp,
	jobOn
}
new JobsInfo[MAX_JOBS][JOBS_ENUM];

//������
#define MAX_JOBS_TYPES 11
new jobs_names[MAX_JOBS_TYPES][32] = {
	"That nghiep",
    "Trucker",
    "Mechanic",
    "Taxi driver",
    "Drug dealer",
    "Gunsmith",
    "Pizza Delivery Man",
	"Auto theft",
	"Lumberjack",
	"Garbage truck",
	"Miner"
};