Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35276 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbeBFItV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:21 -0500
Received: by mail-pf0-f194.google.com with SMTP id y9so315983pfl.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:20 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 07/24] trace-cmd: Move trace-hash-local.h in lib/trace-cmd/include
Date: Tue,  6 Feb 2018 10:48:49 +0200
Message-Id: <20180206084906.9854-8-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
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
index c18bf2f..26b97e5 100644
--- a/Makefile
+++ b/Makefile
@@ -240,6 +240,7 @@ INCLUDES = -I$(src) -I $(src)/include -I $(srctree)/../../include $(CONFIG_INCLU
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
