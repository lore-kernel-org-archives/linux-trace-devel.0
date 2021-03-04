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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CA0C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 13:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971F660200
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 13:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbhCDNMU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241163AbhCDNL6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 08:11:58 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BF8C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Mar 2021 05:11:17 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id h7so325125wmf.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Mar 2021 05:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zXHvXDCaWaSaSXYu10vHCEICMeMyo8iXkUiBzfK909o=;
        b=rs18Sui5rIP1W8S/Drcc2r2Ca6Z3XgxXPYC80L2Q7Mu+WpI9pysufaasQckwLlX1sU
         CRNMJzKh/nRK5KISPSOIXr/Q7aRM28PAmOMO34mbW6pdAlREWtVEVN8kR5VViQKoyGqv
         1xUUddr53DE5DDILMvnXUfx7DAOFrnLlQwLa9sg1NpqJhiy+2x86d9GkJ4S1vGUm9GNy
         v3cvTjd5OYsPOiaNSFbXFpqYqSEYYymnkmEL5VD6FBoThWs9HhqW2BYOkbCK3HFljVea
         J3tDr+8HdDT+uoYAE6CeUY3Six90ebHVrCIzYSO2ltf5t/Sp1HVMsLZ4S+xEQd+v51SR
         Ticw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zXHvXDCaWaSaSXYu10vHCEICMeMyo8iXkUiBzfK909o=;
        b=uCAdGtvZSwaVJekiYayqHwqgygz5FUOEyeiII24ZSZh/RLfUBVjBHrYs9BPktQWFpC
         rX2Kxx59DzYlwoqEs8bwe49T0zc6dFqDFsxV9m8YbtfUyC4xOxIxDYwGYMYvBIdO6vNG
         XBoSG1ZYSfA4lye8rVITkspgD7ECIt7G7oaos8lTbNVdv57ebdFolOQvK3qyw6jW5ZGe
         POftbeyBIXxoWVirVUVXEl0Q3KMQtdDRHmJOn50YJJ45F6ZePBEFFMVXrS7XAKD25Yw2
         wlElZsQcGpi1IRtc9roG+cOVzib8oLzYcit1we7RwqjjIEQ8k/Yhaeb5MqM7bIO+Hy4M
         JyOA==
X-Gm-Message-State: AOAM531C1uMUChOuEKFhVmx5Ub3ApuIQcHc0oZrdcGn1JJcJ1clYS+m3
        VyECaYwYdCv/jP27m6IrUSPy+WE3G6U6cw==
X-Google-Smtp-Source: ABdhPJxb443RBEwIuq2LUms5aCl1xjYFBFyBC66xziPgQ+9btB69k5wL84h6E6IEem8TZBbdfC4D5A==
X-Received: by 2002:a05:600c:204f:: with SMTP id p15mr3903416wmg.165.1614863476462;
        Thu, 04 Mar 2021 05:11:16 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f16sm35250546wrt.21.2021.03.04.05.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 05:11:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Remove APIs for pairing a tracing peer.
Date:   Thu,  4 Mar 2021 15:11:12 +0200
Message-Id: <20210304131112.204294-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210304131112.204294-1-tz.stoyanov@gmail.com>
References: <20210304131112.204294-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In host-guests tracing context, tracing peers are all machines which are
being traced at the same time, as part of a single tracing session. The
logic for matching and pairing tracing peers from the same session, when
opening trace files, is used to take decision whether to apply time
stamps correction on the tracing events, in order to be in the same time
space. As there is a change in that behaviour - now these corrections
are applied by default, there is no need for pairing logic. These APIs
are removed:
 tracecmd_pair_peer()
 tracecmd_unpair_peer()
Note that the peer information is still saved in the file metadata.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtracecmd/libtracecmd-peer.3.txt        | 32 +-----
 Documentation/libtracecmd/libtracecmd.3.txt   |  2 -
 include/trace-cmd/trace-cmd.h                 |  3 -
 .../include/private/trace-cmd-private.h       |  1 -
 lib/trace-cmd/trace-input.c                   | 98 -------------------
 5 files changed, 1 insertion(+), 135 deletions(-)

diff --git a/Documentation/libtracecmd/libtracecmd-peer.3.txt b/Documentation/libtracecmd/libtracecmd-peer.3.txt
index 6cf34f9b..2e3232c6 100644
--- a/Documentation/libtracecmd/libtracecmd-peer.3.txt
+++ b/Documentation/libtracecmd/libtracecmd-peer.3.txt
@@ -3,8 +3,7 @@ libtracecmd(3)
 
 NAME
 ----
-tracecmd_pair_peer, tracecmd_unpair_peer, tracecmd_get_traceid,
-tracecmd_get_guest_cpumap - Manage trace session with multiple trace peers,
+tracecmd_get_traceid, tracecmd_get_guest_cpumap - Manage trace session with multiple trace peers,
 recorded in multiple trace files.
 
 SYNOPSIS
@@ -13,8 +12,6 @@ SYNOPSIS
 --
 *#include <trace-cmd.h>*
 
-int *tracecmd_pair_peer*(struct tracecmd_input pass:[*]_handle_, struct tracecmd_input pass:[*]_peer_);
-void *tracecmd_unpair_peer*(struct tracecmd_input pass:[*]_handle_);
 unsigned long long *tracecmd_get_traceid*(struct tracecmd_input pass:[*]_handle_);
 int *tracecmd_get_guest_cpumap*(struct tracecmd_input pass:[*]_handle_, unsigned long long _trace_id_, const char pass:[*]pass:[*]_name_, int pass:[*]_vcpu_count_, const int pass:[*]pass:[*]_cpu_pid_);
 --
@@ -28,15 +25,6 @@ Information about peers from the session is stored in the metadata of each
 trace file. These APIs use that information to extract and synchronize
 the trace data.
 
-The _tracecmd_pair_peer()_ function pairs two tracecmd_input handlers,
-associated with two trace files from the same trace session. This API must
-be called before _tracecmd_init_data()(3)_, as the initialisation of
-the trace data depends on that. If there is a tracing peer, the event
-timestamps are recalculated in order to be in the same time space.
-
-The _tracecmd_unpair_peer()_ function unpairs a peer from _handle_
-previously paired with _tracecmd_pair_peer()_.
-
 The _tracecmd_get_traceid()_ function returns the trace ID stored in
 the trace file metadata associated with _handle_. Each peer from a trace
 session has an ID unique for that peer and that trace session only.
@@ -59,9 +47,6 @@ The _name_, _vcpu_count_ and _cpu_pid_ values must *not* be freed.
 
 RETURN VALUE
 ------------
-The _tracecmd_pair_peer()_ function returns 1, if a peer is already
-paired, -1 in case of an error or 0 if it successfully paired the peers.
-
 The _tracecmd_get_traceid()_ function returns a 64 bit trace ID.
 
 The _tracecmd_get_guest_cpumap()_ function returns -1 in case of
@@ -90,7 +75,6 @@ struct tracecmd_input *guest2 = tracecmd_open_head("trace-Guest2.dat");
 
 unsigned long long guest_id_1 = tracecmd_get_traceid(guest1);
 unsigned long long guest_id_2 = tracecmd_get_traceid(guest2);
-bool g1 = false, g2 = false;
 int *cpu_pid_1, *cpu_pid_2;
 int vcount_1, vcount_2;
 char *name_1, *name_2;
@@ -99,27 +83,13 @@ char *name_1, *name_2;
 		/* The Host and a guest1 with name_1 are part of the same trace session.
 		 * Got guest1 VCPU to host PID mapping.
 		 */
-		if (!tracecmd_pair_peer(guest1, host)) {
-			/* Successfully paired guest1 to the host handler */
-			tracecmd_init_data(guest1);
-			g1 = true;
-		}
 	}
 	if (!tracecmd_get_guest_cpumap(host, guest_id_2, &name_2, &vcount_2, &cpu_pid_2)) {
 		/* The Host and a guest2 with name_2 are part of the same trace session.
 		 * Got guest2 VCPU to host PID mapping.
 		 */
-		if (!tracecmd_pair_peer(guest2, host)) {
-			/* Successfully paired guest2 to the host handler */
-			tracecmd_init_data(guest2);
-			g2 = true;
-		}
 	}
 ...
-	if (g1)
-		tracecmd_unpair_peer(guest1);
-	if (g2)
-		tracecmd_unpair_peer(guest2);
 	tracecmd_close(guest1);
 	tracecmd_close(guest2);
 	tracecmd_close(handle);
diff --git a/Documentation/libtracecmd/libtracecmd.3.txt b/Documentation/libtracecmd/libtracecmd.3.txt
index 7431c2ce..adc9321c 100644
--- a/Documentation/libtracecmd/libtracecmd.3.txt
+++ b/Documentation/libtracecmd/libtracecmd.3.txt
@@ -31,8 +31,6 @@ Read tracing instances from a trace file:
 	struct tracecmd_input pass:[*]*tracecmd_buffer_instance_handle*(struct tracecmd_input pass:[*]_handle_, int _indx_);
 
 Get traceing peer information from a trace file:
-	int *tracecmd_pair_peer*(struct tracecmd_input pass:[*]_handle_, struct tracecmd_input pass:[*]_peer_);
-	void tracecmd_unpair_peer(struct tracecmd_input pass:[*]handle);
 	unsigned long long *tracecmd_get_traceid*(struct tracecmd_input pass:[*]_handle_);
 	int *tracecmd_get_guest_cpumap*(struct tracecmd_input pass:[*]_handle_, unsigned long long _trace_id_, const char pass:[*]pass:[*]_name_, int pass:[*]_vcpu_count_, const int pass:[*]pass:[*]_cpu_pid_);
 --
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 65ae730f..162cd318 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -20,9 +20,6 @@ struct tracecmd_input *tracecmd_open(const char *file, int flags);
 struct tracecmd_input *tracecmd_open_fd(int fd, int flags);
 
 void tracecmd_close(struct tracecmd_input *handle);
-int tracecmd_pair_peer(struct tracecmd_input *handle,
-		       struct tracecmd_input *peer);
-void tracecmd_unpair_peer(struct tracecmd_input *handle);
 
 int tracecmd_init_data(struct tracecmd_input *handle);
 struct tep_record *
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index fc968cc9..7d7cb487 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -163,7 +163,6 @@ void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
 unsigned long tracecmd_get_file_state(struct tracecmd_input *handle);
-unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
 int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
 
 void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 134f6220..97c0b59d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -95,7 +95,6 @@ struct host_trace_info {
 	unsigned long long	peer_trace_id;
 	unsigned int		flags;
 	bool			sync_enable;
-	struct tracecmd_input	*peer_data;
 	int			ts_samples_count;
 	struct ts_offset_sample	*ts_samples;
 };
@@ -2226,38 +2225,10 @@ static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
 	host->ts_samples_count = j;
 }
 
-static void tsync_check_enable(struct tracecmd_input *handle)
-{
-	struct host_trace_info	*host = &handle->host;
-	struct guest_trace_info *guest;
-
-	host->sync_enable = false;
-
-	if (!host->peer_data || !host->peer_data->guest ||
-	    !host->ts_samples_count || !host->ts_samples)
-		return;
-	if (host->peer_trace_id != host->peer_data->trace_id)
-		return;
-	guest = host->peer_data->guest;
-	while (guest) {
-		if (guest->trace_id == handle->trace_id)
-			break;
-		guest = guest->next;
-	}
-	if (!guest)
-		return;
-
-	host->sync_enable = true;
-}
-
 static void trace_tsync_offset_free(struct host_trace_info *host)
 {
 	free(host->ts_samples);
 	host->ts_samples = NULL;
-	if (host->peer_data) {
-		tracecmd_close(host->peer_data);
-		host->peer_data = NULL;
-	}
 }
 
 static int trace_pid_map_cmp(const void *a, const void *b)
@@ -2266,7 +2237,6 @@ static int trace_pid_map_cmp(const void *a, const void *b)
 	struct tracecmd_proc_addr_map *m_b = (struct tracecmd_proc_addr_map *)b;
 
 	if (m_a->start > m_b->start)
-		return 1;
 	if (m_a->start < m_b->start)
 		return -1;
 	return 0;
@@ -3278,61 +3248,6 @@ fail:
 	return NULL;
 }
 
-/**
- * tracecmd_unpair_peer - Remove the linked tracing peer of this handle
- * @handle: input handle for the trace.dat file
- *
- * When tracing host and one or more guest machines at the same time,
- * guest and host are tracing peers. There is information in both trace
- * files, related to host PID to guest vCPU mapping, timestamp synchronization
- * and other. This information is useful when opening files at the same time and
- * merging the events. When the host is set as a tracing peer to the guest, then
- * the timestamps of guest's events are recalculated to match the host event's time
- *
- * This removes any peer that is linked to the  @handle.
- */
-void tracecmd_unpair_peer(struct tracecmd_input *handle)
-{
-	if (!handle)
-		return;
-
-	if (handle->host.peer_data) {
-		tracecmd_close(handle->host.peer_data);
-		handle->host.peer_data = NULL;
-		tsync_check_enable(handle);
-	}
-}
-
-/**
- * tracecmd_pair_peer - Link a tracing peer to this handle
- * @handle: input handle for the trace.dat file
- * @peer: input handle for the tracing peer
- *
- * When tracing host and one or more guest machines at the same time,
- * guest and host are tracing peers. There is information in both trace
- * files, related to host PID to guest vCPU mapping, timestamp synchronization
- * and other. This information is useful when opening files at the same time and
- * merging the events. When the host is set as a tracing peer to the guest, then
- * the timestamps of guest's events are recalculated to match the host event's time
- *
- * Returns 1, if a peer is already paired, -1 in case of an error or 0 otherwise
- */
-int tracecmd_pair_peer(struct tracecmd_input *handle,
-		       struct tracecmd_input *peer)
-{
-	if (!handle)
-		return -1;
-
-	if (handle->host.peer_data)
-		return 1;
-
-	handle->host.peer_data = peer;
-	tracecmd_ref(peer);
-	tsync_check_enable(handle);
-
-	return 0;
-}
-
 /**
  * tracecmd_ref - add a reference to the handle
  * @handle: input handle for the trace.dat file
@@ -3910,19 +3825,6 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 	return 0;
 }
 
-/**
- * tracecmd_get_tsync_peer - get the trace session id of the peer host
- * @handle: input handle for the trace.dat file
- *
- * Returns the trace id of the peer host, written in the trace file
- *
- * This information is stored in guest trace.dat file
- */
-unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
-{
-	return handle->host.peer_trace_id;
-}
-
 /**
  * tracecmd_enable_tsync - enable / disable the timestamps correction
  * @handle: input handle for the trace.dat file
-- 
2.29.2

