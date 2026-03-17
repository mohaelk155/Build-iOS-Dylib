#import "AntiDebug.h"
#import <dlfcn.h>
#import <sys/sysctl.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <sys/syscall.h>
#import <objc/runtime.h>

#ifndef PT_DENY_ATTACH
#define PT_DENY_ATTACH 31
#endif

static int ptrace(int request, pid_t pid, caddr_t addr, int data) {
    return syscall(26, request, pid, addr, data);
}

@implementation AntiDebug

+ (void)applyAllProtections {
    if ([self isDebuggerAttached]) {
        exit(1);
    }
    
    [self ptraceDenyAttach];
    [self detectFrida];
    [self checkIntegrity];
}

+ (BOOL)isDebuggerAttached {
    int name[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()};
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    
    if (sysctl(name, 4, &info, &info_size, NULL, 0) == -1) {
        return NO;
    }
    
    return (info.kp_proc.p_flag & P_TRACED) != 0;
}

+ (void)ptraceDenyAttach {
    void *handle = dlopen(NULL, RTLD_LOCAL);
    if (handle) {
        int (*ptrace_ptr)(int, pid_t, caddr_t, int) = dlsym(handle, "ptrace");
        if (ptrace_ptr) {
            ptrace_ptr(31, 0, 0, 0);
        }
        dlclose(handle);
    }
}

+ (void)detectFrida {
    for(int port = 27042; port < 27045; port++) {
        int sock = socket(AF_INET, SOCK_STREAM, 0);
        struct sockaddr_in addr;
        addr.sin_family = AF_INET;
        addr.sin_port = htons(port);
        inet_aton("127.0.0.1", &addr.sin_addr);
        
        if (connect(sock, (struct sockaddr*)&addr, sizeof(addr)) == 0) {
            close(sock);
            exit(1);
        }
        close(sock);
    }
}

+ (void)checkIntegrity {
    Dl_info info;
    IMP currentIMP = class_getMethodImplementation(objc_getMetaClass("AntiDebug"), @selector(checkIntegrity));
    
    if (currentIMP) {
        dladdr((const void*)currentIMP, &info);
        
        unsigned int sum = 0;
        unsigned char *code = (unsigned char *)info.dli_fbase;
        for(int i = 0; i < 1024; i++) {
            sum += code[i];
        }
    }
}

@end
