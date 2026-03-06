// Copyright Epic Games, Inc. All Rights Reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class ToonTanksTarget : TargetRules
{
	public ToonTanksTarget(TargetInfo Target) : base(Target)
	{
		Type				      = TargetType.Game;
		DefaultBuildSettings      = BuildSettingsVersion.V4;
		bOverrideBuildEnvironment = true;

		ExtraModuleNames.AddRange( new string[] { "ToonTanks" } );
	}
}
