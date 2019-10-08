Return-Path: <SRS0=RjDi=YB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E282ECE58E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0179D206B6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbfJHIPs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:15:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39836 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730555AbfJHIPr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 04:15:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id v17so2078382wml.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Oct 2019 01:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qG6p9Lx7EzmJssjIPuMiImoRwqDax5ZXOWsOu9OXPno=;
        b=PNyJu3Hcmoza2muhKihoPNmcEejDksKDu2VFoa4jWhkuCocBR/uv18qpkTeytPPw/F
         8GPYBaLDn46v7B1/VNI8Q/qUhyW4J52kfYX8y1wg6u0srUBsI0qC1bX1MgcpdDBDla0P
         wSl4AWtMYsF5l3EPtrMsnY0Uya4mtR/NZFalv+X0YWYypoHQeJ6Nt7BQ9IAQeWs//yTC
         QcmxxIB3xxU8pEnr+SNSonOFhsP84FoDvKhn8q1vm2AaAbuzSLOanaIt8k4NG6RQEQxI
         FM1ouDLM/hmmn5iraGBN7B543YM2nSYrmlHDS80QDxaZow0HjZtc8Kj8FZ2mDNCY0Yzg
         /xvQ==
X-Gm-Message-State: APjAAAVsPYrzw9MbXJovW8hXej9GUhhVLlsbwqDL/l+D9qYyaGQGGt7d
        lnq6mHkxohNDv9d/e0Nonw==
X-Google-Smtp-Source: APXvYqwCeGBRYFVruPQVdQ2hD5e3clShS1HkVM9lVDN8Lj/AhbgkETvDd/CA4bqlW3VY5mOdYkH5+w==
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr2639847wmd.1.1570522546091;
        Tue, 08 Oct 2019 01:15:46 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm2201440wmj.17.2019.10.08.01.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 01:15:45 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 02/13] trace-cmd: Detect if vsockets are available
Date:   Tue,  8 Oct 2019 11:15:26 +0300
Message-Id: <20191008081537.11536-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008081537.11536-1-kaslevs@vmware.com>
References: <20191008081537.11536-1-kaslevs@vmware.com>
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
index bbdf15e..9723d49 100644
--- a/Makefile
+++ b/Makefile
@@ -208,6 +208,13 @@ CFLAGS ?= -g -Wall
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

