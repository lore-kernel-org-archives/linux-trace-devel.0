Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6154C10F11
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77AD520656
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfDVOz2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 10:55:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43415 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfDVOz2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 10:55:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id k17so16078541wrx.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 07:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XVeGtFxZnR9mbXZm8SHXFy1fTMVMBPGJ+PMQwF4yj/M=;
        b=GgXe2ApTmiZB6HADkqMlaNXqCqrG0LTBOV6fcqQ/nXiXplfvWp9YegU/Fn2yPXOSrt
         LSUGt3b+BxswlPqeGWc/ZrTl9TfBN9TN7jcQU1XLeOTrKOCfKw6PDQfSUZWRlxhIjdKL
         vNQAtaQUgtqvXB5D9XbA/v1LSBkqJjcScxbqL/fU+QOSiwKQZPEzhRfhyUQ9x3Mzonfr
         ker5gXdhye9zXFYYQtvgerMqAuHwFtWxQz/kyqRlzAb/J9mUoHieGRaEz3J5cHlEQ4Eq
         PKHHa9m+ep1e60BU+8iYfRPOUkgAjq94bQsCa+xMRuSviAjeRjhG7u5BJn7xKiNuwf2/
         Lf8A==
X-Gm-Message-State: APjAAAViJ0d+0/sb4t0KXe+JVb8lK0kDwLwTnjzfbKq80Iyued5XRmIX
        8tZGzcQz0TksSFuMEbeIqQ==
X-Google-Smtp-Source: APXvYqyXCVQD2PSiXGwy3R29hDDE0dzQqBJN8T5rGVSIYj1Kh6CjkFpkNNL1mJZMDuTCg5MfGo14Iw==
X-Received: by 2002:adf:cd90:: with SMTP id q16mr12966214wrj.75.1555944926472;
        Mon, 22 Apr 2019 07:55:26 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f128sm17321087wme.28.2019.04.22.07.55.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 07:55:25 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 02/12] trace-cmd: Detect if vsockets are available
Date:   Mon, 22 Apr 2019 17:55:09 +0300
Message-Id: <20190422145519.16146-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422145519.16146-1-kaslevs@vmware.com>
References: <20190422145519.16146-1-kaslevs@vmware.com>
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
index cde45f8..2026183 100644
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

