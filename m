Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E2BC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DDE764F6E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhCQLkK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 07:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhCQLjl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 07:39:41 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50ACC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 04:39:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id c10so2030284ejx.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 04:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WJfXUIj29YoZRJ08XNHvMIZGpxL/HgtvtusK2KsbGWY=;
        b=qQu81ZVMWwdpBBgKFLvPTRAGJ1RoEsK5g4vP/+Xs85vSf2uG6QMCps5XI/IbnEPafQ
         3E6FvGWGI2aOqVyMm/8UGmCOHB9LC9/3yveZz1Yj7SZ16o7gUuIoeYuZyowx/0FytdcN
         fI8sEdc11F+pUJ+VvS2AmU643QOTYx1PyuzbJVxrCmpOAe1JmcK/QZap130YOQF9NQFz
         J5hvGTnpJeMNIcj3z8SnT8QdqgUzVlM+9B5v2Z2p1K/xUgiN1US6FcwhwVdW+B9wgS/s
         mspMFt4QWjdivM1uDNVxSvwbDJndRhRrJ2PKtg/D8FcIE2xHB8f/pp1XvQfmHXxz6jof
         Jykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WJfXUIj29YoZRJ08XNHvMIZGpxL/HgtvtusK2KsbGWY=;
        b=ZlZG3UO98KIA3szIw/rfSNjHWfBnR/cBKe/IuKftcl+l34Yau+4edsxg4/hvZu62gJ
         0HKsNAuuQmkSCUV0wgYH0AT8tJ2Df+7jjdF1g3CvS+qAmg6iqshvsSMkRtvXacM42uDU
         XyAYu+JJf3Ksf92lWSx3x/sok5CwY3IA2TLMG7Y0xI2B2bZQsh+VodYKTm5VmERYwMln
         2bmkZayVfjl7N2ISp6iRHQ1Ufof8POJ5cgQ6cvW6K3eonCVahI1b+KFpR+1Zj/SeC+jZ
         9eeB8ehW91hhUDct3zEV6eClJUaupk94h6XTlMa/d6gc9bJkyo0GF5ewRkqsONgf5RVT
         CE+A==
X-Gm-Message-State: AOAM531uBlCQSAZPZ4rGOFaJuEaKR8lk0nFJYa9H/zFsncxWS3BYDfMw
        edNSGEIiV0nv1F8LUVhJRjIcKhOG1pg=
X-Google-Smtp-Source: ABdhPJxtPtYiwGXd3R/AoUvwHrhjUmI62mvTUm9eerDDfb7Ybntae+AVrHOPQ7UkBBvbhaYkw7ZUeQ==
X-Received: by 2002:a17:906:a44f:: with SMTP id cb15mr34249697ejb.420.1615981179220;
        Wed, 17 Mar 2021 04:39:39 -0700 (PDT)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p3sm11124492ejd.7.2021.03.17.04.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 04:39:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cmd: Move time sync logic in the trace-cmd library
Date:   Wed, 17 Mar 2021 13:39:35 +0200
Message-Id: <20210317113936.271143-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210317113936.271143-1-tz.stoyanov@gmail.com>
References: <20210317113936.271143-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The whole timestamp synchronization logic is moved in the trace-cmd
library. It is compiled regardless of if vsock is supported or not,
although it will not work if thers is no vsock support. The logic is
abstracted, the application receives a time sync context which
represents the synchronization session. These library APIs can be used
to control the synchronization session:
  tracecmd_tsync_init()
  tracecmd_tsync_proto_getall()
  tsync_proto_is_supported()
  tracecmd_tsync_with_host()
  tracecmd_tsync_with_host_stop()
  tracecmd_tsync_with_guest()
  tracecmd_tsync_with_guest_stop()
  tracecmd_tsync_free()
  tracecmd_tsync_get_offsets()
  tracecmd_tsync_get_session_params()
  tracecmd_write_guest_time_shift()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/Makefile                        |   2 -
 .../include/private/trace-cmd-private.h       |  33 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  16 +
 lib/trace-cmd/trace-timesync.c                | 503 ++++++++++++++++--
 tracecmd/Makefile                             |   3 -
 tracecmd/include/trace-local.h                |   5 +-
 tracecmd/trace-agent.c                        |  19 +-
 tracecmd/trace-record.c                       |  70 ++-
 tracecmd/trace-tsync.c                        | 294 ----------
 9 files changed, 565 insertions(+), 380 deletions(-)
 delete mode 100644 tracecmd/trace-tsync.c

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 841c84f1..2f553ed5 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -17,9 +17,7 @@ OBJS += trace-util.o
 OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
-ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync.o
-endif
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ecde8d13..6b32ce58 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -421,6 +421,7 @@ const char *tracecmd_clock_id2str(enum tracecmd_clocks clock);
 
 /* --- Timestamp synchronization --- */
 
+struct tracecmd_time_sync;
 #define TRACECMD_TSYNC_PNAME_LENGTH	16
 #define TRACECMD_TSYNC_PROTO_NONE	"none"
 
@@ -434,34 +435,30 @@ enum tracecmd_time_sync_role {
 	TRACECMD_TIME_SYNC_ROLE_GUEST	= (1 << 1),
 };
 
-struct tracecmd_time_sync {
-	const char			*proto_name;
-	int				loop_interval;
-	pthread_mutex_t			lock;
-	pthread_cond_t			cond;
-	char				*clock_str;
-	struct tracecmd_msg_handle	*msg_handle;
-	void				*context;
-	int				guest_pid;
-	int				vcpu_count;
-};
-
 /* Timestamp synchronization flags */
 #define TRACECMD_TSYNC_FLAG_INTERPOLATE	0x1
 
 void tracecmd_tsync_init(void);
 int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock, int role);
-const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock,
-					enum tracecmd_time_sync_role role);
 bool tsync_proto_is_supported(const char *proto_name);
-void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
-void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
+struct tracecmd_time_sync *
+tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
+			 const char *clock);
+int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync);
+struct tracecmd_time_sync *
+tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
+			  unsigned int cid, unsigned int port, int guest_pid,
+			  int guest_cpus, const char *proto_name, const char *clock);
+int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
 				int *count, long long **ts,
 				long long **offsets, long long **scalings);
-int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
-				   unsigned int *flags);
+int tracecmd_tsync_get_session_params(struct tracecmd_time_sync *tsync,
+				      char **selected_proto,
+				      unsigned int *tsync_port);
 void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
+int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
+				    struct tracecmd_time_sync *tsync);
 
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 83d1721a..5cf4f843 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -8,6 +8,22 @@
 
 #include <stdbool.h>
 
+struct tracecmd_time_sync {
+	pthread_t			thread;
+	bool				thread_running;
+	unsigned long long		trace_id;
+	char				*proto_name;
+	int				loop_interval;
+	pthread_mutex_t			lock;
+	pthread_cond_t			cond;
+	pthread_barrier_t		first_sync;
+	char				*clock_str;
+	struct tracecmd_msg_handle	*msg_handle;
+	void				*context;
+	int				guest_pid;
+	int				vcpu_count;
+};
+
 struct clock_sync_context {
 	void				*proto_data;	/* time sync protocol specific data */
 	bool				is_server;	/* server side time sync role */
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 8d01c0bc..0c90b413 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -8,7 +8,9 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <arpa/inet.h>
+#ifdef VSOCK
 #include <linux/vm_sockets.h>
+#endif
 #include <linux/limits.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -141,15 +143,15 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
 }
 
 /**
- * tracecmd_tsync_get_proto_flags - Get protocol flags
+ * tsync_get_proto_flags - Get protocol flags
  *
  * @tsync: Pointer to time sync context
  * @flags: Returns the protocol flags, a combination of TRACECMD_TSYNC_FLAG_...
  *
  * Retuns -1 in case of an error, or 0 otherwise
  */
-int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
-				   unsigned int *flags)
+static int tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
+				 unsigned int *flags)
 {
 	struct tsync_proto *protocol;
 
@@ -169,7 +171,7 @@ int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
 #define PROTO_MASK_SIZE (sizeof(char))
 #define PROTO_MASK_BITS (PROTO_MASK_SIZE * 8)
 /**
- * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
+ * tsync_proto_select - Select time sync protocol, to be used for
  *		timestamp synchronization with a peer
  *
  * @protos: list of tsync protocol names
@@ -180,8 +182,9 @@ int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
  *	  in case there is no match with supported protocols.
  *	  The returned string MUST NOT be freed by the caller
  */
-const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock,
-				  enum tracecmd_time_sync_role role)
+static const char *
+tsync_proto_select(const struct tracecmd_tsync_protos *protos,
+		   const char *clock, enum tracecmd_time_sync_role role)
 {
 	struct tsync_proto *selected = NULL;
 	struct tsync_proto *proto;
@@ -218,7 +221,7 @@ const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, ch
 }
 
 /**
- * tracecmd_tsync_proto_getall - Returns bitmask of all supported
+ * tracecmd_tsync_proto_getall - Returns list of all supported
  *				 time sync protocols
  * @protos: return, allocated list of time sync protocol names,
  *	       supported by the peer. Must be freed by free()
@@ -274,6 +277,110 @@ error:
 	return -1;
 }
 
+static int get_first_cpu(cpu_set_t **pin_mask, size_t *m_size)
+{
+	int cpus = tracecmd_count_cpus();
+	cpu_set_t *cpu_mask;
+	int mask_size;
+	int i;
+
+	cpu_mask = CPU_ALLOC(cpus);
+	*pin_mask = CPU_ALLOC(cpus);
+	if (!cpu_mask || !*pin_mask || 1)
+		goto error;
+
+	mask_size = CPU_ALLOC_SIZE(cpus);
+	CPU_ZERO_S(mask_size, cpu_mask);
+	CPU_ZERO_S(mask_size, *pin_mask);
+
+	if (sched_getaffinity(0, mask_size, cpu_mask) == -1)
+		goto error;
+
+	for (i = 0; i < cpus; i++) {
+		if (CPU_ISSET_S(i, mask_size, cpu_mask)) {
+			CPU_SET_S(i, mask_size, *pin_mask);
+			break;
+		}
+	}
+
+	if (CPU_COUNT_S(mask_size, *pin_mask) < 1)
+		goto error;
+
+	CPU_FREE(cpu_mask);
+	*m_size = mask_size;
+	return 0;
+
+error:
+	if (cpu_mask)
+		CPU_FREE(cpu_mask);
+	if (*pin_mask)
+		CPU_FREE(*pin_mask);
+	*pin_mask = NULL;
+	*m_size = 0;
+	return -1;
+}
+
+#ifdef VSOCK
+static int vsock_open(unsigned int cid, unsigned int port)
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
+static int vsock_make(void)
+{
+	struct sockaddr_vm addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = VMADDR_CID_ANY,
+		.svm_port = VMADDR_PORT_ANY,
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
+int vsock_get_port(int sd, unsigned int *port)
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
 static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
 			      unsigned int *rcid, unsigned int *rport)
 {
@@ -300,6 +407,31 @@ static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
 	return 0;
 }
 
+#else
+static int vsock_open(unsigned int cid, unsigned int port)
+{
+	return -ENOTSUP;
+}
+
+static int vsock_make(void)
+{
+	return -ENOTSUP;
+
+}
+
+static int vsock_get_port(int sd, unsigned int *port)
+{
+	return -ENOTSUP;
+}
+
+static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
+			      unsigned int *rcid, unsigned int *rport)
+{
+	return -ENOTSUP;
+}
+
+#endif /* VSOCK */
+
 static struct tracefs_instance *
 clock_synch_create_instance(const char *clock, unsigned int cid)
 {
@@ -403,10 +535,12 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
 	free(tsync->clock_str);
+	free(tsync->proto_name);
+	free(tsync);
 }
 
-int tracecmd_tsync_send(struct tracecmd_time_sync *tsync,
-				  struct tsync_proto *proto)
+static int tsync_send(struct tracecmd_time_sync *tsync,
+		      struct tsync_proto *proto)
 {
 	long long timestamp = 0;
 	long long scaling = 0;
@@ -418,17 +552,7 @@ int tracecmd_tsync_send(struct tracecmd_time_sync *tsync,
 	return ret;
 }
 
-/**
- * tracecmd_tsync_with_host - Synchronize timestamps with host
- *
- * @tsync: Pointer to time sync context
- *
- * This API is supposed to be called in guest context. It waits for a time
- * sync request from the host and replies with a time sample, until time sync
- * stop command is received
- *
- */
-void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
+static void tsync_with_host(struct tracecmd_time_sync *tsync)
 {
 	char protocol[TRACECMD_TSYNC_PNAME_LENGTH];
 	struct tsync_proto *proto;
@@ -447,7 +571,7 @@ void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
 		if (ret || strncmp(protocol, TRACECMD_TSYNC_PROTO_NONE, TRACECMD_TSYNC_PNAME_LENGTH) ||
 		    command != TRACECMD_TIME_SYNC_CMD_PROBE)
 			break;
-		ret = tracecmd_tsync_send(tsync, proto);
+		ret = tsync_send(tsync, proto);
 		if (ret)
 			break;
 	}
@@ -516,16 +640,7 @@ static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
 }
 
 #define CLOCK_TS_ARRAY 5
-/**
- * tracecmd_tsync_with_guest - Synchronize timestamps with guest
- *
- * @tsync: Pointer to time sync context
- *
- * This API is supposed to be called in host context, in a separate thread
- * It loops infinite, until the timesync semaphore is released
- *
- */
-void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
+static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 {
 	int ts_array_size = CLOCK_TS_ARRAY;
 	struct tsync_proto *proto;
@@ -535,7 +650,7 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 
 	clock_context_init(tsync, &proto, false);
 	if (!tsync->context)
-		return;
+		return -1;
 
 	if (tsync->loop_interval > 0 &&
 	    tsync->loop_interval < (CLOCK_TS_ARRAY * 1000))
@@ -569,4 +684,328 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 				    TRACECMD_TSYNC_PROTO_NONE,
 				    TRACECMD_TIME_SYNC_CMD_STOP,
 				    0, NULL);
+	return 0;
+}
+
+static void *tsync_host_thread(void *data)
+{
+	struct tracecmd_time_sync *tsync = NULL;
+
+	tsync = (struct tracecmd_time_sync *)data;
+	tsync_with_guest(tsync);
+	tracecmd_msg_handle_close(tsync->msg_handle);
+	tsync->msg_handle = NULL;
+
+	pthread_exit(0);
+}
+
+/**
+ * tracecmd_tsync_with_guest - Synchronize timestamps with guest
+ *
+ * @trace_id: Local ID for the current trace session
+ * @cid: CID of the guest
+ * @port: VSOCKET port, on which the guest listens for tsync requests
+ * @guest_pid: PID of the host OS process, running the guest
+ * @guest_cpus: Number of the guest VCPUs
+ * @proto_name: Name of the negotiated time synchronization protocol
+ * @clock: Trace clock, used for that session
+ *
+ * On success, a pointer to time sync context is returned, or NULL in
+ * case of an error. The context must be freed with tracecmd_tsync_free()
+ *
+ * This API spawns a pthread, which performs time stamps synchronization
+ * until tracecmd_tsync_with_guest_stop() is called.
+ */
+struct tracecmd_time_sync *
+tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
+			  unsigned int cid, unsigned int port, int guest_pid,
+			  int guest_cpus, const char *proto_name, const char *clock)
+{
+	struct tracecmd_time_sync *tsync;
+	cpu_set_t *pin_mask = NULL;
+	pthread_attr_t attrib;
+	size_t mask_size = 0;
+	int fd = -1;
+	int ret;
+
+	if (!proto_name)
+		return NULL;
+
+	tsync = calloc(1, sizeof(*tsync));
+	if (!tsync)
+		return NULL;
+
+	tsync->trace_id = trace_id;
+	tsync->loop_interval = loop_interval;
+	tsync->proto_name = strdup(proto_name);
+	fd = vsock_open(cid, port);
+	if (fd < 0)
+		goto error;
+
+	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
+	if (!tsync->msg_handle) {
+		ret = -1;
+		goto error;
+	}
+	tsync->guest_pid = guest_pid;
+	tsync->vcpu_count = guest_cpus;
+
+	if (clock)
+		tsync->clock_str = strdup(clock);
+	pthread_mutex_init(&tsync->lock, NULL);
+	pthread_cond_init(&tsync->cond, NULL);
+	pthread_attr_init(&attrib);
+	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
+
+	ret = pthread_create(&tsync->thread, &attrib, tsync_host_thread, tsync);
+	if (ret)
+		goto error;
+	tsync->thread_running = true;
+
+	if (!get_first_cpu(&pin_mask, &mask_size))
+		pthread_setaffinity_np(tsync->thread, mask_size, pin_mask);
+
+	if (pin_mask)
+		CPU_FREE(pin_mask);
+	pthread_attr_destroy(&attrib);
+
+	return tsync;
+
+error:
+	if (tsync->msg_handle)
+		tracecmd_msg_handle_close(tsync->msg_handle);
+	else if (fd >= 0)
+		close(fd);
+	free(tsync);
+
+	return NULL;
+}
+
+/**
+ * tracecmd_write_guest_time_shift - Write collected timestamp corrections in a file
+ *
+ * @handle: Handle to a trace file, where timestamp corrections will be saved
+ * @tsync: Time sync context with collected timestamp corrections
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ *
+ * This API writes collected timestamp corrections in the metadata of the
+ * trace file, as TRACECMD_OPTION_TIME_SHIFT option.
+ */
+int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
+				    struct tracecmd_time_sync *tsync)
+{
+	struct iovec vector[6];
+	unsigned int flags;
+	long long *scalings = NULL;
+	long long *offsets = NULL;
+	long long *ts = NULL;
+	int count;
+	int ret;
+
+	ret = tracecmd_tsync_get_offsets(tsync, &count,
+					 &ts, &offsets, &scalings);
+	if (ret < 0 || !count || !ts || !offsets || !scalings)
+		return -1;
+	ret = tsync_get_proto_flags(tsync, &flags);
+	if (ret < 0)
+		return -1;
+
+	vector[0].iov_len = 8;
+	vector[0].iov_base =  &(tsync->trace_id);
+	vector[1].iov_len = 4;
+	vector[1].iov_base = &flags;
+	vector[2].iov_len = 4;
+	vector[2].iov_base = &count;
+	vector[3].iov_len = 8 * count;
+	vector[3].iov_base = ts;
+	vector[4].iov_len = 8 * count;
+	vector[4].iov_base = offsets;
+	vector[5].iov_len = 8 * count;
+	vector[5].iov_base = scalings;
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 6);
+	tracecmd_append_options(handle);
+#ifdef TSYNC_DEBUG
+	if (count > 1)
+		printf("Got %d timestamp synch samples in %lld ns trace\n\r",
+			count, ts[count - 1] - ts[0]);
+#endif
+	return 0;
+}
+
+/**
+ * tracecmd_tsync_with_guest_stop - Stop the time sync session with a guest
+ *
+ * @tsync: Time sync context, representing a running time sync session
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ *
+ */
+int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync)
+{
+	if (!tsync || !tsync->thread_running)
+		return -1;
+
+	/* Signal the time synchronization thread to complete and wait for it */
+	pthread_mutex_lock(&tsync->lock);
+	pthread_cond_signal(&tsync->cond);
+	pthread_mutex_unlock(&tsync->lock);
+	pthread_join(tsync->thread, NULL);
+	return 0;
+}
+
+static void *tsync_agent_thread(void *data)
+{
+	struct tracecmd_time_sync *tsync = NULL;
+	int sd;
+
+	tsync = (struct tracecmd_time_sync *)data;
+
+	while (true) {
+		sd = accept(tsync->msg_handle->fd, NULL, NULL);
+		if (sd < 0) {
+			if (errno == EINTR)
+				continue;
+			goto out;
+		}
+		break;
+	}
+	close(tsync->msg_handle->fd);
+	tsync->msg_handle->fd = sd;
+
+	tsync_with_host(tsync);
+
+out:
+	tracecmd_msg_handle_close(tsync->msg_handle);
+	tracecmd_tsync_free(tsync);
+	free(tsync);
+	close(sd);
+
+	pthread_exit(0);
+}
+
+/**
+ * tracecmd_tsync_with_host - Synchronize timestamps with host
+ *
+ * @tsync_protos: List of tsync protocols, supported by the host
+ * @clock: Trace clock, used for that session
+ * @port: returned, VSOCKET port, on which the guest listens for tsync requests
+ *
+ * On success, a pointer to time sync context is returned, or NULL in
+ * case of an error. The context must be freed with tracecmd_tsync_free()
+ *
+ * This API spawns a pthread, which performs time stamps synchronization
+ * until tracecmd_tsync_with_host_stop() is called.
+ */
+struct tracecmd_time_sync *
+tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
+			 const char *clock)
+{
+	struct tracecmd_time_sync *tsync;
+	cpu_set_t *pin_mask = NULL;
+	pthread_attr_t attrib;
+	size_t mask_size = 0;
+	unsigned int port;
+	const char *proto;
+	int ret;
+	int fd;
+
+	tsync = calloc(1, sizeof(struct tracecmd_time_sync));
+	if (!tsync)
+		return NULL;
+
+	proto = tsync_proto_select(tsync_protos, clock,
+				   TRACECMD_TIME_SYNC_ROLE_GUEST);
+	if (!proto)
+		goto error;
+	tsync->proto_name = strdup(proto);
+	fd = vsock_make();
+	if (fd < 0)
+		goto error;
+
+	if (vsock_get_port(fd, &port) < 0)
+		goto error;
+	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
+	if (clock)
+		tsync->clock_str = strdup(clock);
+
+	pthread_attr_init(&attrib);
+	tsync->vcpu_count = tracecmd_count_cpus();
+	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
+
+	ret = pthread_create(&tsync->thread, &attrib, tsync_agent_thread, tsync);
+	if (ret) {
+		pthread_attr_destroy(&attrib);
+		goto error;
+	}
+	tsync->thread_running = true;
+	if (!get_first_cpu(&pin_mask, &mask_size))
+		pthread_setaffinity_np(tsync->thread, mask_size, pin_mask);
+
+	if (pin_mask)
+		CPU_FREE(pin_mask);
+	pthread_attr_destroy(&attrib);
+	return tsync;
+
+error:
+	if (tsync) {
+		if (tsync->msg_handle)
+			tracecmd_msg_handle_close(tsync->msg_handle);
+		else if (fd >= 0)
+			close(fd);
+		free(tsync->clock_str);
+		free(tsync);
+	}
+
+	return NULL;
+
+}
+
+/**
+ * tracecmd_tsync_with_host_stop - Stop the time sync session with a host
+ *
+ * @tsync: Time sync context, representing a running time sync session
+ *
+ * Returns 0 on success, or error number in case of an error.
+ *
+ */
+int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync)
+{
+	return pthread_join(tsync->thread, NULL);
+}
+
+/**
+ * tracecmd_tsync_get_session_params - Get parameters of established time sync session
+ *
+ * @tsync: Time sync context, representing a running time sync session
+ * @selected_proto: return, name of the selected time sync protocol for this session
+ * @tsync_port: return, a VSOCK port on which new time sync requests are accepted.
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ *
+ */
+int tracecmd_tsync_get_session_params(struct tracecmd_time_sync *tsync,
+				      char **selected_proto,
+				      unsigned int *tsync_port)
+{
+	int ret;
+
+	if (!tsync)
+		return -1;
+
+	if (tsync_port) {
+		if (!tsync->msg_handle)
+			return -1;
+		ret = vsock_get_port(tsync->msg_handle->fd, tsync_port);
+		if (ret < 0)
+			return ret;
+	}
+	if (selected_proto) {
+		if (!tsync->proto_name)
+			return -1;
+		(*selected_proto) = strdup(tsync->proto_name);
+
+	}
+
+	return 0;
 }
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 2b14284b..80c69bbb 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -36,9 +36,6 @@ TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-clear.o
 TRACE_CMD_OBJS += trace-vm.o
-ifeq ($(VSOCK_DEFINED), 1)
-TRACE_CMD_OBJS += trace-tsync.o
-endif
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 77271712..6e39d27d 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -262,9 +262,8 @@ struct buffer_instance {
 	int			*fds;
 	bool			use_fifos;
 
-	pthread_t		tsync_thread;
-	bool			tsync_thread_running;
-	struct tracecmd_time_sync tsync;
+	int			tsync_loop_interval;
+	struct tracecmd_time_sync *tsync;
 };
 
 void init_top_instance(void);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index ff4a4e11..49f6dd8c 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -143,12 +143,12 @@ static char *get_clock(int argc, char **argv)
 static void agent_handle(int sd, int nr_cpus, int page_size)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
+	struct tracecmd_time_sync *tsync = NULL;
 	struct tracecmd_msg_handle *msg_handle;
-	const char *tsync_proto = NULL;
+	char *tsync_proto = NULL;
 	unsigned long long trace_id;
 	unsigned int tsync_port = 0;
 	unsigned int *ports;
-	pthread_t sync_thr;
 	char **argv = NULL;
 	int argc = 0;
 	bool use_fifos;
@@ -176,10 +176,11 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	if (!use_fifos)
 		make_vsocks(nr_cpus, fds, ports);
 	if (tsync_protos && tsync_protos->names) {
-		tsync_proto = tracecmd_guest_tsync(tsync_protos,
-						   get_clock(argc, argv),
-						   &tsync_port, &sync_thr);
-		if (!tsync_proto)
+		tsync = tracecmd_tsync_with_host(tsync_protos,
+						 get_clock(argc, argv));
+		if (tsync)
+			tracecmd_tsync_get_session_params(tsync, &tsync_proto, &tsync_port);
+		else
 			warning("Failed to negotiate timestamps synchronization with the host");
 	}
 	trace_id = tracecmd_generate_traceid();
@@ -192,8 +193,10 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
 			   use_fifos, trace_id);
 
-	if (tsync_proto)
-		pthread_join(sync_thr, NULL);
+	if (tsync) {
+		tracecmd_tsync_with_host_stop(tsync);
+		tracecmd_tsync_free(tsync);
+	}
 
 	if (tsync_protos) {
 		free(tsync_protos->names);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e7428788..a0eb0385 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -665,7 +665,28 @@ static void delete_thread_data(void)
 	}
 }
 
-#ifdef VSOCK
+static void host_tsync_complete(struct buffer_instance *instance)
+{
+	struct tracecmd_output *handle = NULL;
+	int fd = -1;
+	int ret;
+
+	ret = tracecmd_tsync_with_guest_stop(instance->tsync);
+	if (!ret) {
+		fd = open(instance->output_file, O_RDWR);
+		if (fd < 0)
+			die("error opening %s", instance->output_file);
+		handle = tracecmd_get_output_handle_fd(fd);
+		if (!handle)
+			die("cannot create output handle");
+		tracecmd_write_guest_time_shift(handle, instance->tsync);
+		tracecmd_output_close(handle);
+	}
+
+	tracecmd_tsync_free(instance->tsync);
+	instance->tsync = NULL;
+}
+
 static void tell_guests_to_stop(void)
 {
 	struct buffer_instance *instance;
@@ -678,7 +699,7 @@ static void tell_guests_to_stop(void)
 
 	for_all_instances(instance) {
 		if (is_guest(instance))
-			tracecmd_host_tsync_complete(instance);
+			host_tsync_complete(instance);
 	}
 
 	/* Wait for guests to acknowledge */
@@ -689,11 +710,6 @@ static void tell_guests_to_stop(void)
 		}
 	}
 }
-#else
-static inline void tell_guests_to_stop(void)
-{
-}
-#endif
 
 static void stop_threads(enum trace_type type)
 {
@@ -3668,7 +3684,28 @@ static int open_guest_fifos(const char *guest, int **fds)
 	return i;
 }
 
-#ifdef VSOCK
+static int host_tsync(struct buffer_instance *instance,
+		      unsigned int tsync_port, char *proto)
+{
+	struct trace_guest *guest;
+
+	if (!proto)
+		return -1;
+	guest = get_guest_by_cid(instance->cid);
+	if (guest == NULL)
+		return -1;
+
+	instance->tsync = tracecmd_tsync_with_guest(top_instance.trace_id,
+						    instance->tsync_loop_interval,
+						    instance->cid, tsync_port,
+						    guest->pid, guest->cpu_max,
+						    proto, top_instance.clock);
+	if (!instance->tsync)
+		return -1;
+
+	return 0;
+}
+
 static void connect_to_agent(struct buffer_instance *instance)
 {
 	struct tracecmd_tsync_protos *protos = NULL;
@@ -3697,7 +3734,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 	if (!instance->clock)
 		instance->clock = tracefs_get_clock(NULL);
 
-	if (instance->tsync.loop_interval >= 0)
+	if (instance->tsync_loop_interval >= 0)
 		tracecmd_tsync_proto_getall(&protos, instance->clock,
 					    TRACECMD_TIME_SYNC_ROLE_HOST);
 
@@ -3719,11 +3756,10 @@ static void connect_to_agent(struct buffer_instance *instance)
 		die("Failed to receive trace response %d", ret);
 	if (tsync_protos_reply && tsync_protos_reply[0]) {
 		if (tsync_proto_is_supported(tsync_protos_reply)) {
-			instance->tsync.proto_name = strdup(tsync_protos_reply);
 			printf("Negotiated %s time sync protocol with guest %s\n",
-				instance->tsync.proto_name,
+				tsync_protos_reply,
 				instance->name);
-			tracecmd_host_tsync(instance, tsync_port);
+			host_tsync(instance, tsync_port, tsync_protos_reply);
 		} else
 			warning("Failed to negotiate timestamps synchronization with the guest");
 	}
@@ -3751,12 +3787,6 @@ static void connect_to_agent(struct buffer_instance *instance)
 	/* the msg_handle now points to the guest fd */
 	instance->msg_handle = msg_handle;
 }
-#else
-static inline void connect_to_agent(struct buffer_instance *instance)
-{
-}
-#endif
-
 
 static void setup_guest(struct buffer_instance *instance)
 {
@@ -6087,7 +6117,7 @@ static void parse_record_options(int argc,
 			break;
 		case OPT_tsyncinterval:
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--tsync-interval");
-			top_instance.tsync.loop_interval = atoi(optarg);
+			top_instance.tsync_loop_interval = atoi(optarg);
 			guest_sync_set = true;
 			break;
 		case OPT_fork:
@@ -6132,7 +6162,7 @@ static void parse_record_options(int argc,
 					}
 				}
 			}
-			instance->tsync.loop_interval = top_instance.tsync.loop_interval;
+			instance->tsync_loop_interval = top_instance.tsync_loop_interval;
 		}
 	}
 
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
deleted file mode 100644
index 05a4beb3..00000000
--- a/tracecmd/trace-tsync.c
+++ /dev/null
@@ -1,294 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
- *
- */
-#include <stdlib.h>
-#include <errno.h>
-#include <fcntl.h>
-#include <sys/socket.h>
-#include <unistd.h>
-#include <linux/vm_sockets.h>
-#include <pthread.h>
-
-#include "tracefs.h"
-#include "trace-local.h"
-#include "trace-msg.h"
-
-static int get_first_cpu(cpu_set_t **pin_mask, size_t *m_size)
-{
-	int cpus = tracecmd_count_cpus();
-	cpu_set_t *cpu_mask;
-	int mask_size;
-	int i;
-
-	cpu_mask = CPU_ALLOC(cpus);
-	*pin_mask = CPU_ALLOC(cpus);
-	if (!cpu_mask || !*pin_mask || 1)
-		goto error;
-
-	mask_size = CPU_ALLOC_SIZE(cpus);
-	CPU_ZERO_S(mask_size, cpu_mask);
-	CPU_ZERO_S(mask_size, *pin_mask);
-
-	if (sched_getaffinity(0, mask_size, cpu_mask) == -1)
-		goto error;
-
-	for (i = 0; i < cpus; i++) {
-		if (CPU_ISSET_S(i, mask_size, cpu_mask)) {
-			CPU_SET_S(i, mask_size, *pin_mask);
-			break;
-		}
-	}
-
-	if (CPU_COUNT_S(mask_size, *pin_mask) < 1)
-		goto error;
-
-	CPU_FREE(cpu_mask);
-	*m_size = mask_size;
-	return 0;
-
-error:
-	if (cpu_mask)
-		CPU_FREE(cpu_mask);
-	if (*pin_mask)
-		CPU_FREE(*pin_mask);
-	*pin_mask = NULL;
-	*m_size = 0;
-	return -1;
-}
-
-static void *tsync_host_thread(void *data)
-{
-	struct tracecmd_time_sync *tsync = NULL;
-
-	tsync = (struct tracecmd_time_sync *)data;
-
-	tracecmd_tsync_with_guest(tsync);
-
-	tracecmd_msg_handle_close(tsync->msg_handle);
-	tsync->msg_handle = NULL;
-
-	pthread_exit(0);
-}
-
-int tracecmd_host_tsync(struct buffer_instance *instance,
-			 unsigned int tsync_port)
-{
-	struct tracecmd_msg_handle *msg_handle = NULL;
-	cpu_set_t *pin_mask = NULL;
-	struct trace_guest *guest;
-	pthread_attr_t attrib;
-	size_t mask_size = 0;
-	int ret;
-	int fd;
-
-	if (!instance->tsync.proto_name)
-		return -1;
-	guest = get_guest_by_cid(instance->cid);
-	if (guest == NULL)
-		return -1;
-	instance->tsync.guest_pid = guest->pid;
-	instance->tsync.vcpu_count = guest->cpu_max;
-	fd = trace_open_vsock(instance->cid, tsync_port);
-	if (fd < 0) {
-		ret = -1;
-		goto out;
-	}
-	msg_handle = tracecmd_msg_handle_alloc(fd, 0);
-	if (!msg_handle) {
-		ret = -1;
-		goto out;
-	}
-
-	instance->tsync.msg_handle = msg_handle;
-	if (top_instance.clock)
-		instance->tsync.clock_str = strdup(top_instance.clock);
-	pthread_mutex_init(&instance->tsync.lock, NULL);
-	pthread_cond_init(&instance->tsync.cond, NULL);
-
-	pthread_attr_init(&attrib);
-	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
-
-	ret = pthread_create(&instance->tsync_thread, &attrib,
-			     tsync_host_thread, &instance->tsync);
-
-	if (!ret) {
-		if (!get_first_cpu(&pin_mask, &mask_size))
-			pthread_setaffinity_np(instance->tsync_thread, mask_size, pin_mask);
-		instance->tsync_thread_running = true;
-	}
-
-	if (pin_mask)
-		CPU_FREE(pin_mask);
-	pthread_attr_destroy(&attrib);
-
-out:
-	if (ret) {
-		if (msg_handle)
-			tracecmd_msg_handle_close(msg_handle);
-	}
-
-	return ret;
-}
-
-static void write_guest_time_shift(struct buffer_instance *instance)
-{
-	struct tracecmd_output *handle;
-	struct iovec vector[6];
-	unsigned int flags;
-	long long *scalings = NULL;
-	long long *offsets = NULL;
-	long long *ts = NULL;
-	const char *file;
-	int count;
-	int ret;
-	int fd;
-
-	ret = tracecmd_tsync_get_offsets(&instance->tsync, &count,
-					 &ts, &offsets, &scalings);
-	if (ret < 0 || !count || !ts || !offsets || !scalings)
-		return;
-	ret = tracecmd_tsync_get_proto_flags(&instance->tsync, &flags);
-	if (ret < 0)
-		return;
-
-	file = instance->output_file;
-	fd = open(file, O_RDWR);
-	if (fd < 0)
-		die("error opening %s", file);
-	handle = tracecmd_get_output_handle_fd(fd);
-	vector[0].iov_len = 8;
-	vector[0].iov_base = &top_instance.trace_id;
-	vector[1].iov_len = 4;
-	vector[1].iov_base = &flags;
-	vector[2].iov_len = 4;
-	vector[2].iov_base = &count;
-	vector[3].iov_len = 8 * count;
-	vector[3].iov_base = ts;
-	vector[4].iov_len = 8 * count;
-	vector[4].iov_base = offsets;
-	vector[5].iov_len = 8 * count;
-	vector[5].iov_base = scalings;
-	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 6);
-	tracecmd_append_options(handle);
-	tracecmd_output_close(handle);
-#ifdef TSYNC_DEBUG
-	if (count > 1)
-		printf("Got %d timestamp synch samples for guest %s in %lld ns trace\n\r",
-			count, tracefs_instance_get_name(instance->tracefs),
-			ts[count - 1] - ts[0]);
-#endif
-}
-
-void tracecmd_host_tsync_complete(struct buffer_instance *instance)
-{
-	if (!instance->tsync_thread_running)
-		return;
-
-	/* Signal the time synchronization thread to complete and wait for it */
-	pthread_mutex_lock(&instance->tsync.lock);
-	pthread_cond_signal(&instance->tsync.cond);
-	pthread_mutex_unlock(&instance->tsync.lock);
-	pthread_join(instance->tsync_thread, NULL);
-	write_guest_time_shift(instance);
-	tracecmd_tsync_free(&instance->tsync);
-}
-
-static void *tsync_agent_thread(void *data)
-{
-	struct tracecmd_time_sync *tsync = NULL;
-	int sd;
-
-	tsync = (struct tracecmd_time_sync *)data;
-
-	while (true) {
-		sd = accept(tsync->msg_handle->fd, NULL, NULL);
-		if (sd < 0) {
-			if (errno == EINTR)
-				continue;
-			goto out;
-		}
-		break;
-	}
-	close(tsync->msg_handle->fd);
-	tsync->msg_handle->fd = sd;
-
-	tracecmd_tsync_with_host(tsync);
-
-out:
-	tracecmd_msg_handle_close(tsync->msg_handle);
-	tracecmd_tsync_free(tsync);
-	free(tsync);
-	close(sd);
-
-	pthread_exit(0);
-}
-
-const char *tracecmd_guest_tsync(struct tracecmd_tsync_protos *tsync_protos,
-				 char *clock, unsigned int *tsync_port,
-				 pthread_t *thr_id)
-{
-	struct tracecmd_time_sync *tsync = NULL;
-	cpu_set_t *pin_mask = NULL;
-	pthread_attr_t attrib;
-	size_t mask_size = 0;
-	const char *proto;
-	int ret;
-	int fd;
-
-	fd = -1;
-	proto = tracecmd_tsync_proto_select(tsync_protos, clock,
-					    TRACECMD_TIME_SYNC_ROLE_GUEST);
-	if (!proto)
-		return NULL;
-#ifdef VSOCK
-	fd = trace_make_vsock(VMADDR_PORT_ANY);
-	if (fd < 0)
-		goto error;
-
-	ret = trace_get_vsock_port(fd, tsync_port);
-	if (ret < 0)
-		goto error;
-#else
-	return NULL;
-#endif
-
-	tsync = calloc(1, sizeof(struct tracecmd_time_sync));
-	if (!tsync)
-		goto error;
-	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
-	if (clock)
-		tsync->clock_str = strdup(clock);
-
-	pthread_attr_init(&attrib);
-	tsync->proto_name = proto;
-	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
-
-	ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
-
-	if (!ret) {
-		if (!get_first_cpu(&pin_mask, &mask_size))
-			pthread_setaffinity_np(*thr_id, mask_size, pin_mask);
-	}
-
-	if (pin_mask)
-		CPU_FREE(pin_mask);
-	pthread_attr_destroy(&attrib);
-
-	if (ret)
-		goto error;
-
-	return proto;
-
-error:
-	if (tsync) {
-		if (tsync->msg_handle)
-			tracecmd_msg_handle_close(tsync->msg_handle);
-		free(tsync->clock_str);
-		free(tsync);
-	}
-	if (fd > 0)
-		close(fd);
-	return NULL;
-}
-- 
2.29.2

