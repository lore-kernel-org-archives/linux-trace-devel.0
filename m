Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39985 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387878AbeGKNmE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 09:42:04 -0400
Received: by mail-wm0-f66.google.com with SMTP id z13-v6so2592911wma.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Jul 2018 06:37:40 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark-qt: Deal with the "no tasks" case in kshark_get_task_pids()
Date: Wed, 11 Jul 2018 16:37:08 +0300
Message-Id: <20180711133709.26788-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

kshark_get_task_pids() should not return a "memory allocation" error
in the case when it is called before having trace data loaded.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 668b6df..75b88c9 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -303,6 +303,12 @@ ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids)
 		}
 	}
 
+	if (!pid_count) {
+		free(*pids);
+		*pids = NULL;
+		return pid_count;
+	}
+
 	temp_pids = realloc(*pids, pid_count * sizeof(int));
 	if (!temp_pids)
 		goto fail;
-- 
2.17.1
