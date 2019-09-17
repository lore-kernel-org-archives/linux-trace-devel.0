Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB51C4CECD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8093214AF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfIQNPt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:15:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38059 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfIQNPt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:15:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so3125421wrx.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 06:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YliHvS1S9uPrUP/v/bhyILaNfBd/ZsH9gevpMENK+AI=;
        b=KoGRFhJ0j1wup5Ep7cg9wrOAGjkqYtD2Za7GzAC1MGCPiR5ckbD0Ly5iU5XpYAjPlX
         y/5RGzLiQQK2jLQTiJ1JY1XErXoCamQDjmPsSW4o1774Az0HZ18T6g/ArVZwJjVll8Mo
         4NePdtOhiF1UBTMi/A6AjefTYUCBVbG0RnCOjznlpuk46BjECWKdO5jkK3UwpxEeBgla
         ubKY4gOhCfvpuHSKxNGWjoddV34LqYKLf8q9/9+/zLjQxLxoFpCVHKOBp1cWP9tAgqjc
         Tfhyj06bBH4IGIuaXRnohkns9IUU+tmZajJDQBI+bTc2yy1Ji4578zwWPoFtpW0h1puT
         oVmA==
X-Gm-Message-State: APjAAAUjc6H8vcqOdcbLDMjkF7wZfgN1lGON2DnLdmkrMvrHi47452a2
        DN1IR4urvrkrrMvvM38IXMqTD43b8g==
X-Google-Smtp-Source: APXvYqxGeyjB9inenOsVgfEyFbS0DXIgObwwhY9Iq5EZJQfoSu5fsWVQRS4p1tESs3oprCRMWrfJYA==
X-Received: by 2002:a5d:570a:: with SMTP id a10mr3008821wrv.136.1568726147647;
        Tue, 17 Sep 2019 06:15:47 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d22sm1667265wmb.44.2019.09.17.06.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 06:15:47 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 02/13] trace-cmd: Detect if vsockets are available
Date:   Tue, 17 Sep 2019 16:15:27 +0300
Message-Id: <20190917131538.31926-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190917131538.31926-1-kaslevs@vmware.com>
References: <20190917131538.31926-1-kaslevs@vmware.com>
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
index dabdf8d..6febac9 100644
--- a/Makefile
+++ b/Makefile
@@ -210,6 +210,13 @@ CFLAGS ?= -g -Wall
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
2.20.1

