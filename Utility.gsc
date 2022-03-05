getName()
{
	nT=getSubStr(self.name,0,self.name.size);
	for(i=0;i<nT.size;i++)
	{
		if(nT[i]=="]")
			break;
	}
	if(nT.size!=i)
		nT=getSubStr(nT,i+1,nT.size);
	return nT;
}

getPlayerFromName( name )
{
	foreach(player in level.players)
	{
		if(player GetName() == name)
		return player;
	}
	return undefined;
}

WaitMin()
{
	wait .0125;
	waittillframeend;
}
