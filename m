Return-Path: <SRS0=pFV5=55=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A82BC352BE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 08:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB4E820753
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 08:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F6J6O1Ho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgDMIf2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 04:35:28 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41860 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgDMI34 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 04:29:56 -0400
Received: by mail-ed1-f65.google.com with SMTP id v1so11037701edq.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2020 01:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kgbEfvp3RwHQFQXZdUCv/kxSCw4+JR2RO/mDEUqtF0A=;
        b=F6J6O1HopjlOM9QIvPCd2sgw+cpvLbz2dmj/mH3OHrXIOVXCBpuV9YP1Ib097xS4Jg
         9tZrsP6r8/5/TvLfRYcEA3mYyoF+RvhuDXopGs5WkcX1F288piewf9C9mzoSvFnnRbQY
         wHOiW0ft/+H2lMFV/4UOPNBGpLtwFqcKC353zxV13RLwfdEk7Nj3xiXKJ+KdYyb71Czz
         Dzo7O4+wO3S5abPFL9l0zC8IV5UAeh9FQitX5SgVJo354FVMILyZ87mpaZ2SdxNpDM6M
         Gbl5J3tEKpiWunzyr1lqp40fE/News148oMwgHEi0fkJdhna3K4sawK0PBt7msKnyfEk
         2Eig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kgbEfvp3RwHQFQXZdUCv/kxSCw4+JR2RO/mDEUqtF0A=;
        b=k1USbe7lYUN8g6E/PcjywQT4F6E3FvTwKjTjNYJ05mLvwTXp3R6AhK2+aGLb4smjb/
         77kLV1jxSI7ON+aOIeiAHjeqXL0dqViwseX9XQHudWs5o9+ncyqqPn2getKdmLBV5oHd
         KKDiFF6iIWapK+eyEkqiUX1NM3wtPnmL7+r3bCPM7jp0iR/NYt5ULhEejvq62OhZo3VH
         Pvg8O9Sd+DL3YRezCzJf2uj15VS832gwj83KynySgzR0lIezyFOnVYtJiIPrTTW2uAaE
         MpTqCNAMW4CHVPV+OTnEO4uZujw3VO1R/xj++R2HWTXisW721vMj9ltQK0oWFqe7J9jU
         bE9A==
X-Gm-Message-State: AGi0PuayMk0c+72mVxHokOMgpLEqCVYfLGj5aS86AWm0WVXGRSMHDGJF
        Xiuxj7bwThP3BLvjksCb0AYNhzOODtg=
X-Google-Smtp-Source: APiQypJvzblM+sJ2+8ZKOo3WX6O/9i0j3E9fTPTzIDHqseKEU0wlfpy5a/bclU3nX+eCSh1UuXPumw==
X-Received: by 2002:a2e:8752:: with SMTP id q18mr9100842ljj.266.1586766218623;
        Mon, 13 Apr 2020 01:23:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b9sm9463605lfp.27.2020.04.13.01.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 01:23:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cmd: Add new APIs to pair and unpair tracing peers
Date:   Mon, 13 Apr 2020 11:23:33 +0300
Message-Id: <20200413082334.164158-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200413082334.164158-1-tz.stoyanov@gmail.com>
References: <20200413082334.164158-1-tz.stoyanov@gmail.com>
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
Two new APIs are intrduced to control pairing of tracing peers:

int tracecmd_pair_peer(struct tracecmd_input *handle,
		       struct tracecmd_input *peer);
int tracecmd_unpair_peer(struct tracecmd_input *handle);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  3 ++
 lib/trace-cmd/trace-input.c   | 95 +++++++++++++++++++++++++++++++++--
 2 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index e22aa251..76fcffae 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -145,6 +145,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd);
 struct tracecmd_input *tracecmd_open(const char *file);
 struct tracecmd_input *tracecmd_open_head(const char *file);
 struct tracecmd_input *tracecmd_open_fd(int fd);
+int tracecmd_pair_peer(struct tracecmd_input *handle,
+		       struct tracecmd_input *peer);
+int tracecmd_unpair_peer(struct tracecmd_input *handle);
 void tracecmd_ref(struct tracecmd_input *handle);
 void tracecmd_close(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index efc8d4bd..cd909613 100644
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
@@ -3203,6 +3232,64 @@ fail:
 	return NULL;
 }
 
+/**
+ * tracecmd_unpair_peer - Link a tracing peer to this handle
+ * @handle: input handle for the trace.dat file
+ * @peer: input handle for the tracing peer
+ *
+ * When tracing host and one or more guest machines at the same time,
+ * guest and host are tracing peers. There is information in both trace
+ * files, related to host PID to guest vCPU mapping, timestamp synchronization
+ * and other. This information is useful when opening files at the same time and
+ * merging the events. When the host is set as a tracing peer to the guest, then
+ * the timestamps of guest's events are recalculated to match the host event's time
+ *
+ * Returns 1, if a peer is already paired, -1 in case of an error or 0 otherwise
+ */
+int tracecmd_unpair_peer(struct tracecmd_input *handle)
+{
+	if (!handle)
+		return -1;
+
+	if (handle->host.peer_data) {
+		tracecmd_close(handle->host.peer_data);
+		handle->host.peer_data = NULL;
+		tsync_check_enable(handle);
+	}
+
+	return 0;
+}
+
+/**
+ * tracecmd_pair_peer - Link a tracing peer to this handle
+ * @handle: input handle for the trace.dat file
+ * @peer: input handle for the tracing peer
+ *
+ * When tracing host and one or more guest machines at the same time,
+ * guest and host are tracing peers. There is information in both trace
+ * files, related to host PID to guest vCPU mapping, timestamp synchronization
+ * and other. This information is useful when opening files at the same time and
+ * merging the events. When the host is set as a tracing peer to the guest, then
+ * the timestamps of guest's events are recalculated to match the host event's time
+ *
+ * Returns 1, if a peer is already paired, -1 in case of an error or 0 otherwise
+ */
+int tracecmd_pair_peer(struct tracecmd_input *handle,
+		       struct tracecmd_input *peer)
+{
+	if (!handle)
+		return -1;
+
+	if (handle->host.peer_data)
+		return 1;
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
@@ -3785,7 +3872,7 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
  */
 unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
 {
-	return handle->host.trace_id;
+	return handle->host.peer_trace_id;
 }
 
 /**
-- 
2.25.1

