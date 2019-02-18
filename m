Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6B7C4360F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C77621479
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfBROzC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:55:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40095 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729852AbfBROzC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:55:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id q1so18696817wrp.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:55:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebx/6PKF298evGUiQpbCn8tno+rQu+UODpYT6m+zsg0=;
        b=HlIUzZs1A9w0l+QpPmgeL5iMmxI7IDrmqJBBTFKcu0Dfk5g6UAfPoCyIMVN25BylxR
         54u29xsrHZuoLXOdB2EkqcWgA6NaRaIdL9bVZ6XItRLa4ZRkcOcZOY9F6CY2KsnW7i5F
         Wx12tjv7ne0/lV99a48SOtNPq0snQwDEilC35QFi3NY5iGGB2zfmUXsz14IpP48BCQDl
         9/3s6YJG7Duwvg/b5XyX99WXXrecNWDkcZMAlMCye7orV/B6upwh0eJF01OT3VBGlaGF
         zAY0PiDp2stcztFw3mxWV74wJlsPLCtCcOpyLYO1jBKhmTR2BK6AsuZirr4Xg4mYZ21l
         L4Cw==
X-Gm-Message-State: AHQUAubSVF4xwh5fD9ksSrP60BhykHQwaqskU768FPOX4j98Un27xK8E
        2pFoPD2CKzXPACzfQM/sAw==
X-Google-Smtp-Source: AHgI3IYZ5kRURiY4zF1l7ylMtEI/MVhYQg6g3p14uXcoktNOWq0K4f6Iou+HEf4FDuBBMBaRcw/zCw==
X-Received: by 2002:adf:d845:: with SMTP id k5mr17254192wrl.145.1550501700969;
        Mon, 18 Feb 2019 06:55:00 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id n11sm10172528wrw.60.2019.02.18.06.54.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 06:55:00 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@vmware.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v7 03/13] trace-cmd: Detect if vsockets are available
Date:   Mon, 18 Feb 2019 16:54:39 +0200
Message-Id: <20190218145449.13360-4-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190218145449.13360-1-kaslevs@vmware.com>
References: <20190218145449.13360-1-kaslevs@vmware.com>
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

