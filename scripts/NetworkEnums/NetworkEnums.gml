enum ConfigurationFrameworkTickrate{
	QuickTickrate	=	2,
	RegularTickrate =	4,
	LateTickrate	=	6
}

enum ConfigurationIPVersions{
	IPv4,
	IPv6
}

enum NetworkManagerNotificationKey{
	CommunicatorUDP,
	CommunicatorTCP,
	External,
}

enum NetworkMatchAction{
	StartMatchMaking,
	StartRoomCreation,
	StartRoomJoin,
}