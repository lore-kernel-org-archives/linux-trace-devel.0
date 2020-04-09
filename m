Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5B3C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D191C2072F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f/oQND89"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgDIN2n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:43 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39654 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgDIN2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:42 -0400
Received: by mail-lf1-f66.google.com with SMTP id m2so7890262lfo.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u6jOzDnRh1znNqMxD7kKEig411vAh26MJVXYkOTIKVg=;
        b=f/oQND89JNRRhLlO6X9c4vrFJ4PG0BhlF93FugbTOoM3RZ83kMZwZW2QO3Ky3PBdVH
         LaT57rizl0es2ZWBUheoWIseEdoiRRBTiLrp54h6f2LlLo7MXMoAGJMb2i412ClyvNhA
         FHjod2cNLSvCfRi7ZQhTDca17HY67TEIEP3XAt4P8LHZTF0ozNikvC/vL38X8WQ/qmWl
         E236hAlutcd6ZeXh5HQhm/mSZw9UkatJ4a6SwfPbkgql4TLHDSLS3HDLbtVjIqywYR+c
         zlUOvKAf1hHzndgHQe7bHyp1nlcJ7mpKEUbVTEHRwG1l9oyAyVy5KpaYex3qxjYLfOH7
         zy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6jOzDnRh1znNqMxD7kKEig411vAh26MJVXYkOTIKVg=;
        b=Sx6M3yD/aL6we/S5LfKCbNnhM1EaI4Yl8MV0wIMdksOc22pxT0h8qqzj6HNe6qdWTg
         bhvRpRpmoxHXqTc52tOJGoR8zWWTWtMn9PJK7Nx9OwItDE2gEDhr2mqVyL66X0+ilfdJ
         Bakij5tJEHAbAVHwqVKKih2e90rIZLnuNPlWDaErCrNweP4q60QTapAPEL8XgHusFlTK
         kof/aWNUa0ZtnkBoU+GOXtoZh0wnmr5dAmmuN3vGTiDfrvv2biKBteV1zsWpokQou3Fw
         IwoLoonkDCJzr9TA+bF+m24lNsIXwNue4gAvvR7qQ/lXUf8tmuAH+82YFyhsdVpclX/s
         V34Q==
X-Gm-Message-State: AGi0PuZZKSZLy2KStVSYxenm4r+1eQPoPHCgmpNEZMycTIuWUWSTkkBg
        TCB2MVQJ87CSQmJENCbW0j2QnzYwvrQ=
X-Google-Smtp-Source: APiQypIAksqTo2lKlJtGAF62FI8baXvvlPNAv2g8+Mrvnk5ihf9Tf+6sGplySZQ54qMny+AgJ6f6yQ==
X-Received: by 2002:ac2:46d3:: with SMTP id p19mr7554658lfo.72.1586438919632;
        Thu, 09 Apr 2020 06:28:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 13sm15210345ljq.68.2020.04.09.06.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Add new API tracecmd_set_merge_peer()
Date:   Thu,  9 Apr 2020 16:28:34 +0300
Message-Id: <20200409132835.79530-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409132835.79530-1-tz.stoyanov@gmail.com>
References: <20200409132835.79530-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When tracing host and one or more guest machines at the same time,
guest and host are tracing peers. There is information in both trace
files, related to host PID to guest vCPU mapping, timestamp synchronization
and other. This information is useful when opening files at the same time and
merging the events. When the host is set as a tracing peer to the guest, then
the timestamps of guest's events are recalculated to match the host event's time

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  2 ++
 lib/trace-cmd/trace-input.c   | 62 ++++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index e22aa251..0fdc855b 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -145,6 +145,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd);
 struct tracecmd_input *tracecmd_open(const char *file);
 struct tracecmd_input *tracecmd_open_head(const char *file);
 struct tracecmd_input *tracecmd_open_fd(int fd);
+int tracecmd_set_merge_peer(struct tracecmd_input *handle,
+			    struct tracecmd_input *peer);
 void tracecmd_ref(struct tracecmd_input *handle);
 void tracecmd_close(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index efc8d4bd..6c358131 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -91,8 +91,9 @@ struct guest_trace_info {
 };
 
 struct host_trace_info {
-	unsigned long long	trace_id;
+	unsigned long long	peer_trace_id;
 	bool			sync_enable;
+	struct tracecmd_input	*peer_data;
 	int			ts_samples_count;
 	struct ts_offset_sample	*ts_samples;
 };
@@ -2194,10 +2195,38 @@ static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
 		host->sync_enable = true;
 }
 
+static void tsync_check_enable(struct tracecmd_input *handle)
+{
+	struct host_trace_info	*host = &handle->host;
+	struct guest_trace_info *guest;
+
+	host->sync_enable = false;
+
+	if (!host->peer_data || !host->peer_data->guest ||
+	    !host->ts_samples_count || !host->ts_samples)
+		return;
+	if (host->peer_trace_id != host->peer_data->trace_id)
+		return;
+	guest = host->peer_data->guest;
+	while (guest) {
+		if (guest->trace_id == handle->trace_id)
+			break;
+		guest = guest->next;
+	}
+	if (!guest)
+		return;
+
+	host->sync_enable = true;
+}
+
 static void trace_tsync_offset_free(struct host_trace_info *host)
 {
 	free(host->ts_samples);
 	host->ts_samples = NULL;
+	if (host->peer_data) {
+		tracecmd_close(host->peer_data);
+		host->peer_data = NULL;
+	}
 }
 
 static int trace_pid_map_cmp(const void *a, const void *b)
@@ -2510,8 +2539,8 @@ static int handle_options(struct tracecmd_input *handle)
 			 */
 			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
 				break;
-			handle->host.trace_id = tep_read_number(handle->pevent,
-								buf, 8);
+			handle->host.peer_trace_id = tep_read_number(handle->pevent,
+								     buf, 8);
 			handle->host.ts_samples_count = tep_read_number(handle->pevent,
 									buf + 8, 4);
 			samples_size = (8 * handle->host.ts_samples_count);
@@ -3203,6 +3232,31 @@ fail:
 	return NULL;
 }
 
+/**
+ * tracecmd_set_merge_peer - Link a tracing peer to this handle
+ * @handle: input handle for the trace.dat file
+ * @peer: input handle for the tracing peer
+ *
+ * When tracing host and one or more guest machines at the same time,
+ * guest and host are tracing peers. There is information in both trace
+ * files, related to host PID to guest vCPU mapping, timestamp synchronization
+ * and other. This information is useful when opening files at the same time and
+ * merging the events. When the host is set as a tracing peer to the guest, then
+ * the timestamps of guest's events are recalculated to match the host event's time
+ */
+int tracecmd_set_merge_peer(struct tracecmd_input *handle,
+			    struct tracecmd_input *peer)
+{
+	if (!handle)
+		return -1;
+
+	handle->host.peer_data = peer;
+	tracecmd_ref(peer);
+	tsync_check_enable(handle);
+
+	return 0;
+}
+
 /**
  * tracecmd_ref - add a reference to the handle
  * @handle: input handle for the trace.dat file
@@ -3785,7 +3839,7 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
  */
 unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
 {
-	return handle->host.trace_id;
+	return handle->host.peer_trace_id;
 }
 
 /**
-- 
2.25.1

