Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B18C43217
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiDQSYf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiDQSYe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:24:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BB313D1D
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92AEA60C3C
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A29C385A9;
        Sun, 17 Apr 2022 18:21:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9X1-004MzU-CH;
        Sun, 17 Apr 2022 14:21:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 7/7] trace-cmd: Move vsocket code into its own file
Date:   Sun, 17 Apr 2022 14:21:54 -0400
Message-Id: <20220417182154.1041513-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417182154.1041513-1-rostedt@goodmis.org>
References: <20220417182154.1041513-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Create trace-vsock.c to hold vsock specific operations. Several files
duplicate the implementation of vsocket connections. Consolidate all of
them into a single file to be used by all, and also can be disabled in
a single place, getting rid of a lot of the #ifdef VSOCKs that are
poluting the code.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/trace-tsync-local.h |  11 ++
 lib/trace-cmd/trace-timesync-ptp.c        |   1 -
 lib/trace-cmd/trace-timesync.c            |   5 -
 tracecmd/Makefile                         |   1 +
 tracecmd/include/trace-local.h            |  48 +++++++
 tracecmd/trace-agent.c                    | 165 +---------------------
 tracecmd/trace-record.c                   |  86 +----------
 tracecmd/trace-vm.c                       |   2 +-
 tracecmd/trace-vsock.c                    | 156 ++++++++++++++++++++
 9 files changed, 228 insertions(+), 247 deletions(-)
 create mode 100644 tracecmd/trace-vsock.c

diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 697c076c43a6..885c9f51d891 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -65,7 +65,18 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 					      long long *, unsigned int));
 int tracecmd_tsync_proto_unregister(char *proto_name);
 
+#ifdef VSOCK
 int ptp_clock_sync_register(void);
 int kvm_clock_sync_register(void);
+#else
+static inline int ptp_clock_sync_register(void)
+{
+	return 0;
+}
+static inline int kvm_clock_sync_register(void)
+{
+	return 0;
+}
+#endif
 
 #endif /* _TRACE_TSYNC_LOCAL_H */
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
index 0e23ff83869a..653d176e2e79 100644
--- a/lib/trace-cmd/trace-timesync-ptp.c
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -8,7 +8,6 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <arpa/inet.h>
-#include <linux/vm_sockets.h>
 #include <sys/types.h>
 #include <linux/types.h>
 #include <time.h>
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 823dcf21ba26..14cf20c870cb 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -8,9 +8,6 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <arpa/inet.h>
-#ifdef VSOCK
-#include <linux/vm_sockets.h>
-#endif
 #include <linux/limits.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -65,10 +62,8 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
  */
 void tracecmd_tsync_init(void)
 {
-#ifdef VSOCK
 	ptp_clock_sync_register();
 	kvm_clock_sync_register();
-#endif
 }
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 355f04723ad7..13f7776e8e45 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -37,6 +37,7 @@ TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-clear.o
 TRACE_CMD_OBJS += trace-vm.o
 TRACE_CMD_OBJS += trace-convert.o
+TRACE_CMD_OBJS += trace-vsock.o
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index bb33de06bb58..863635886769 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -9,6 +9,7 @@
 #include <sys/types.h>
 #include <dirent.h>	/* for DIR */
 #include <ctype.h>	/* for isdigit() */
+#include <errno.h>
 #include <limits.h>
 
 #include "trace-cmd-private.h"
@@ -339,6 +340,53 @@ int trace_open_vsock(unsigned int cid, unsigned int port);
 
 char *trace_get_guest_file(const char *file, const char *guest);
 
+#ifdef VSOCK
+int trace_vsock_open(unsigned int cid, unsigned int port);
+int trace_vsock_make(unsigned int port);
+int trace_vsock_make_any(void);
+int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid);
+int trace_vsock_get_port(int sd, unsigned int *port);
+bool trace_vsock_can_splice_read(void);
+int trace_vsock_local_cid(void);
+#else
+static inline int trace_vsock_open(unsigned int cid, unsigned int port)
+{
+	return -ENOTSUP;
+}
+
+static inline int trace_vsock_make(unsigned int port)
+{
+	return -ENOTSUP;
+
+}
+
+static inline int trace_vsock_make_any(void)
+{
+	return -ENOTSUP;
+
+}
+
+static inline int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
+{
+	return -ENOTSUP;
+}
+
+static inline int trace_vsock_get_port(int sd, unsigned int *port)
+{
+	return -ENOTSUP;
+}
+
+static inline bool trace_vsock_can_splice_read(void)
+{
+	return false;
+}
+
+static inline int trace_vsock_local_cid(void)
+{
+	return -ENOTSUP;
+}
+#endif /* VSOCK */
+
 /* No longer in event-utils.h */
 __printf(1,2)
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index bfa9a534f153..719d7126ca67 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -14,85 +14,25 @@
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <sys/ioctl.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <unistd.h>
-#include <linux/vm_sockets.h>
 #include <pthread.h>
 
 #include "trace-local.h"
 #include "trace-msg.h"
 
-#define GET_LOCAL_CID	0x7b9
-
-static int get_local_cid(unsigned int *cid)
-{
-	int fd, ret = 0;
-
-	fd = open("/dev/vsock", O_RDONLY);
-	if (fd < 0)
-		return -errno;
-
-	if (ioctl(fd, GET_LOCAL_CID, cid))
-		ret = -errno;
-
-	close(fd);
-	return ret;
-}
-
-int trace_make_vsock(unsigned int port)
-{
-	struct sockaddr_vm addr = {
-		.svm_family = AF_VSOCK,
-		.svm_cid = VMADDR_CID_ANY,
-		.svm_port = port,
-	};
-	int sd;
-
-	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
-	if (sd < 0)
-		return -errno;
-
-	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
-
-	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
-		return -errno;
-
-	if (listen(sd, SOMAXCONN))
-		return -errno;
-
-	return sd;
-}
-
-int trace_get_vsock_port(int sd, unsigned int *port)
-{
-	struct sockaddr_vm addr;
-	socklen_t addr_len = sizeof(addr);
-
-	if (getsockname(sd, (struct sockaddr *)&addr, &addr_len))
-		return -errno;
-
-	if (addr.svm_family != AF_VSOCK)
-		return -EINVAL;
-
-	if (port)
-		*port = addr.svm_port;
-
-	return 0;
-}
-
 static void make_vsocks(int nr, int *fds, unsigned int *ports)
 {
 	unsigned int port;
 	int i, fd, ret;
 
 	for (i = 0; i < nr; i++) {
-		fd = trace_make_vsock(VMADDR_PORT_ANY);
+		fd = trace_vsock_make_any();
 		if (fd < 0)
 			die("Failed to open vsocket");
 
-		ret = trace_get_vsock_port(fd, &port);
+		ret = trace_vsock_get_port(fd, &port);
 		if (ret < 0)
 			die("Failed to get vsocket address");
 
@@ -140,98 +80,6 @@ static char *get_clock(int argc, char **argv)
 	return NULL;
 }
 
-#ifdef VSOCK
-
-static int vsock_make(void)
-{
-	struct sockaddr_vm addr = {
-		.svm_family = AF_VSOCK,
-		.svm_cid = VMADDR_CID_ANY,
-		.svm_port = VMADDR_PORT_ANY,
-	};
-	int sd;
-
-	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
-	if (sd < 0)
-		return -errno;
-
-	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
-
-	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
-		return -errno;
-
-	if (listen(sd, SOMAXCONN))
-		return -errno;
-
-	return sd;
-}
-
-static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
-{
-	struct sockaddr_vm addr;
-	socklen_t addr_len = sizeof(addr);
-
-	memset(&addr, 0, sizeof(addr));
-	if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
-		return -1;
-	if (addr.svm_family != AF_VSOCK)
-		return -1;
-	*lcid = addr.svm_cid;
-
-	memset(&addr, 0, sizeof(addr));
-	addr_len = sizeof(addr);
-	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
-		return -1;
-	if (addr.svm_family != AF_VSOCK)
-		return -1;
-	*rcid = addr.svm_cid;
-
-	return 0;
-}
-
-static int vsock_get_port(int sd, unsigned int *port)
-{
-	struct sockaddr_vm addr;
-	socklen_t addr_len = sizeof(addr);
-
-	if (getsockname(sd, (struct sockaddr *)&addr, &addr_len))
-		return -errno;
-
-	if (addr.svm_family != AF_VSOCK)
-		return -EINVAL;
-
-	if (port)
-		*port = addr.svm_port;
-
-	return 0;
-}
-#else
-static inline bool can_splice_read_vsock(void)
-{
-	return false;
-}
-
-static inline int vsock_make(void)
-{
-	return -ENOTSUP;
-
-}
-
-static inline  int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid) {
-	return -1;
-}
-
-static inline int vsock_get_port(int sd, unsigned int *port)
-{
-	return -1;
-}
-
-static int vsock_get_port(int sd, unsigned int *port)
-{
-	return -ENOTSUP;
-}
-#endif
-
 static void agent_handle(int sd, int nr_cpus, int page_size)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
@@ -278,8 +126,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 			remote_id = -1;
 			local_id = -2;
 		}
-		fd = vsock_make();
-		if (fd >= 0 && vsock_get_port(fd, &tsync_port) >= 0) {
+		fd = trace_vsock_make_any();
+		if (fd >= 0 && trace_vsock_get_port(fd, &tsync_port) >= 0) {
 			tsync = tracecmd_tsync_with_host(fd, tsync_protos,
 							 get_clock(argc, argv),
 							 remote_id, local_id);
@@ -356,12 +204,13 @@ static void agent_serve(unsigned int port, bool do_daemon)
 	nr_cpus = tracecmd_count_cpus();
 	page_size = getpagesize();
 
-	sd = trace_make_vsock(port);
+	sd = trace_vsock_make(port);
 	if (sd < 0)
 		die("Failed to open vsocket");
 	tracecmd_tsync_init();
 
-	if (!get_local_cid(&cid))
+	cid = trace_vsock_local_cid();
+	if (cid >= 0)
 		printf("listening on @%u:%u\n", cid, port);
 
 	if (do_daemon && daemon(1, 0))
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8e89aa94977c..ac6fb7e98892 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -37,9 +37,6 @@
 #include <poll.h>
 #include <pwd.h>
 #include <grp.h>
-#ifdef VSOCK
-#include <linux/vm_sockets.h>
-#endif
 
 #include "tracefs.h"
 #include "version.h"
@@ -3159,81 +3156,6 @@ static int connect_port(const char *host, unsigned int port)
 	return sfd;
 }
 
-#ifdef VSOCK
-int trace_open_vsock(unsigned int cid, unsigned int port)
-{
-	struct sockaddr_vm addr = {
-		.svm_family = AF_VSOCK,
-		.svm_cid = cid,
-		.svm_port = port,
-	};
-	int sd;
-
-	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
-	if (sd < 0)
-		return -errno;
-
-	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
-		return -errno;
-
-	return sd;
-}
-
-static int try_splice_read_vsock(void)
-{
-	int ret, sd, brass[2];
-
-	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
-	if (sd < 0)
-		return -errno;
-
-	ret = pipe(brass);
-	if (ret < 0)
-		goto out_close_sd;
-
-	/*
-	 * On kernels that don't support splice reading from vsockets
-	 * this will fail with EINVAL, or ENOTCONN otherwise.
-	 * Technically, it should never succeed but if it does, claim splice
-	 * reading is supported.
-	 */
-	ret = splice(sd, NULL, brass[1], NULL, 10, 0);
-	if (ret < 0)
-		ret = errno != EINVAL;
-	else
-		ret = 1;
-
-	close(brass[0]);
-	close(brass[1]);
-out_close_sd:
-	close(sd);
-	return ret;
-}
-
-static bool can_splice_read_vsock(void)
-{
-	static bool initialized, res;
-
-	if (initialized)
-		return res;
-
-	res = try_splice_read_vsock() > 0;
-	initialized = true;
-	return res;
-}
-
-#else
-int trace_open_vsock(unsigned int cid, unsigned int port)
-{
-	die("vsock is not supported");
-	return -1;
-}
-static inline bool can_splice_read_vsock(void)
-{
-	return false;
-}
-#endif
-
 static int do_accept(int sd)
 {
 	int cd;
@@ -3366,14 +3288,14 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 		if (instance->use_fifos)
 			fd = instance->fds[cpu];
 		else
-			fd = trace_open_vsock(instance->cid, instance->client_ports[cpu]);
+			fd = trace_vsock_open(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
 		flags = recorder_flags;
 		if (instance->use_fifos)
 			flags |= TRACECMD_RECORD_NOBRASS;
-		else if (!can_splice_read_vsock())
+		else if (!trace_vsock_can_splice_read())
 			flags |= TRACECMD_RECORD_NOSPLICE;
 		return tracecmd_create_recorder_virt(file, cpu, flags, fd);
 	}
@@ -3988,7 +3910,7 @@ static int host_tsync(struct common_record_context *ctx,
 	guest_pid = guest->pid;
 	start_mapping_vcpus(guest);
 
-	fd = trace_open_vsock(instance->cid, tsync_port);
+	fd = trace_vsock_open(instance->cid, tsync_port);
 	instance->tsync = tracecmd_tsync_with_guest(top_instance.trace_id,
 						    instance->tsync_loop_interval,
 						    fd, guest_pid,
@@ -4019,7 +3941,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 		use_fifos = nr_fifos > 0;
 	}
 
-	sd = trace_open_vsock(instance->cid, instance->port);
+	sd = trace_vsock_open(instance->cid, instance->port);
 	if (sd < 0)
 		die("Failed to connect to vsocket @%u:%u",
 		    instance->cid, instance->port);
diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 02979ba59a57..57dbef8d42e4 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -284,7 +284,7 @@ static void find_pid_by_cid(struct trace_guest *guest)
 	int fd;
 
 	instance = start_trace_connect();
-	fd = trace_open_vsock(guest->cid, -1);
+	fd = trace_vsock_open(guest->cid, -1);
 	guest->pid = stop_trace_connect(instance);
 	/* Just in case! */
 	if (fd >= 0)
diff --git a/tracecmd/trace-vsock.c b/tracecmd/trace-vsock.c
new file mode 100644
index 000000000000..d18ecb45004e
--- /dev/null
+++ b/tracecmd/trace-vsock.c
@@ -0,0 +1,156 @@
+#include <unistd.h>
+#include <errno.h>
+#include <arpa/inet.h>
+#include <sys/ioctl.h>
+#include <linux/vm_sockets.h>
+
+#include "trace-cmd-private.h"
+
+int __hidden trace_vsock_open(unsigned int cid, unsigned int port)
+{
+	struct sockaddr_vm addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = cid,
+		.svm_port = port,
+	};
+	int sd;
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -errno;
+
+	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
+		return -errno;
+
+	return sd;
+}
+
+int __hidden trace_vsock_make(unsigned int port)
+{
+	struct sockaddr_vm addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = VMADDR_CID_ANY,
+		.svm_port = port,
+	};
+	int sd;
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -errno;
+
+	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
+
+	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
+		return -errno;
+
+	if (listen(sd, SOMAXCONN))
+		return -errno;
+
+	return sd;
+}
+
+int __hidden trace_vsock_make_any(void)
+{
+	return trace_vsock_make(VMADDR_PORT_ANY);
+}
+
+int __hidden trace_vsock_get_port(int sd, unsigned int *port)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	if (getsockname(sd, (struct sockaddr *)&addr, &addr_len))
+		return -errno;
+
+	if (addr.svm_family != AF_VSOCK)
+		return -EINVAL;
+
+	if (port)
+		*port = addr.svm_port;
+
+	return 0;
+}
+
+int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	memset(&addr, 0, sizeof(addr));
+	if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
+		return -1;
+	if (addr.svm_family != AF_VSOCK)
+		return -1;
+	*lcid = addr.svm_cid;
+
+	memset(&addr, 0, sizeof(addr));
+	addr_len = sizeof(addr);
+	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
+		return -1;
+	if (addr.svm_family != AF_VSOCK)
+		return -1;
+	*rcid = addr.svm_cid;
+
+	return 0;
+}
+
+static int try_splice_read_vsock(void)
+{
+	int ret, sd, brass[2];
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -errno;
+
+	ret = pipe(brass);
+	if (ret < 0)
+		goto out_close_sd;
+
+	/*
+	 * On kernels that don't support splice reading from vsockets
+	 * this will fail with EINVAL, or ENOTCONN otherwise.
+	 * Technically, it should never succeed but if it does, claim splice
+	 * reading is supported.
+	 */
+	ret = splice(sd, NULL, brass[1], NULL, 10, 0);
+	if (ret < 0)
+		ret = errno != EINVAL;
+	else
+		ret = 1;
+
+	close(brass[0]);
+	close(brass[1]);
+out_close_sd:
+	close(sd);
+	return ret;
+}
+
+bool __hidden trace_vsock_can_splice_read(void)
+{
+	static bool initialized, res;
+
+	if (initialized)
+		return res;
+
+	res = try_splice_read_vsock() > 0;
+	initialized = true;
+	return res;
+}
+
+#define GET_LOCAL_CID	0x7b9
+
+int __hidden trace_vsock_local_cid(void)
+{
+	int cid;
+	int fd;
+
+	fd = open("/dev/vsock", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	if (ioctl(fd, GET_LOCAL_CID, &cid))
+		cid = -errno;
+
+	close(fd);
+	return cid;
+}
-- 
2.35.1

