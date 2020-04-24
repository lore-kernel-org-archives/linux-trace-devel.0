Return-Path: <SRS0=pvIb=6I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD89C54FD0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 17:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E149D20781
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 17:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhvlJfzt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgDXRof (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 13:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726920AbgDXRof (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 13:44:35 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27599C09B047
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 10:44:35 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b62so11012768qkf.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 10:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JAeU7w+SbjOeB2O368cJP4c2rxbaXMSVqrnoTBccTr0=;
        b=RhvlJfztq3FBmFcWZb67grVG16aCuPVfpMl/jpeSAENi7GjSvp6LHrjk4nBFUUc66K
         YrmqWdLxk1/A/NGwJV7NIbaO2TwWYU38cFlPSJtiyqoT5XCYoSQIOucV7g6gGy9Y+d//
         rfkWG9Nv+30IaxteOlOWpJdiZCv2j+3XXy/dCJRC0VWAIe+zFaAOHuxjlIA8WGtQAijj
         SvKl6PNsj+RVSnxFZnXg0xZB50PLRALYfv0b5kbnE3ZDME8iyjud3DgCfCdQNXj3q1Jq
         BCgJ5+BPdAy7zcEQ6xL00SFU4p9HAsorek1CbRpMAvn4mg0Zfajm8Zl9JQUFZvh0TuHr
         P8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JAeU7w+SbjOeB2O368cJP4c2rxbaXMSVqrnoTBccTr0=;
        b=RCUGrq7MtbxvPk6ItEzfSm4C1nM9OEjhFUoV9rUcTJEJvKqn668FIL1/lQdN+aZVTN
         SrmgEJ4dSJyPoID6KQ5fzBiGQXdTpA367b8aJFJ4l2Oka8FpUP0YCsizgdBn+Gj7hF1g
         h6/LR6csO5iV5TrZ0NYV9dHWQxYzTLCd8QUrE0IHjDTctlWlCkSFDrE0Nnch0DCwO5ww
         LH8rdCi+UcX6TI/psINpcQ2IqCO0bkP1mzZ8QDqGWewthDCinuCDr3naNIFsUTq1yxRL
         PLOQ70TVvFxr86L0FSsQ9vAiqJNYP3aAGjlq/ikM902Ud2wHV1SsyxHMgfgVdyavWWoI
         26fA==
X-Gm-Message-State: AGi0PuaOgUWWAHmI3r4RHfx6A40ZFa5M6EFJuVgQdYYJHKdgqR9w2cGN
        +g2eurFj0zz3ZbYpnELBiFpcQn+6a3A=
X-Google-Smtp-Source: APiQypKqFGBo/Z1rZWVNeN8IW/Y1ZxVkva4j27BEgxlP19tcLySHvhjkLUJbPjaANSEjBM7g1+Hwbg==
X-Received: by 2002:a37:9c44:: with SMTP id f65mr3550171qke.332.1587750273951;
        Fri, 24 Apr 2020 10:44:33 -0700 (PDT)
Received: from localhost.localdomain (cpe-65-30-164-238.wi.res.rr.com. [65.30.164.238])
        by smtp.gmail.com with ESMTPSA id j90sm4359188qte.20.2020.04.24.10.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 10:44:33 -0700 (PDT)
From:   Bijan Tabatabai <bijan311@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Bijan Tabatabai <bijan311@yahoo.com>
Subject: [PATCH v2] trace-cmd: Stop recording when processes traced with -P exit
Date:   Fri, 24 Apr 2020 12:44:01 -0500
Message-Id: <20200424174401.42886-1-bijan311@gmail.com>
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
 I changed this patch to use the pidfd interface to determine if a process had
 ended.
 I also refactored the patch a bit, so it looks much cleaner in my opinion.
---
 tracecmd/trace-record.c | 81 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d8c24eb..5b9c961 100644
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
@@ -121,8 +123,10 @@ struct filter_pids {
 };
 
 static struct filter_pids *filter_pids;
+static struct filter_pids *process_pids;
 static int nr_filter_pids;
 static int len_filter_pids;
+static int nr_process_pids = 0;
 
 static int have_set_event_pid;
 static int have_event_fork;
@@ -1243,6 +1247,79 @@ static pid_t trace_waitpid(enum trace_type type, pid_t pid, int *status, int opt
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
+static int trace_wait_for_processes() {
+	int ret = 0;
+	int nr_fds = 0;
+	int i;
+	int *pidfds;
+	struct filter_pids *pid;
+
+	pidfds = malloc(sizeof(int) * nr_process_pids);
+	if (!pidfds)
+		return 1;
+
+	for (pid = process_pids; pid && nr_process_pids; pid = pid->next) {
+		if (pid->exclude) {
+			nr_process_pids--;
+			continue;
+		}
+		pidfds[nr_fds] = pidfd_open(pid->pid, 0);
+
+		/* If the pid doesn't exist, the process has probably exited */
+		if (pidfds[nr_fds] < 0 && errno == ESRCH) {
+			nr_process_pids--;
+			continue;
+		} else if (pidfds[nr_fds] < 0) {
+			ret = 1;
+			goto out;
+		}
+
+		nr_fds++;
+		nr_process_pids--;
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
@@ -5832,7 +5909,9 @@ static void parse_record_options(int argc,
 			while (pid) {
 				add_filter_pid(atoi(pid), 0);
 				pid = strtok_r(NULL, ",", &sav);
+				nr_process_pids++;
 			}
+			process_pids = filter_pids;
 			free(pids);
 			break;
 		case 'c':
@@ -6308,6 +6387,8 @@ static void record_trace(int argc, char **argv,
 		}
 		/* sleep till we are woken with Ctrl^C */
 		printf("Hit Ctrl^C to stop recording\n");
+		if (nr_process_pids && !trace_wait_for_processes())
+			finished = 1;
 		while (!finished)
 			trace_or_sleep(type);
 	}
-- 
2.25.1

