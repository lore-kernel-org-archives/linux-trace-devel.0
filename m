Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECBEC4151A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8099E2077B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfBVSFv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:05:51 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52611 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfBVSFv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 13:05:51 -0500
Received: by mail-wm1-f68.google.com with SMTP id m1so2779007wml.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 10:05:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebx/6PKF298evGUiQpbCn8tno+rQu+UODpYT6m+zsg0=;
        b=S7NZBb7bf6Yal6S/QL2ZIZNBrbS0utx+8yqpe0MPLOi0lrwuD7R8cDx29WgA7e1/0/
         QeS/uiGcrJtJLtAX1GJrmHfV44MU2kvukk+AZJt0jgONVix1oG4R6THm2WnIMWxy1hIS
         t2hPsmad8xk55phbdSevwrjjz6koVNSqKz0P2LhtcrxxfGeiX4e+FnkvySA0simUNSS7
         oFvfSJdfelpNQm5ghcmrUqDfZFJENu/7hwovooXJ62R2MJmmtQ6zCaVOfrRIcKCNCtfK
         0/LwCD6KvZEe3ekQg6bAU1dfyzzLWpmc3Q/S/SyN6G4Jf+eYGFAwLsf9vWx+EY0Nw4+i
         SSQw==
X-Gm-Message-State: AHQUAub0WChXFP4AyVq6JEOF+9954EtO7tvax905Ak/VEZg48uXAj1HE
        YHrMHvxoDb0JjWZPZd0qQRD0y0s=
X-Google-Smtp-Source: AHgI3Ia7qnIjmxG3cx+vEQLaX6rXQ0BtddWci1yw9hVbh8mGZaih8Mcol6iU0PT1xfM4aAvS6EDtHA==
X-Received: by 2002:a1c:98c9:: with SMTP id a192mr3458887wme.114.1550858749491;
        Fri, 22 Feb 2019 10:05:49 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c18sm1320678wre.32.2019.02.22.10.05.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 10:05:48 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 03/13] trace-cmd: Detect if vsockets are available
Date:   Fri, 22 Feb 2019 20:05:29 +0200
Message-Id: <20190222180539.27439-4-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190222180539.27439-1-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Detect and define VSOCK if vsockets are available on the system.
This macro is used to disable VM remote tracing features on older kernels.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index b780718..99e4f39 100644
--- a/Makefile
+++ b/Makefile
@@ -204,6 +204,13 @@ CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
 
+VSOCK_DEFINED := $(shell if (echo "\#include <linux/vm_sockets.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+
+export VSOCK_DEFINED
+ifeq ($(VSOCK_DEFINED), 1)
+CFLAGS += -DVSOCK
+endif
+
 export CFLAGS
 export INCLUDES
 
-- 
2.19.1

