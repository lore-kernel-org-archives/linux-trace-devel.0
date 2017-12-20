Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36976 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755933AbdLTSIR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:17 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 14/18] trace-cmd: Move tracecmd headers in tracecmd/include
Date: Wed, 20 Dec 2017 20:07:44 +0200
Message-Id: <20171220180748.17273-15-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves trace-cmd's private headers in a dedicated directory called
tracecmd/include, as part of a bigger restructuring plan of trace-cmd's code
base.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                                | 1 +
 bug.h => tracecmd/include/bug.h                         | 0
 list.h => tracecmd/include/list.h                       | 0
 trace-cmd-local.h => tracecmd/include/trace-cmd-local.h | 0
 trace-local.h => tracecmd/include/trace-local.h         | 0
 trace-msg.h => tracecmd/include/trace-msg.h             | 0
 6 files changed, 1 insertion(+)
 rename bug.h => tracecmd/include/bug.h (100%)
 rename list.h => tracecmd/include/list.h (100%)
 rename trace-cmd-local.h => tracecmd/include/trace-cmd-local.h (100%)
 rename trace-local.h => tracecmd/include/trace-local.h (100%)
 rename trace-msg.h => tracecmd/include/trace-msg.h (100%)

diff --git a/Makefile b/Makefile
index 7c58414..88daa9f 100644
--- a/Makefile
+++ b/Makefile
@@ -199,6 +199,7 @@ INCLUDES += -I$(src)/include/trace-cmd
 INCLUDES += -I$(src)/lib/traceevent/include
 INCLUDES += -I$(src)/lib/trace-cmd/include
 INCLUDES += -I$(src)/kernel-shark/include
+INCLUDES += -I$(src)/tracecmd/include
 
 include $(src)/features.mk
 
diff --git a/bug.h b/tracecmd/include/bug.h
similarity index 100%
rename from bug.h
rename to tracecmd/include/bug.h
diff --git a/list.h b/tracecmd/include/list.h
similarity index 100%
rename from list.h
rename to tracecmd/include/list.h
diff --git a/trace-cmd-local.h b/tracecmd/include/trace-cmd-local.h
similarity index 100%
rename from trace-cmd-local.h
rename to tracecmd/include/trace-cmd-local.h
diff --git a/trace-local.h b/tracecmd/include/trace-local.h
similarity index 100%
rename from trace-local.h
rename to tracecmd/include/trace-local.h
diff --git a/trace-msg.h b/tracecmd/include/trace-msg.h
similarity index 100%
rename from trace-msg.h
rename to tracecmd/include/trace-msg.h
-- 
2.14.1
