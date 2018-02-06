Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40362 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbeBFItP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:15 -0500
Received: by mail-pl0-f66.google.com with SMTP id g18so849217plo.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:15 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 04/24] trace-cmd: Move event-utils.h in lib/traceevent/include
Date: Tue,  6 Feb 2018 10:48:46 +0200
Message-Id: <20180206084906.9854-5-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves event-utils.h in lib/traceevent/include as part of a bigger
restructuring plan of trace-cmd's code base. In this case event-utils.h has
been moved into the private headers directory the traceevent library. In the
next steps, the source files of the traceevent lib will be moved there as well.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                              | 1 +
 event-utils.h => lib/traceevent/include/event-utils.h | 0
 2 files changed, 1 insertion(+)
 rename event-utils.h => lib/traceevent/include/event-utils.h (100%)

diff --git a/Makefile b/Makefile
index 1a25aa2..3c21a27 100644
--- a/Makefile
+++ b/Makefile
@@ -240,6 +240,7 @@ KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 INCLUDES = -I. -I ./include -I $(srctree)/../../include $(CONFIG_INCLUDES)
 INCLUDES += -I$(src)/include/traceevent
 INCLUDES += -I$(src)/include/trace-cmd
+INCLUDES += -I$(src)/lib/traceevent/include
 
 include $(src)/features.mk
 
diff --git a/event-utils.h b/lib/traceevent/include/event-utils.h
similarity index 100%
rename from event-utils.h
rename to lib/traceevent/include/event-utils.h
-- 
2.14.1
