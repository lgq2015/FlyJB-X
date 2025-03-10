#import "../Headers/FJPattern.h"

@implementation FJPattern
+ (instancetype)sharedInstance {
    static FJPattern* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FJPattern alloc] init];
    });

    return sharedInstance;
}

-(BOOL) isCrashAppWithSubstitutor: (NSString*) bundleID
{
	//롯데면세점, KB리브, 유플패스, 리브메이트, KB Pay
	NSArray *ConflictApps = [NSArray arrayWithObjects:
	                                @"com.lotte.lotteDfs",
	                                @"com.kbstar.liivbank",
	                                @"com.lguplus.auth.ios",
	                                @"com.kbcard.kat.liivmate",
	                                @"com.kbcard.cxh.appcard",
	                                nil
	                               ];
	for (NSString *app in ConflictApps) {
		if ([bundleID isEqualToString:app])
			return YES;
	}
	return NO;
}

-(BOOL) isSandBoxPathRestricted: (NSString*) path
{
	if ([path hasPrefix:@"/var/containers"]
	    || [path hasPrefix:@"/var/mobile"]
	    || [path hasPrefix:@"/private/var/containers"]
	    || [path hasPrefix:@"/private/var/mobile"])
	{
		return NO;
	}
	return YES;
}

-(BOOL) isURLRestricted: (NSURL *) url {
	NSArray *jailbreakURLSchemes = [NSArray arrayWithObjects:
	                                @"cydia",
	                                @"sileo",
	                                @"zbra",
	                                @"undecimus",
	                                @"ifile",
	                                @"filza",
	                                @"activator",
	                                nil
	                               ];

	for (NSString *jbURL in jailbreakURLSchemes) {
		if ([[url absoluteString] hasPrefix:jbURL])
			return YES;
	}
	return NO;
}

-(NSArray *)jailbreakFiles {
  return [NSArray arrayWithObjects:
                             @"/.bootstrapped_electra",
                             @"/.cydia_no_stash",
                             @"/.installed_home_depot",
                             @"/.installed_unc0ver",
                             @"//bin/bash",
                             @"//bin/sh",
                             @"//etc/apt/",
                             @"//etc/ssh/sshd_config",
                             @"//Library/MobileSubstrate/MobileSubstrate.dylib",
                             @"//System/Library/LaunchDaemons/com.saurik.Cy@dia.Startup.plist",
                             @"//Systetem/Library/LaunchDaemons/com.ikey.bbot.plist",
                             @"//usr/libexec/ssh-keysign",
                             @"//var/cache/apt/",
                             @"//var/lib/apt/",
                             @"//var/lib/cydia/",
                             @"//var/log/syslog",
                             @"/Applications/ADManager.app/ADManager",
                             @"/Applications/Anemone.app",
                             @"/Applications/Backgrounder.app",
                             @"/Applications/biteSMS.app",
                             @"/Applications/blackra1n.app",
                             @"/Applications/Categories.app",
                             @"/Applications/Cydia.app",
                             @"/Applications/Cydia.app/",
                             @"/Applications/Cydia.app/Cydia",
                             @"/Applications/FakeCarrier.app",
                             @"/Applications/Flex.app",
                             @"/Applications/Flex.app/Flex",
                             @"/Applications/Icy.app",
                             @"/Applications/iFile.app",
                             @"/Applications/Installous.app",
                             @"/Applications/IntelliScreen.app",
                             @"/Applications/iProtect.app",
                             @"/Applications/Kirikae.app",
                             @"/Applications/Lockdown.app",
                             @"/Applications/MxTube.app",
                             @"/Applications/RockApp.app",
                             @"/Applications/SafeMode.app",
                             @"/Applications/SBSetting.app",
                             @"/Applications/SBSettings.app",
                             @"/Applications/SBSetttings.app",
                             @"/Applications/Snoop-it Config.app",
                             @"/Applications/Snoop-it Config.app/Info.plist",
                             @"/Applications/Snoop-it Config.app/Snoop-it Config",
                             @"/Applications/Terminal.app",
                             @"/Applications/WinterBoard.app",
                             @"/bin/bash",
                             @"/bin/bunzip2",
                             @"/bin/bzip2",
                             @"/bin/cat",
                             @"/bin/chgrp",
                             @"/bin/chmod",
                             @"/bin/chown",
                             @"/bin/cp",
                             @"/bin/gnuzip",
                             @"/bin/grep",
                             @"/bin/gunzip",
                             @"/bin/gzip",
                             @"/bin/kill",
                             @"/bin/ln",
                             @"/bin/ls",
                             @"/bin/mkdir",
                             @"/bin/mv",
                             @"/bin/ps",
                             @"/bin/sed",
                             @"/bin/sh",
                             @"/bin/su",
                             @"/bin/tar",
                             @"/binpack",
                             @"/binpack/etc/alternatives/README",
                             @"/binpack/etc/apt/sources.list.d/cydia.list",
                             @"/binpack/etc/apt/sources.list.d/saurik.list",
                             @"/binpack/Library/LaunchDaemons/dropbear.plist",
                             @"/binpack/loader.dmg",
                             @"/boot/",
                             @"/bootstrap",
                             @"/bootstrap/Library/SBInject/Activator.dylib",
                             @"/chimera",
                             @"/Cydia.app",
                             @"/electra",
                             @"/etc/apt",
                             @"/etc/apt/",
                             @"/etc/apt/sources.list.d/cydia.list",
                             @"/etc/apt/sources.list.d/electra.list",
                             @"/etc/apt/sources.list.d/saurik.list",
                             @"/etc/apt/sources.list.d/sileo.sources",
                             @"/etc/dropbear",
                             @"/etc/master.passwd",
                             @"/etc/pam.d/passwd",
                             @"/etc/pam.d/sshd",
                             @"/etc/pam.d/su",
                             @"/etc/pam.d/sudo",
                             @"/etc/profile",
                             @"/etc/profile.d/terminal.sh",
                             @"/etc/ssh/sshd_config",
                             @"/jb",
                             @"/Library/Application Support/Choicy.bundle",
                             @"/Library/Application Support/Flex",
                             @"/Library/dpkg/info/com.inoahdev.launchinsafemode.list",
                             @"/Library/dpkg/info/com.inoahdev.launchinsafemode.md5sums",
                             @"/Library/Frameworks/CydiaSubstrate.framework",
                             @"/Library/LaunchDaemons/0.reload.plist",
                             @"/Library/LaunchDaemons/com.openssh.sshd.plist",
                             @"/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                             @"/Library/LaunchDaemons/dropbear.plist",
                             @"/Library/LaunchDaemons/re.frida.server.plist",
                             @"/Library/MobileSubstrate",
                             @"/Library/MobileSubstrate/",
                             @"/Library/MobileSubstrate/DynamicLibraries",
                             @"/Library/MobileSubstrate/DynamicLibraries/0Shadow.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/ FlyJB.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/!ABypass.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/",
                             @"/Library/MobileSubstrate/DynamicLibraries/Activator.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/CepheiSpringBoard.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/ChoicySB.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/Flex.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/Flex.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/FlyJB.dylb",
                             @"/Library/MobileSubstrate/DynamicLibraries/FlyJB.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/FlyJB.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/HideJB.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/HideJB.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/KeyboardPlus.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/LibertySB.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/LibertySB.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/Officer.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/PalBreakSB.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/patcyh.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/patcyh.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/SBSettings.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/SBSettings.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/SnoopiTweak.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/SnoopiTweak.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/tsProtector.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/tsProtector.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/xCon.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/xCon.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/zzzzLiberty.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/|tsProtector.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/|tsProtector.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/~tsProtector.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/~tsProtector.plist",
                             @"/Library/MobileSubstrate/DynamicLibraries/~~tsProtector 8.dylib",
                             @"/Library/MobileSubstrate/DynamicLibraries/~~tsProtector.dylib",
                             @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                             @"/Library/PreferenceBundles/FlyJBPrefs.bundle",
                             @"/Library/PreferenceBundles/flyjbprefs.bundle",
                             @"/Library/PreferenceBundles/FlyJBPrefs.bundle/FlyJBPrefs",
                             @"/Library/PreferenceBundles/flyjbprefs.bundle/flyjbprefs",
                             @"/Library/PreferenceBundles/HideJBPrefs.bundle",
                             @"/Library/PreferenceBundles/JailProtectSettings.bundle",
                             @"/Library/PreferenceBundles/LaunchInSafeMode.bundle",
                             @"/Library/PreferenceBundles/LibertyPref.bundle",
                             @"/Library/PreferenceBundles/ShadowPreferences.bundle/ShadowPreferences",
                             @"/Library/PreferenceBundles/tsProtectorPFBSettings",
                             @"/Library/PreferenceBundles/tsProtectorPFBSettings.bundle/Info.plis",
                             @"/Library/PreferenceBundles/tsProtectorPFBSettings.bundle/Info.plist",
                             @"/Library/PreferenceBundles/tsProtectorPSettings",
                             @"/Library/PreferenceBundles/tsProtectorPSettings.bundle/Info.plist",
                             @"/Library/PreferenceBundles/tsProtectorSettings",
                             @"/Library/PreferenceBundles/tsProtectorSettings.bundle",
                             @"/Library/PreferenceBundles/tsProtectorSettings.bundle/en.proj/tsProtectorSettings.strings",
                             @"/Library/PreferenceBundles/tsProtectorSettings.bundle/ko.proj/tsProtectorSettings.strings",
                             @"/Library/PreferenceBundles/tsProtectorSettings.bundle/tsProtector.png",
                             @"/Library/PreferenceBundles/tsProtectorSettings.bundle/tsProtector@2x.png",
                             @"/Library/PreferenceBundles/tsProtectorSettings.bundle/tsProtectorSettings",
                             @"/Library/PreferenceLoader/Preferences/FlyJBPrefs.plist",
                             @"/Library/PreferenceLoader/Preferences/flyjbprefs.plist",
                             @"/Library/PreferenceLoader/Preferences/HideJBPrefs.plist",
                             @"/Library/PreferenceLoader/Preferences/JailProtect.plist",
                             @"/Library/PreferenceLoader/Preferences/LaunchInSafeMode.plist",
                             @"/Library/PreferenceLoader/Preferences/LibertyPref.plist",
                             @"/Library/PreferenceLoader/Preferences/tsProtectorPSettings.plist",
                             @"/Library/PreferenceLoader/Preferences/tsProtectorSettings.plist",
                             @"/Library/Themes",
                             @"/Library/TweakInject/Flex.dylib",
                             @"/Library/TweakInject/JailProtect.dylib",
                             @"/meridian",
                             @"/pangueaxe",
                             @"/private/b_o",
                             @"/private/etc/apt/sources.list.d/cydia.list",
                             @"/private/etc/apt/sources.list.d/saurik.list",
                             @"/private/etc/apt/trusted.gpg.d/bigboss.gpg",
                             @"/private/etc/apt/trusted.gpg.d/modmyi.gpg",
                             @"/private/etc/apt/trusted.gpg.d/saurik.gpg",
                             @"/private/etc/apt/trusted.gpg.d/zodttd.gpg",
                             @"/private/etc/profile.d/terminal.sh",
                             @"/private/etc/rc.d/substrate",
                             @"/private/JailbreakTest.txt",
                             @"/private/Liapp",
                             @"/private/var/checkra1n.dmg",
                             @"/private/var/db/stash/_.wOruIO/include/substrate.h",
                             @"/private/var/lib/apt",
                             @"/private/var/lib/apt/",
                             @"/private/var/lib/apt/Applications/Icy.app",
                             @"/private/var/lib/cydia",
                             @"/private/var/lib/cydia/",
                             @"/private/var/lib/dpkg/info/com.hackyouriphone.flex3beta.list",
                             @"/private/var/lib/dpkg/info/com.hackyouriphone.flex.list",
                             @"/private/var/lib/dpkg/info/com.hackyouriphone.flyjb.list",
                             @"/private/var/lib/dpkg/info/com.hackyouriphone.flyjb.md5sums",
                             @"/private/var/lib/dpkg/info/com.hackyouriphone.flyjb.postinst",
                             @"/private/var/lib/dpkg/info/com.hackyouriphone.liberty.list",
                             @"/private/var/lib/dpkg/info/com.hackyouriphone.liberty.md5sums",
                             @"/private/var/lib/dpkg/info/com.johncoates.flex3.list",
                             @"/private/var/lib/dpkg/info/com.johncoates.flex.list",
                             @"/private/var/lib/dpkg/info/com.n00neimp0rtant.xcon.list",
                             @"/private/var/lib/dpkg/info/com.saurik.substrate.safemode.list",
                             @"/private/var/lib/dpkg/info/com.xsellize.tsprotectorp.list",
                             @"/private/var/lib/dpkg/info/cydia-sources.list",
                             @"/private/var/lib/dpkg/info/cydia.list",
                             @"/private/var/lib/dpkg/info/de.nesolabs.snoopit.list",
                             @"/private/var/lib/dpkg/info/de.nesolabs.snoopit.postinst",
                             @"/private/var/lib/dpkg/info/de.nesolabs.snoopit.postrm",
                             @"/private/var/lib/dpkg/info/de.nesolabs.snoopit.preinst",
                             @"/private/var/lib/dpkg/info/kr.typostudio.tsprotector8.list",
                             @"/private/var/lib/dpkg/info/kr.typostudio.tsprotector8.postinst",
                             @"/private/var/lib/dpkg/info/kr.typostudio.tsprotector8.preinst",
                             @"/private/var/lib/dpkg/info/kr.xsflre.flyjb.list",
                             @"/private/var/lib/dpkg/info/kr.xsflre.flyjb.md5sums",
                             @"/private/var/lib/dpkg/info/kr.xsflre.flyjb.postinst",
                             @"/private/var/lib/dpkg/info/kr.xsflre.flyjb.prerm",
                             @"/private/var/lib/dpkg/info/mobilesubstrate.extrainst_",
                             @"/private/var/lib/dpkg/info/mobilesubstrate.list",
                             @"/private/var/lib/dpkg/info/mobilesubstrate.postrm",
                             @"/private/var/lib/dpkg/info/repo.biteyourapple.net.officer.list",
                             @"/private/var/lib/xcon",
                             @"/private/var/log/apt/term.log",
                             @"/private/var/mobile/Documents/Flex",
                             @"/private/var/mobile/Library/Application Support/Flex3",
                             @"/private/var/mobile/Library/ConfigurationProfiles/PublicInfo/Flex3Patches.plist",
                             @"/private/var/mobile/Library/Flex3",
                             @"/private/var/mobile/Library/Flex3/Flex.app/Flex",
                             @"/private/var/mobile/Library/Pangu/package.plist",
                             @"/private/var/mobile/Library/Preferences/com.johncoates.Flex.plist",
                             @"/private/var/mobile/Library/Preferences/com.ryleyangus.liberty.plist",
                             @"/private/var/mobile/Library/Preferences/com.saurik.Cydia.plist",
                             @"/private/var/mobile/Library/Preferences/com.skylerk99.nosub.plist",
                             @"/private/var/mobile/Library/Preferences/kr.typostudio.tsprotector.plist",
                             @"/private/var/mobile/Library/Preferences/kr.xsf1re.flyjb.plist",
                             @"/private/var/mobile/Library/Preferences/kr.xsflre.flyjb.plist",
                             @"/private/var/mobile/Library/SBSettings/",
                             @"/private/var/mobile/Library/SBSettings/Themes",
                             @"/private/var/mobileLibrary/SBSettingsThemes/",
                             @"/private/var/root/Media/Cydia",
                             @"/private/var/sta",
                             @"/private/var/stash",
                             @"/private/var/stash/",
                             @"/private/var/tmp/cydia.log",
                             @"/sbin/mount",
                             @"/sur/bin/xargs",
                             @"/System/Library/LaunchDaemons/com.bigboss.sbsettingsd.plist",
                             @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                             @"/System/Library/LaunchDaemons/com.rockyourphone.daily.plist",
                             @"/System/Library/LaunchDaemons/com.saurik.Cy@dia.Startup.plist",
                             @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                             @"/System/Library/LaunchDaemons/io.pangu.axe.untether.plist",
                             @"/System/Library/PreferenceBundles/CydiaSettings.bundle",
                             @"/Systetem/Library/LaunchDaemons/com.ikey.bbot.plist",
                             @"/User/Applications/",
                             @"/user/bin/recache",
                             @"/User/Documents/Flex",
                             @"/user/lib/libsubstrate.dylib",
                             @"/User/Library/SBSettings",
                             @"/usr/bin/ADMHelper",
                             @"/usr/bin/changerootfs",
                             @"/usr/bin/class-dump",
                             @"/usr/bin/cycript",
                             @"/usr/bin/diff",
                             @"/usr/bin/gdb",
                             @"/usr/bin/hostinfo",
                             @"/usr/bin/killall",
                             @"/usr/bin/passwd",
                             @"/usr/bin/recache",
                             @"/usr/bin/sbsettingsd",
                             @"/usr/bin/ssh",
                             @"/usr/bin/sshd",
                             @"/usr/bin/tar",
                             @"/usr/bin/which",
                             @"/usr/bin/xargs",
                             @"/usr/binsshd",
                             @"/usr/lib/libcycript-sim.dylib",
                             @"/usr/lib/libcycript.dylib",
                             @"/usr/lib/Liberty.dylib",
                             @"/usr/lib/libjailbreak.dylib",
                             @"/usr/lib/librocketbootstrap.dylib",
                             @"/usr/lib/libsubstitute.0.dylib",
                             @"/usr/lib/libsubstitute.dylib",
                             @"/usr/lib/libsubstrate.0.dylib",
                             @"/usr/lib/libsubstrate.dylib",
                             @"/usr/lib/PalBreak.dylib",
                             @"/usr/lib/SBInject",
                             @"/usr/lib/SBInject.dylib",
                             @"/usr/lib/substitute-inserter.dylib",
                             @"/usr/lib/SubstrateInjector.dylib",
                             @"/usr/lib/TsProtePass.dylib",
                             @"/usr/lib/tsProtePass.dylib",
                             @"/usr/lib/TweakInject",
                             @"/usr/lib/TweakInject.dylib",
                             @"/usr/lib/TweakInject/SnoopiTweak.dylib",
                             @"/usr/lib/TweakInject/SnoopiTweak.plist",
                             @"/usr/lib/TweakInjectMapsCheck.dylib",
                             @"/usr/libexec/cydia",
                             @"/usr/libexec/cydia/",
                             @"/usr/libexec/cydia/asuser",
                             @"/usr/libexec/cydia/cfversion",
                             @"/usr/libexec/cydia/cydo",
                             @"/usr/libexec/cydia/du",
                             @"/usr/libexec/cydia/finish.sh",
                             @"/usr/libexec/cydia/firmware.sh",
                             @"/usr/libexec/cydia/free.sh",
                             @"/usr/libexec/cydia/move.sh",
                             @"/usr/libexec/cydia/setnsfpn",
                             @"/usr/libexec/cydia/startup",
                             @"/usr/libexec/sftp-server",
                             @"/usr/libexec/ssh-keysign",
                             @"/usr/libexec/substitute",
                             @"/usr/libexec/substitute-reload",
                             @"/usr/libexec/substituted",
                             @"/usr/libexec/substrate",
                             @"/usr/local/bin/wget",
                             @"/usr/sbin/chown",
                             @"/usr/sbin/frida-server",
                             @"/usr/sbin/sshd",
                             @"/usr/sbinsshd",
                             @"/usr/share/bigboss/icons/bigboss.png",
                             @"/usr/share/bigboss/icons/planetiphones.png",
                             @"/usr/share/bigboss/icons/touchrev.png",
                             @"/usr/share/entitlements/inject.xml",
                             @"/usr/share/substitute/sigcert.p12",
                             @"/usr/share/terminfo",
                             @"/var/cache/apt",
                             @"/var/cache/apt/",
                             @"/var/containers/Bundle/.installed_rootlessJB3",
                             @"/var/lib/apt",
                             @"/var/lib/apt/",
                             @"/var/lib/cydia",
                             @"/var/lib/cydia/",
                             @"/var/lib/dpkg/info/cydia-sources.list",
                             @"/var/lib/dpkg/info/cydia.list",
                             @"/var/lib/undecimus/apt",
                             @"/var/lib/xcon",
                             @"/var/libexec/filza/Filza",
                             @"/var/log/apt",
                             @"/var/log/syslog",
                             @"/var/mobile/Library/.sbinjectSafeMode",
                             @"/var/mobile/Library/Caches/com.apple.mobile.installation.plist",
                             @"/var/mobile/Library/Caches/com.saurik.Cydia",
                             @"/var/mobile/Library/Preferences/com.julioverne.jailprotect.plist",
                             @"/var/mobile/Library/Preferences/com.opa334.choicyprefs.plist",
                             @"/var/mobile/Library/Preferences/com.ryleyangus.libertylite.plist",
                             @"/var/mobile/Library/Preferences/com.saurik.Cydia.plist",
                             @"/var/mobile/Library/Preferences/jp.akusio.kernbypass.plist",
                             @"/var/mobile/Library/Preferences/kr.typostudio.tsprotector.plist",
                             @"/var/mobile/Library/Preferences/Snoop-it",
                             @"/var/mobile/Library/SBSettings",
                             @"/var/mobile/Library/SBSettings/Themes",
                             @"/var/root/media/cydia",
                             @"/var/stash",
                             @"/var/stash/Library/Ringtones",
                             @"/var/stash/Library/Wallpaper",
                             @"/var/stash/usr/arm-apple-darwin9",
                             @"/var/stash/usr/include",
                             @"/var/stash/usr/libexec",
                             @"/var/stash/usr/share",
                             @"/var/tmp/cydia.log",
                             nil
                            ];
}

-(BOOL) isPathRestrictedForSymlink: (NSString*) path {
	NSArray *jailbreakFiles = [[FJPattern sharedInstance] jailbreakFiles];
	for (NSString *jbFile in jailbreakFiles) {
		if ([path hasSuffix:jbFile]) {
			return YES;
		}
	}
	return NO;
}


-(BOOL) isPathRestricted: (NSString*) path {

	if([path hasPrefix:@"/tmp"] || [path hasPrefix:@"/var/tmp"])
		return YES;

	NSArray *jailbreakFiles = [[FJPattern sharedInstance] jailbreakFiles];

	for (NSString *jbFile in jailbreakFiles) {
		if ([path isEqualToString:jbFile]) {
			//NSLog(@"[FlyJB] BYPASSED file = %@", path);
			return YES;
		}
	}
	// NSLog(@"[FlyJB] file = %@", path);
	return NO;
}

-(BOOL) isAhnLabPathRestricted: (NSString*) path {
	NSArray *jailbreakFiles = [NSArray arrayWithObjects:
	                           @"/etc/fstab",
	                           @"/usr/",
	                           @"/usr/include",
	                           @"DYLD_INSERT_LIBRARIES",
	                           nil
	                          ];
	for (NSString *jbFile in jailbreakFiles) {
		if ([path isEqualToString:jbFile]) {
			return YES;
		}
	}
	return NO;
}

@end
