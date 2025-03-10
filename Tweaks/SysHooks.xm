#import "../Headers/SysHooks.h"
#import "../Headers/FJPattern.h"
#import "../fishhook/fishhook.h"
#import "../Headers/dobby.h"
#include <sys/utsname.h>
#include <sys/stat.h>
#include <mach-o/dyld.h>
#include <sys/syscall.h>
#include <errno.h>
#include <dlfcn.h>
#include <mach/mach.h>
#include <mach-o/dyld_images.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <dirent.h>

#define kCFCoreFoundationVersionNumber_iOS_14_0 1740.00

%group SysHooks

// %hookf(void, exit, int code) {
// 	NSLog(@"[FlyJB] exit called");
// 	NSLog(@"[FlyJB] exit call stack:\n%@", [NSThread callStackSymbols]);
// 	%orig;
// }

%hookf(int, uname, struct utsname *value) {
	int ret = %orig;
	if (value) {
		const char *kernelName = value->version;
		NSString *kernelName_ns = [NSString stringWithUTF8String:kernelName];
		if([kernelName_ns containsString:@"hacked"] || [kernelName_ns containsString:@"MarijuanARM"]) {
			kernelName_ns = [kernelName_ns stringByReplacingOccurrencesOfString:@"hacked" withString:@""];
			kernelName_ns = [kernelName_ns stringByReplacingOccurrencesOfString:@"MarijuanARM" withString:@""];
			kernelName = [kernelName_ns cStringUsingEncoding:NSUTF8StringEncoding];
			strcpy(value->version, kernelName);
		}
	}
	return ret;
}

%hookf (int, mkdir, const char *pathname, mode_t mode) {
	NSString *path = [NSString stringWithUTF8String:pathname];
	if([path hasPrefix:@"/tmp/"]) {
		errno = ENOENT;
		return -1;
	}
	return %orig;
}


%hookf(int, rmdir, const char *pathname) {
	if(pathname) {
		NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

		if([[FJPattern sharedInstance] isPathRestricted:path]) {
			errno = ENOENT;
			return -1;
		}
	}
	return %orig(pathname);
}

%hookf(int, chdir, const char *pathname) {
	if(pathname) {
		NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];

		if([[FJPattern sharedInstance] isPathRestricted:path]) {
			errno = ENOENT;
			return -1;
		}
	}

	return %orig(pathname);
}

%hookf(int, chroot, const char *dirname) {
	if(dirname) {
		NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirname length:strlen(dirname)];

		if([[FJPattern sharedInstance] isPathRestricted:path]) {
			errno = ENOENT;
			return -1;
		}
	}
	return %orig;
}

%hookf(int, access, const char *pathname, int mode) {
	if(pathname) {
		NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];
		if([[FJPattern sharedInstance] isPathRestricted:path])
		{
			errno = ENOENT;
			return -1;
		}
	}
	return %orig;
}

static int (*orig_open)(const char *path, int oflag, ...);
static int hook_open(const char *path, int oflag, ...) {
	int result = 0;

	if(path) {
		NSString *pathname = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];

		if([[FJPattern sharedInstance] isPathRestricted:pathname]) {
			errno = ((oflag & O_CREAT) == O_CREAT) ? EACCES : ENOENT;
			return -1;
		}
	}

	if((oflag & O_CREAT) == O_CREAT) {
		mode_t mode;
		va_list args;

		va_start(args, oflag);
		mode = (mode_t) va_arg(args, int);
		va_end(args);

		result = orig_open(path, oflag, mode);
	} else {
		result = orig_open(path, oflag);
	}

	return result;
}

%hookf(int, rename, const char *oldname, const char *newname) {
	NSString *oldname_ns = nil;
	NSString *newname_ns = nil;

	if(oldname && newname) {
		oldname_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:oldname length:strlen(oldname)];
		newname_ns = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:newname length:strlen(newname)];

		if([oldname_ns hasPrefix:@"/tmp"] || [newname_ns hasPrefix:@"/tmp"]) {
			errno = ENOENT;
			return -1;
		}

	}
	return %orig;
}

%hookf(void *, dlsym, void *handle, const char *symbol) {
	if(symbol) {
		NSString *sym = [NSString stringWithUTF8String:symbol];
		if([sym isEqualToString:@"MSGetImageByName"]
		   || [sym isEqualToString:@"MSHookMemory"]
		   || [sym isEqualToString:@"MSFindSymbol"]
		   || [sym isEqualToString:@"MSHookFunction"]
		   || [sym isEqualToString:@"MSHookMessageEx"]
		   || [sym isEqualToString:@"MSHookClassPair"]
		   || [sym isEqualToString:@"_Z13flyjb_patternP8NSString"]
		   || [sym isEqualToString:@"_Z9hms_falsev"]
		   || [sym isEqualToString:@"rocketbootstrap_cfmessageportcreateremote"]
		   || [sym isEqualToString:@"rocketbootstrap_cfmessageportexposelocal"]
		   || [sym isEqualToString:@"rocketbootstrap_distributedmessagingcenter_apply"]
		   || [sym isEqualToString:@"rocketbootstrap_look_up"]
		   || [sym isEqualToString:@"rocketbootstrap_register"]
		   || [sym isEqualToString:@"rocketbootstrap_unlock"]) {
			//NSLog(@"[FlyJB] Bypassed dlsym handle:%p, symbol: %s", handle, symbol);
			return NULL;
		}
	}
	//NSLog(@"[FlyJB] Detected dlsym handle:%p, symbol: %s", handle, symbol);
	return %orig;
}

%hookf(int, lstat, const char *pathname, struct stat *statbuf) {
	if(pathname) {
		NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];
		if([[FJPattern sharedInstance] isPathRestricted:path])
		{
			errno = ENOENT;
			return -1;
		}
		if(statbuf) {
			if([path isEqualToString:@"/Applications"]
			   || [path isEqualToString:@"/usr/share"]
			   || [path isEqualToString:@"/usr/libexec"]
			   || [path isEqualToString:@"/usr/include"]
			   || [path isEqualToString:@"/Library/Ringtones"]
			   || [path isEqualToString:@"/Library/Wallpaper"]) {
				int ret = %orig;

				if(ret == 0 && (statbuf->st_mode & S_IFLNK) == S_IFLNK) {
					statbuf->st_mode &= ~S_IFLNK;
					return ret;
				}
			}

			if([path isEqualToString:@"/bin"]) {
				int ret = %orig;

				if(ret == 0 && statbuf->st_size > 128) {
					statbuf->st_size = 128;
					return ret;
				}
			}
		}
	}
	return %orig;
}

%hookf(int, stat, const char *pathname, struct stat *statbuf) {
	if(pathname) {
		NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];
		if([[FJPattern sharedInstance] isPathRestricted:path])
		{
			errno = ENOENT;
			return -1;
		}
	}
	return %orig;
}

%end

%group SysHooks2
static int (*orig_syscall)(int num, ...);
static int hook_syscall(int num, ...) {

	char *stack[8];
	va_list args;
	va_start(args, num);

#if defined __arm64__ || defined __arm64e__
	memcpy(stack, args, 64);
#endif

#if defined __armv7__ || defined __armv7s__
	memcpy(stack, args, 32);
#endif

	if(num == SYS_access || num == SYS_open || num == SYS_stat || num == SYS_lstat || num == SYS_stat64 || num == SYS_chdir || num == SYS_chroot) {
		const char *path = va_arg(args, const char*);
		if([[FJPattern sharedInstance] isPathRestricted:[NSString stringWithUTF8String:path]]) {
			//NSLog(@"[FlyJB] Blocked Syscall Path = %s, num = %d", path, num);
			errno = ENOENT;
			return -1;
		}
		//NSLog(@"[FlyJB] Detected Syscall Path = %s, num = %d", path, num);
	}

	if(num == SYS_mkdir) {
		const char *path = va_arg(args, const char*);
		if([[NSString stringWithUTF8String:path] hasPrefix:@"/tmp/"]) {
			errno = EACCES;
			return -1;
		}
	}

	if(num == SYS_rmdir) {
		const char *path = va_arg(args, const char*);
		if([[FJPattern sharedInstance] isPathRestricted:[NSString stringWithUTF8String:path]]) {
			errno = ENOENT;
			return -1;
		}
	}

	if(num == SYS_rename) {
		const char *path = va_arg(args, const char*);
		const char *path2 = va_arg(args, const char*);
		if([[NSString stringWithUTF8String:path] hasPrefix:@"/tmp"] || [[NSString stringWithUTF8String:path2] hasPrefix:@"/tmp"]) {
			errno = ENOENT;
			return -1;
		}
	}

	va_end(args);
	return orig_syscall(num, stack[0], stack[1], stack[2], stack[3], stack[4], stack[5], stack[6], stack[7]);
}

%hookf(pid_t, fork) {
	errno = ENOSYS;
	return -1;
}

%hookf(FILE *, fopen, const char *pathname, const char *mode) {
	if(pathname) {
		NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];
		if([[FJPattern sharedInstance] isPathRestricted:path])
		{
			errno = ENOENT;
			return NULL;
		}
	}
	return %orig(pathname, mode);
}

%hookf(const char *, _dyld_get_image_name, uint32_t image_index) {
	const char *ret = %orig(image_index);
	if(ret) {
		NSString *detection = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:ret length:strlen(ret)];
		NSString *lower = [detection lowercaseString];
		if ([lower rangeOfString:@"substrate"].location != NSNotFound ||
		    [lower rangeOfString:@"substitute"].location != NSNotFound ||
		    [lower rangeOfString:@"substitrate"].location != NSNotFound ||
		    [lower rangeOfString:@"cephei"].location != NSNotFound ||
		    [lower rangeOfString:@"rocketbootstrap"].location != NSNotFound ||
		    [lower rangeOfString:@"tweakinject"].location != NSNotFound ||
		    [lower rangeOfString:@"jailbreak"].location != NSNotFound ||
		    [lower rangeOfString:@"cycript"].location != NSNotFound ||
		    [lower rangeOfString:@"pspawn"].location != NSNotFound ||
		    [lower rangeOfString:@"libcolorpicker"].location != NSNotFound ||
		    [lower rangeOfString:@"libcs"].location != NSNotFound ||
		    [lower rangeOfString:@"bfdecrypt"].location != NSNotFound ||
		    [lower rangeOfString:@"sbinject"].location != NSNotFound ||
		    [lower rangeOfString:@"dobby"].location != NSNotFound ||
		    [lower rangeOfString:@"libhooker"].location != NSNotFound ||
		    [lower rangeOfString:@"snowboard"].location != NSNotFound ||
		    [lower rangeOfString:@"libblackjack"].location != NSNotFound ||
		    [lower rangeOfString:@"libobjc-trampolines"].location != NSNotFound ||
		    [lower rangeOfString:@"cephei"].location != NSNotFound ||
		    [lower rangeOfString:@"libmryipc"].location != NSNotFound ||
		    [lower rangeOfString:@"libactivator"].location != NSNotFound ||
		    [lower rangeOfString:@"alderis"].location != NSNotFound ||
		    [lower rangeOfString:@"libcloaky"].location != NSNotFound) {
			//NSLog(@"[FlyJB] Bypassed SysHooks2 _dyld_get_image_name : %s", ret);
			return "/dyld.bypass";
		}
	}
	//NSLog(@"[FlyJB] Detected SysHooks2 _dyld_get_image_name : %s", ret);
	return ret;
}
%end

%group SysHooks3
%hookf(char *, getenv, const char *name) {

	if(name) {
		NSString *env = [NSString stringWithUTF8String:name];

		if([env isEqualToString:@"DYLD_INSERT_LIBRARIES"]
		   || [env isEqualToString:@"_MSSafeMode"]
		   || [env isEqualToString:@"_SafeMode"]) {
			return NULL;
		}
	}
	return %orig;
}
%end

uint32_t dyldCount = 0;
char **dyldNames = 0;
struct mach_header **dyldHeaders = 0;
void syncDyldArray() {
	uint32_t count = _dyld_image_count();
	uint32_t counter = 0;
	//NSLog(@"[FlyJB] There are %u images", count);
	dyldNames = (char **) calloc(count, sizeof(char **));
	dyldHeaders = (struct mach_header **) calloc(count, sizeof(struct mach_header **));
	for (int i = 0; i < count; i++) {
		const char *charName = _dyld_get_image_name(i);
		if (!charName) {
			continue;
		}
		NSString *name = [NSString stringWithUTF8String: charName];
		if (!name) {
			continue;
		}
		NSString *lower = [name lowercaseString];
		if ([lower rangeOfString:@"substrate"].location != NSNotFound ||
		    [lower rangeOfString:@"substitute"].location != NSNotFound ||
		    [lower rangeOfString:@"substitrate"].location != NSNotFound ||
		    [lower rangeOfString:@"cephei"].location != NSNotFound ||
		    [lower rangeOfString:@"rocketbootstrap"].location != NSNotFound ||
		    [lower rangeOfString:@"tweakinject"].location != NSNotFound ||
		    [lower rangeOfString:@"jailbreak"].location != NSNotFound ||
		    [lower rangeOfString:@"cycript"].location != NSNotFound ||
		    [lower rangeOfString:@"pspawn"].location != NSNotFound ||
		    [lower rangeOfString:@"libcolorpicker"].location != NSNotFound ||
		    [lower rangeOfString:@"libcs"].location != NSNotFound ||
		    [lower rangeOfString:@"bfdecrypt"].location != NSNotFound ||
		    [lower rangeOfString:@"sbinject"].location != NSNotFound ||
		    [lower rangeOfString:@"dobby"].location != NSNotFound ||
		    [lower rangeOfString:@"libhooker"].location != NSNotFound ||
		    [lower rangeOfString:@"snowboard"].location != NSNotFound ||
		    [lower rangeOfString:@"libblackjack"].location != NSNotFound ||
		    [lower rangeOfString:@"libobjc-trampolines"].location != NSNotFound ||
		    [lower rangeOfString:@"cephei"].location != NSNotFound ||
		    [lower rangeOfString:@"libmryipc"].location != NSNotFound ||
		    [lower rangeOfString:@"libactivator"].location != NSNotFound ||
		    [lower rangeOfString:@"alderis"].location != NSNotFound ||
		    [lower rangeOfString:@"libcloaky"].location != NSNotFound) {
			//NSLog(@"[FlyJB] BYPASSED dyld = %@", name);
			continue;
		}
		uint32_t idx = counter++;
		dyldNames[idx] = strdup(charName);
		dyldHeaders[idx] = (struct mach_header *) _dyld_get_image_header(i);
	}
	dyldCount = counter;
}

%group SysHooks4
%hookf(uint32_t, _dyld_image_count) {
	return dyldCount;
}
%hookf(const char *, _dyld_get_image_name, uint32_t image_index) {
	return dyldNames[image_index];
}
%hookf(struct mach_header *, _dyld_get_image_header, uint32_t image_index) {
	return dyldHeaders[image_index];
}

%hookf(int, connect, int sockfd, const struct sockaddr *serv_addr, socklen_t addrlen) {
	NSString *appPath = [[[[NSBundle mainBundle] bundleURL] absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
	const char *LiAppPath = [[appPath stringByAppendingString:@"LIAPP.ini"] cStringUsingEncoding:NSUTF8StringEncoding];

	FILE *LiApp = fopen(LiAppPath, "r");

	if(LiApp) {
		//NSLog(@"[FlyJB] Found LIAPP.ini");
		char LiAppString[32];
		while (!feof(LiApp)) {
			fgets(LiAppString, 32, LiApp);
			if(strstr(LiAppString, "serverip=") != NULL)  {
				//NSLog(@"[FlyJB] LiAppString = %s", LiAppString);
				break;
			}
		}
		fclose(LiApp);

		NSString *LiAppIP = [[NSString stringWithUTF8String:LiAppString] stringByReplacingOccurrencesOfString:@"serverip=" withString:@""];
		LiAppIP = [LiAppIP stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		const char *LiAppIP2 = [LiAppIP cStringUsingEncoding:NSUTF8StringEncoding];

		struct hostent *host_entry = gethostbyname(LiAppIP2);
		int ndx = 0;
		struct sockaddr_in *myaddr = (struct sockaddr_in *)serv_addr;
		if (host_entry) {
			for (ndx = 0; NULL != host_entry->h_addr_list[ndx]; ndx++) {
				//NSLog(@"[FlyJB] LiAppIP: %s, LiAppIP(hex): %x", inet_ntoa(*(struct in_addr*)host_entry->h_addr_list[ndx]), inet_addr(inet_ntoa(*(struct in_addr*)host_entry->h_addr_list[ndx])));

				if(myaddr->sin_addr.s_addr == inet_addr(inet_ntoa(*(struct in_addr*)host_entry->h_addr_list[ndx]))) {
					//NSLog(@"[FlyJB] Blocked connect ip: %s, ip(hex): %x, port:%d", inet_ntoa(myaddr->sin_addr), myaddr->sin_addr.s_addr, myaddr->sin_port);
					errno = ETIMEDOUT;
					return -1;
				}
			}
		}
		//NSLog(@"[FlyJB] Detected connect ip: %s, ip(hex): %x, port:%d", inet_ntoa(myaddr->sin_addr), myaddr->sin_addr.s_addr, myaddr->sin_port);
	}
	return %orig;
}


%hookf(kern_return_t, task_info, task_name_t target_task, task_flavor_t flavor, task_info_t task_info_out, mach_msg_type_number_t *task_info_outCnt) {
	if (flavor == TASK_DYLD_INFO) {
		kern_return_t ret = %orig(target_task, flavor, task_info_out, task_info_outCnt);
		if (ret == KERN_SUCCESS) {
			struct task_dyld_info *task_info = (struct task_dyld_info *) task_info_out;
			struct dyld_all_image_infos *dyld_info = (struct dyld_all_image_infos *) task_info->all_image_info_addr;
			dyld_info->infoArrayCount = 1;
		}
		return ret;
	}
	return %orig(target_task, flavor, task_info_out, task_info_outCnt);
}
%end

%group OpendirSysHooks
DIR *(*orig_opendir)(const char *pathname);
static DIR *hook_opendir(const char *pathname) {
	if(pathname) {
		NSString *path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:pathname length:strlen(pathname)];
		if([[FJPattern sharedInstance] isPathRestricted:path])
		{
			errno = ENOENT;
			return NULL;
		}
	}
	return orig_opendir(pathname);
}
%end

void open_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {
#if defined __arm64__
	const char* path = (const char*)(uint64_t)(reg_ctx->general.regs.x0);
	NSString* path2 = [NSString stringWithUTF8String:path];

	if([[FJPattern sharedInstance] isPathRestricted:path2]) {
		//NSLog(@"[FlyJB] Bypassed open path = %s", path);
		unsigned long fileValue = 0;
		__asm __volatile("mov x0, %0" :: "r" ("/XsF1re_Bypass!@#"));         //path
		__asm __volatile("mov %0, x0" : "=r" (fileValue));
		*(unsigned long *)(&reg_ctx->general.regs.x0) = fileValue;
	}
	else {
		//NSLog(@"[FlyJB] Detected open path = %s", path);
	}

#endif
}

void loadSysHooks() {
	%init(SysHooks);
	//Substrate crash when hook open on iOS 14... WTF?
	//Use dobbyhook instead :)
	DobbyInstrument(dlsym((void *)RTLD_DEFAULT, "open"), (DBICallTy)open_handler);
}

void loadSysHooks2() {
	%init(SysHooks2);
	MSHookFunction(dlsym((void *)RTLD_DEFAULT, "syscall"),(void*)hook_syscall,(void**)&orig_syscall);
}

void loadSysHooks3() {
	%init(SysHooks3);
}

void loadSysHooks4() {
	syncDyldArray();
	%init(SysHooks4);
}

void loadOpendirSysHooks() {
	%init(OpendirSysHooks);
	rebind_symbols((struct rebinding[1]){{"opendir", (void *)hook_opendir, (void **)&orig_opendir}}, 1);
}
