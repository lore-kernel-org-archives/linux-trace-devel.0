Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33650 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755415AbdLTSIJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:09 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 07/18] trace-cmd: Move trace-hash-local.h in lib/trace-cmd/include
Date: Wed, 20 Dec 2017 20:07:37 +0200
Message-Id: <20171220180748.17273-8-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves trace-hash-local.h in lib/trace-cmd/include, as part of a
bigger restructuring plan of trace-cmd's code base. In this case, the new
directory in the "private headers" directory in the trace-cmd library. In the
next step, the source files of that library will be moved in lib/trace-cmd.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                                       | 1 +
 trace-hash-local.h => lib/trace-cmd/include/trace-hash-local.h | 0
 2 files changed, 1 insertion(+)
 rename trace-hash-local.h => lib/trace-cmd/include/trace-hash-local.h (100%)

diff --git a/Makefile b/Makefile
index 646ff2d..a3cce82 100644
--- a/Makefile
+++ b/Makefile
@@ -239,6 +239,7 @@ INCLUDES = -I$(src) -I $(src)/include -I $(srctree)/../../include $(CONFIG_INCLU
 INCLUDES += -I$(src)/include/traceevent
 INCLUDES += -I$(src)/include/trace-cmd
 INCLUDES += -I$(src)/lib/traceevent/include
+INCLUDES += -I$(src)/lib/trace-cmd/include
 
 include $(src)/features.mk
 
diff --git a/trace-hash-local.h b/lib/trace-cmd/include/trace-hash-local.h
similarity index 100%
rename from trace-hash-local.h
rename to lib/trace-cmd/include/trace-hash-local.h
-- 
2.14.1
