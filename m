Return-Path: <SRS0=4lCp=63=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3975AC433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 May 2020 17:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E0DC205ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 May 2020 17:06:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbfIzBsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389507AbgEMRGL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 May 2020 13:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEMRGL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 May 2020 13:06:11 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670E8C061A0C
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 May 2020 10:06:11 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 190so12558952qki.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 May 2020 10:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VLvLZMb3UlTjgfR0oLoWL+6XXFRIxxLsCwlwBZ6KM3E=;
        b=XbfIzBsl4CUwS6jBtHcUi9Z6hgLgfyvT+QHqjXgslSzwqBxH5LjpX5GBaifxixHaAO
         GKN6lovQ+PgLSvyAZaxGXsuccRgiGEyVua2u477giwE1G/SyCzWcEwJv+AzPlaBoiSnC
         D8Bv7Ft34Be+JXGBNuV7HI7ONPxbUmY5oHCN6Wk/DvUAllmfyfffqV4YcWIyaLznPVBs
         Vo7mo3w3p/3AmSmDPz1mCz8ofX1gWfDHZY2sq7ehnmkjeQF5+YURX6aeG9JCnz8lqGFG
         8qPOvdhBz/VJYR2AbN6s/PP0XevX7HYQoOcbVifLo9XkIJvUBoeGTkBkx3z2f9fQ5eLU
         di7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VLvLZMb3UlTjgfR0oLoWL+6XXFRIxxLsCwlwBZ6KM3E=;
        b=UBELkHLQbtYGsareSrVSWiysZv7jpVhjfG9T2YKlB/W0ZZ2Ztlxxj1toa3jFuPbh3v
         yO3ClrxLZrHN1yrvgpoE9dqvWGcUbS9OcNXdVKbRRF44YuCuvTPr0vAqo7kKO6TE9FF9
         wiMk/bFNxWOtcen3vZuPpkpZP5MQZv8lsA1qhUDA/7CmOMYttL22n1a2ZGxGYJhOKu/O
         562c2SPKO8jMtny/QoGEjv7azLJVUa7SKiyeoDfltyBS+LwblKRR5DjCMTYH/sqJf78/
         uEa/OclEH2yoofp1/VPAbJCaZ20In52i+Lw41QiUHXLVbCTuKp3SwwadE/YHQikxWook
         1G1g==
X-Gm-Message-State: AOAM533yzmhFYMWb1LOjLwcSAcdf4QNDl+SPFRSZh7RYyh6FXB+svKbF
        ig37xG7/dO7RJ01JYpfJ2TiSrSPX
X-Google-Smtp-Source: ABdhPJyfcz0iUHi/Tl0jzdXK46bdQxo8Nl4wA3Bj+2x7Or4Lkszs9oYLxvFLXA31DrrZzCEPFbY2ag==
X-Received: by 2002:a37:61cf:: with SMTP id v198mr683728qkb.54.1589389570672;
        Wed, 13 May 2020 10:06:10 -0700 (PDT)
Received: from localhost.localdomain (cpe-65-30-164-238.wi.res.rr.com. [65.30.164.238])
        by smtp.gmail.com with ESMTPSA id c197sm296986qkg.133.2020.05.13.10.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 10:06:10 -0700 (PDT)
From:   Bijan Tabatabai <bijan311@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Bijan Tabatabai <bijan311@yahoo.com>
Subject: [PATCH v3] trace-cmd: Stop recording when processes traced with -P exit
Date:   Wed, 13 May 2020 12:05:29 -0500
Message-Id: <20200513170529.22605-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Bijan Tabatabai <bijan311@yahoo.com>

When the -F flag is used in trace-cmd record, trace-cmd stops recording
when the executable it is tracing terminates.
This patch makes the -P flag act similarly.

Signed-off-by: Bijan Tabatabai <bijan311@yahoo.com>
---
 This patch has changed to use the pidfd interface to determine if a process
 has ended.
 It also has changed to work with the patch "trace-cmd: Handle filtered PIDs per
 ftarce instance" (5502bcef0f962cda).
---
 tracecmd/include/trace-local.h |  2 +
 tracecmd/trace-record.c        | 84 ++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4c6a63d..5d58550 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -215,9 +215,11 @@ struct buffer_instance {
 
 	struct opt_list		*options;
 	struct filter_pids	*filter_pids;
+	struct filter_pids	*process_pids;
 	char			*common_pid_filter;
 	int			nr_filter_pids;
 	int			len_filter_pids;
+	int			nr_process_pids;
 	bool			ptrace_child;
 
 	int			have_set_event_pid;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d0619ba..51e9103 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -16,6 +16,7 @@
 #include <sys/time.h>
 #include <sys/wait.h>
 #include <sys/socket.h>
+#include <sys/syscall.h>
 #include <sys/utsname.h>
 #ifndef NO_PTRACE
 #include <sys/ptrace.h>
@@ -33,6 +34,7 @@
 #include <errno.h>
 #include <limits.h>
 #include <libgen.h>
+#include <poll.h>
 #include <pwd.h>
 #include <grp.h>
 #ifdef VSOCK
@@ -1230,6 +1232,81 @@ static pid_t trace_waitpid(enum trace_type type, pid_t pid, int *status, int opt
 			trace_stream_read(pids, recorder_threads, &tv);
 	} while (1);
 }
+
+#ifndef __NR_pidfd_open
+#define __NR_pidfd_open 434
+#endif
+
+static int pidfd_open(pid_t pid, unsigned int flags) {
+	return syscall(__NR_pidfd_open, pid, flags);
+}
+
+static int trace_waitpidfd(id_t pidfd) {
+	struct pollfd pollfd;
+
+	pollfd.fd = pidfd;
+	pollfd.events = POLLIN;
+
+	while (!finished) {
+		int ret = poll(&pollfd, 1, -1);
+		/* If waitid was interrupted, keep waiting */
+		if (ret < 0 && errno == EINTR)
+			continue;
+		else if (ret < 0)
+			return 1;
+		else
+			break;
+	}
+
+	return 0;
+}
+
+static int trace_wait_for_processes(struct buffer_instance *instance) {
+	int ret = 0;
+	int nr_fds = 0;
+	int i;
+	int *pidfds;
+	struct filter_pids *pid;
+
+	pidfds = malloc(sizeof(int) * instance->nr_process_pids);
+	if (!pidfds)
+		return 1;
+
+	for (pid = instance->process_pids;
+	     pid && instance->nr_process_pids;
+	     pid = pid->next) {
+		if (pid->exclude) {
+			instance->nr_process_pids--;
+			continue;
+		}
+		pidfds[nr_fds] = pidfd_open(pid->pid, 0);
+
+		/* If the pid doesn't exist, the process has probably exited */
+		if (pidfds[nr_fds] < 0 && errno == ESRCH) {
+			instance->nr_process_pids--;
+			continue;
+		} else if (pidfds[nr_fds] < 0) {
+			ret = 1;
+			goto out;
+		}
+
+		nr_fds++;
+		instance->nr_process_pids--;
+	}
+
+	for (i = 0; i < nr_fds; i++) {
+		if (trace_waitpidfd(pidfds[i])) {
+			ret = 1;
+			goto out;
+		}
+	}
+
+out:
+	for (i = 0; i < nr_fds; i++)
+		close(pidfds[i]);
+	free(pidfds);
+	return ret;
+}
 #ifndef NO_PTRACE
 
 /**
@@ -5866,7 +5943,9 @@ static void parse_record_options(int argc,
 				fpids_count += add_filter_pid(ctx->instance,
 							      atoi(pid), 0);
 				pid = strtok_r(NULL, ",", &sav);
+				ctx->instance->nr_process_pids++;
 			}
+			ctx->instance->process_pids = ctx->instance->filter_pids;
 			free(pids);
 			break;
 		case 'c':
@@ -6361,6 +6440,11 @@ static void record_trace(int argc, char **argv,
 		}
 		/* sleep till we are woken with Ctrl^C */
 		printf("Hit Ctrl^C to stop recording\n");
+		for_all_instances(instance) {
+			if (instance->nr_process_pids
+			    && !trace_wait_for_processes(instance))
+				finished = 1;
+		}
 		while (!finished)
 			trace_or_sleep(type, pwait);
 	}
-- 
2.25.1

