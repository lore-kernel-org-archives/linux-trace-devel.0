Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD564C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 May 2022 01:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244854AbiEDBGV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 May 2022 21:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244837AbiEDBGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 May 2022 21:06:20 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57F51408A
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 May 2022 18:02:45 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id g12-20020a170902740c00b0015d243ff163so6248pll.19
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 May 2022 18:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ugv1BkgrDi+w3dJKQiSRQnWG1npPpuaxDJHOIWU7qFw=;
        b=N5zcZYUANHm6K39MgOgZ6Hlaka0ROvt15wRhpfNsORjlYo47UkigWjasNkjPsa1GOA
         NwA21e5L2Nvq+tT45HkGrHb9+xU9v+RLkA3/+IemRJ1WfclcECzAGLyMOVPC4dSTxjYL
         2hsGPg04neRtj3xPWSNFICjJT/0e3O8V37F4oShyK3eyBWvgiUfrKX/j6KAnR6wFY0t8
         bVvwzTLbYwXsczJAPzHOgBJyj8nAtSGTNY+kPk4GJfZoUSdoNykzz+5TTpN7VNyzhsIW
         YEafSmVnb3bpq8r78d1bVaUq++c3k822EqsbdlPyaliYMnU61TdszwwMYEPXY7ehHT+T
         AS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ugv1BkgrDi+w3dJKQiSRQnWG1npPpuaxDJHOIWU7qFw=;
        b=Zsjyo5Ufa5kWbWGDbW9//PJmWRC34uKMPBQnbuB+K/TU9s+ztsiNyA1e1NYcl+FNAw
         cM6fYlI8P0cXVNJCq5qG2MG/E41SPjZNjKmDUd0pCSPFirvBRZdxuSdxKekcHzEPR/ab
         tSt28oFt3zZWQjD8fE+ZcoqFwt6FtX+dPe78/xTs0dTmu6FYn1XKvR4rSrKObuy+fAvK
         rmat+ertJcz9gNjDh1EsDgA45uBeoYYFR58c9+pTMvJOK/vuqmeeDxllwpVRJ8Yk2Sj3
         caj+NTiFXNrj5QR5DARla+USMsZRX3YzNNlHAnmkrnbVT4a1NadMg9/qxCmZxFLPwQAQ
         Iuag==
X-Gm-Message-State: AOAM532BFiPIYSXqamYRnqEsuYDscRAVdL56AYW6A7LsAi6piXwHsPSH
        J5cAdTthkmPRDx8IHrLVRxYBW9xvaN2Icms8L4G4WHyffBBcCTekDw97eQ342NQ44yWnU3gP0x0
        DqPV0Uz56ar1GI5k8WNaKyRXMrmb0r8HMBfjdd0e+yhbrMsTB57LUQ4xx0n9Dtm+4BbspfkPM3Y
        /vfxuTWrrI
X-Google-Smtp-Source: ABdhPJz27KrC6Lx+4pBrDrOdKVoDS9fZA5Dw5mgrNqTitJQWSqS8sYA7m9aBxIKgDbHSeJhDWIvULd45pnfqit4=
X-Received: from gvindev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4e90])
 (user=vineethrp job=sendgmr) by 2002:aa7:9557:0:b0:50d:b868:4798 with SMTP id
 w23-20020aa79557000000b0050db8684798mr19018621pfq.84.1651626165231; Tue, 03
 May 2022 18:02:45 -0700 (PDT)
Date:   Wed,  4 May 2022 01:02:42 +0000
Message-Id: <20220504010242.1388192-1-vineethrp@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH] trace-cmd: rework of the pid detection of vcpus
From:   Vineeth Pillai <vineethrp@google.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Vineeth Pillai <vineethrp@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current detection of vcpu pid is based on the assumption that vcpuid
is monotonically increasing starting from 0 to max_cpus - 1. But the
crosvm uses the apic id as the vcpuid if topology is exposed to the
guest. And apicid can be non-contiguous.

This patch gets the max apicid from guest and then uses it to detect the
vcpu pids. Even this approach is not fool proof an it assumes that
apicid monotonically increases. If we encounter a scenario where it is
not the case, we might need to implement a mechanism to get a map of
cpuid to vcpu from the guest and then use that to detect the pid.

Signed-off-by: Vineeth Pillai <vineethrp@google.com>
---
 .../include/private/trace-cmd-private.h       |  5 +-
 lib/trace-cmd/trace-msg.c                     | 12 ++--
 lib/trace-cmd/trace-util.c                    | 49 ++++++++++++--
 tracecmd/include/trace-local.h                |  1 +
 tracecmd/trace-agent.c                        | 11 ++--
 tracecmd/trace-record.c                       | 65 +++++++++++--------
 6 files changed, 98 insertions(+), 45 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 766e0a7..49612b9 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -434,12 +434,12 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 				struct tracecmd_tsync_protos **protos);
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
-				 int nr_cpus, int page_size,
+				 int nr_cpus, int max_apicid, int page_size,
 				 unsigned int *ports, bool use_fifos,
 				 unsigned long long trace_id,
 				 const char *tsync_proto, unsigned int tsync_port);
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
-				 int *nr_cpus, int *page_size,
+				 int *nr_cpus, int *max_apicid, int *page_size,
 				 unsigned int **ports, bool *use_fifos,
 				 unsigned long long *trace_id,
 				 char **tsync_proto,
@@ -595,6 +595,7 @@ int tracecmd_set_logfile(char *logfile);
 /* --- System --- */
 unsigned long long tracecmd_generate_traceid(void);
 int tracecmd_count_cpus(void);
+int tracecmd_count_cpus_apicid(int *max_apicid);
 
 /* --- Hack! --- */
 int tracecmd_blk_hack(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 39465ad..1bb56a0 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -73,6 +73,7 @@ struct tracecmd_msg_trace_req {
 struct tracecmd_msg_trace_resp {
 	be32 flags;
 	be32 cpus;
+	be32 max_apicid;
 	be32 page_size;
 	u64 trace_id;
 	char tsync_proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
@@ -1295,7 +1296,8 @@ out:
 	return ret;
 }
 
-static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
+static int make_trace_resp(struct tracecmd_msg *msg, int page_size,
+			   int nr_cpus, int max_apicid,
 			   unsigned int *ports, bool use_fifos,
 			   unsigned long long trace_id,
 			   const char *tsync_proto,
@@ -1319,6 +1321,7 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 	msg->trace_resp.tsync_port = htonl(tsync_port);
 
 	msg->trace_resp.cpus = htonl(nr_cpus);
+	msg->trace_resp.max_apicid = htonl(max_apicid);
 	msg->trace_resp.page_size = htonl(page_size);
 	msg->trace_resp.trace_id = htonll(trace_id);
 
@@ -1326,7 +1329,7 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 }
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
-				 int nr_cpus, int page_size,
+				 int nr_cpus, int max_apicid, int page_size,
 				 unsigned int *ports, bool use_fifos,
 				 unsigned long long trace_id,
 				 const char *tsync_proto, unsigned int tsync_port)
@@ -1335,7 +1338,7 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
-	ret = make_trace_resp(&msg, page_size, nr_cpus, ports,
+	ret = make_trace_resp(&msg, page_size, nr_cpus, max_apicid, ports,
 			      use_fifos, trace_id, tsync_proto, tsync_port);
 	if (ret < 0)
 		return ret;
@@ -1344,7 +1347,7 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 }
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
-				 int *nr_cpus, int *page_size,
+				 int *nr_cpus, int *max_apicid, int *page_size,
 				 unsigned int **ports, bool *use_fifos,
 				 unsigned long long *trace_id,
 				 char **tsync_proto,
@@ -1371,6 +1374,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	}
 
 	*use_fifos = ntohl(msg.trace_resp.flags) & MSG_TRACE_USE_FIFOS;
+	*max_apicid = ntohl(msg.trace_resp.max_apicid);
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
 	*trace_id = ntohll(msg.trace_resp.trace_id);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 9564c81..08cf978 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -550,6 +550,18 @@ int tracecmd_stack_tracer_status(int *status)
  * Returns the number of CPUs in the system, or 0 in case of an error
  */
 int tracecmd_count_cpus(void)
+{
+	return tracecmd_count_cpus_apicid(NULL);
+}
+
+/**
+ * tracecmd_count_cpus_apicid - Get the number of CPUs in the system
+ * @max_apicid: if not NULL, returns the max apicid in the system.
+ *
+ * Returns the number of CPUs in the system and optionally max apicid,
+ * or 0 in case of an error
+ */
+int tracecmd_count_cpus_apicid(int *max_apicid)
 {
 	static int once;
 	char buf[1024];
@@ -560,16 +572,22 @@ int tracecmd_count_cpus(void)
 	size_t n;
 	int r;
 
-	cpus = sysconf(_SC_NPROCESSORS_CONF);
-	if (cpus > 0)
-		return cpus;
+	if (!max_apicid) {
+		cpus = sysconf(_SC_NPROCESSORS_CONF);
+		if (cpus > 0)
+			return cpus;
 
-	if (!once) {
-		once++;
-		tracecmd_warning("sysconf could not determine number of CPUS");
+		if (!once) {
+			once++;
+			tracecmd_warning("sysconf could not determine number of CPUS");
+		}
 	}
 
-	/* Do the hack to figure out # of CPUS */
+	/*
+	 * We reach here if we need to return max apicid or if
+	 * _SC_NPROCESSORS_CONF failed.
+	 */
+	*max_apicid = 0;
 	n = 1024;
 	pn = &n;
 	pbuf = buf;
@@ -583,6 +601,23 @@ int tracecmd_count_cpus(void)
 	while ((r = getline(&pbuf, pn, fp)) >= 0) {
 		char *p;
 
+		if (max_apicid && strncmp(buf, "apicid", 6) == 0) {
+			for (p = buf+6; isspace(*p); p++)
+				;
+			if (*p == ':') {
+				int apicid;
+				for (p = p+1; isspace(*p); p++)
+					;
+				apicid = strtol(p, NULL, 0);
+				if (errno != 0) {
+					tracecmd_warning("max apicid could not be read!");
+				} else if (*max_apicid < apicid) {
+					*max_apicid = apicid;
+				}
+			}
+			continue;
+		}
+
 		if (strncmp(buf, "processor", 9) != 0)
 			continue;
 		for (p = buf+9; isspace(*p); p++)
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index e3fec13..13064db 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -278,6 +278,7 @@ struct buffer_instance {
 	int			tracing_on_fd;
 	int			buffer_size;
 	int			cpu_count;
+	int			max_apicid;
 
 	int			argc;
 	char			**argv;
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index f0723a6..81d57ec 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -122,7 +122,8 @@ static void trace_print_connection(int fd, const char *network)
 		tracecmd_debug("Could not print connection fd:%d\n", fd);
 }
 
-static void agent_handle(int sd, int nr_cpus, int page_size, const char *network)
+static void agent_handle(int sd, int nr_cpus, int max_apicid,
+			 int page_size, const char *network)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
 	struct tracecmd_time_sync *tsync = NULL;
@@ -197,7 +198,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size, const char *network
 		}
 	}
 	trace_id = tracecmd_generate_traceid();
-	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
+	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, max_apicid, page_size,
 					   ports, use_fifos, trace_id,
 					   tsync_proto, tsync_port);
 	if (ret < 0)
@@ -255,7 +256,7 @@ static void agent_serve(unsigned int port, bool do_daemon, const char *network)
 	struct sockaddr *addr = NULL;
 	socklen_t *addr_len_p = NULL;
 	socklen_t addr_len = sizeof(net_addr);
-	int sd, cd, nr_cpus;
+	int sd, cd, nr_cpus, max_apicid;
 	unsigned int cid;
 	pid_t pid;
 
@@ -266,7 +267,7 @@ static void agent_serve(unsigned int port, bool do_daemon, const char *network)
 		addr_len_p = &addr_len;
 	}
 
-	nr_cpus = tracecmd_count_cpus();
+	nr_cpus = tracecmd_count_cpus_apicid(&max_apicid);
 	page_size = getpagesize();
 
 	if (network) {
@@ -311,7 +312,7 @@ static void agent_serve(unsigned int port, bool do_daemon, const char *network)
 		if (pid == 0) {
 			close(sd);
 			signal(SIGCHLD, SIG_DFL);
-			agent_handle(cd, nr_cpus, page_size, network);
+			agent_handle(cd, nr_cpus, max_apicid, page_size, network);
 		}
 		if (pid > 0)
 			handler_pid = pid;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 27c4e7b..6a680b5 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3865,7 +3865,9 @@ struct trace_mapping {
 	struct tep_format_field		*common_pid;
 	int				*pids;
 	int				*map;
+	int				nr_cpus;
 	int				max_cpus;
+	int				max_apicid;
 };
 
 static void start_mapping_vcpus(struct trace_guest *guest)
@@ -3937,22 +3939,18 @@ static int map_vcpus(struct tep_event *event, struct tep_record *record,
 	cpu = (int)val;
 
 	/* Sanity check, warn? */
-	if (cpu >= tmap->max_cpus)
+	if (cpu > tmap->max_apicid)
 		return 0;
 
 	/* Already have this one? Should we check if it is the same? */
-	if (tmap->map[cpu] >= 0)
+	if (tmap->map[cpu] > 0)
 		return 0;
 
 	tmap->map[cpu] = pid;
+	tmap->nr_cpus++;
 
 	/* Did we get them all */
-	for (i = 0; i < tmap->max_cpus; i++) {
-		if (tmap->map[i] < 0)
-			break;
-	}
-
-	return i == tmap->max_cpus;
+	return tmap->nr_cpus == tmap->max_cpus;
 }
 
 static void stop_mapping_vcpus(struct buffer_instance *instance,
@@ -3961,21 +3959,19 @@ static void stop_mapping_vcpus(struct buffer_instance *instance,
 	struct trace_mapping tmap = { };
 	struct tep_handle *tep;
 	const char *systems[] = { "kvm", NULL };
-	int i;
 
 	if (!guest->instance)
 		return;
 
 	tmap.pids = guest->task_pids;
+	tmap.nr_cpus = 0;
 	tmap.max_cpus = instance->cpu_count;
+	tmap.max_apicid = instance->max_apicid;
 
-	tmap.map = malloc(sizeof(*tmap.map) * tmap.max_cpus);
+	tmap.map = calloc((tmap.max_apicid + 1), sizeof(*tmap.map));
 	if (!tmap.map)
 		return;
 
-	for (i = 0; i < tmap.max_cpus; i++)
-		tmap.map[i] = -1;
-
 	tracefs_instance_file_write(guest->instance, "events/kvm/kvm_entry/enable", "0");
 
 	tep = tracefs_local_events_system(NULL, systems);
@@ -3996,17 +3992,25 @@ static void stop_mapping_vcpus(struct buffer_instance *instance,
 
 	tracefs_iterate_raw_events(tep, guest->instance, NULL, 0, map_vcpus, &tmap);
 
-	for (i = 0; i < tmap.max_cpus; i++) {
-		if (tmap.map[i] < 0)
-			break;
-	}
-	/* We found all the mapped CPUs */
-	if (i == tmap.max_cpus) {
-		guest->cpu_pid = tmap.map;
-		guest->cpu_max = tmap.max_cpus;
-		tmap.map = NULL;
+	if (tmap.max_apicid > tmap.max_cpus) {
+		int *map = calloc(tmap.max_cpus, sizeof(int));
+		int j = 0;
+		for (int i = 0; i <= tmap.max_apicid; i++) {
+			if (tmap.map[i] == 0)
+				continue;
+			map[j++] = tmap.map[i];
+			/* We found all the mapped CPUs */
+			if (j >= tmap.max_cpus)
+				break;
+		}
+		free(tmap.map);
+		tmap.map = map;
 	}
 
+	guest->cpu_pid = tmap.map;
+	guest->cpu_max = tmap.max_cpus;
+	tmap.map = NULL;
+
  out_free:
 	tep_free(tep);
  out:
@@ -4057,7 +4061,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 			     struct buffer_instance *instance)
 {
 	struct tracecmd_tsync_protos *protos = NULL;
-	int sd, ret, nr_fifos, nr_cpus, page_size;
+	int sd, ret, nr_fifos, nr_cpus, max_apicid, page_size;
 	struct tracecmd_msg_handle *msg_handle;
 	enum tracecmd_time_sync_role role;
 	char *tsync_protos_reply = NULL;
@@ -4105,18 +4109,26 @@ static void connect_to_agent(struct common_record_context *ctx,
 		free(protos->names);
 		free(protos);
 	}
-	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size,
+	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &max_apicid, &page_size,
 					   &ports, &use_fifos,
 					   &instance->trace_id,
 					   &tsync_protos_reply, &tsync_port);
 	if (ret < 0)
 		die("Failed to receive trace response %d", ret);
+
+	/*
+	 * This shouldn't happen, but if max apicid was wrong/zero for some reason
+	 * reset it to max cpus.
+	 */
+	if (max_apicid < nr_cpus)
+		max_apicid = nr_cpus;
+	instance->max_apicid = max_apicid;
+	instance->cpu_count = nr_cpus;
 	if (tsync_protos_reply && tsync_protos_reply[0]) {
 		if (tsync_proto_is_supported(tsync_protos_reply)) {
 			printf("Negotiated %s time sync protocol with guest %s\n",
 				tsync_protos_reply,
 				instance->name);
-			instance->cpu_count = nr_cpus;
 			host_tsync(ctx, instance, tsync_port, tsync_protos_reply);
 		} else
 			warning("Failed to negotiate timestamps synchronization with the guest");
@@ -4128,7 +4140,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 			warning("number of FIFOs (%d) for guest %s differs "
 				"from number of virtual CPUs (%d)",
 				nr_fifos, instance->name, nr_cpus);
-			nr_cpus = nr_cpus < nr_fifos ? nr_cpus : nr_fifos;
+			instance->cpu_count = nr_cpus < nr_fifos ? nr_cpus : nr_fifos;
 		}
 		free(ports);
 		instance->fds = fds;
@@ -4140,7 +4152,6 @@ static void connect_to_agent(struct common_record_context *ctx,
 	}
 
 	instance->use_fifos = use_fifos;
-	instance->cpu_count = nr_cpus;
 
 	/* the msg_handle now points to the guest fd */
 	instance->msg_handle = msg_handle;
-- 
2.36.0.464.gb9c8b46e94-goog

