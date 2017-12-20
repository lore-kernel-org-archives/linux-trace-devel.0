Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f65.google.com ([74.125.82.65]:39702 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932097AbdLTSIF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:05 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 04/18] trace-cmd: Move event-utils.h in lib/traceevent/include
Date: Wed, 20 Dec 2017 20:07:34 +0200
Message-Id: <20171220180748.17273-5-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
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
index b2728c1..6d45870 100644
--- a/Makefile
+++ b/Makefile
@@ -239,6 +239,7 @@ KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
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
