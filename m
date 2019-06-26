Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E27C48BD8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC9B120656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRhcdRIc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfFZKwW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:52:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38965 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfFZKwV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:52:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so1595771wma.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2019 03:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVphQ4X31C0SFvrwf0AQ8SwPSwp2whzv7Q59vsptiWw=;
        b=lRhcdRIcr8Onn7Ne5RNbkUJxZv9dDl4B881SP1Jy4vWFOiIUu0Ei42IzFF3jDP0Dq4
         R27azBrfp8R5ga3r+tKkMaYbeyySHSNKkWaSCxeKxr6A1PwO3dK8jkRM0QBkTBYXEfam
         sVLxXLvIEemIvp7QIfatowYd2eyL7IeDhqkaWR5GjgGd/AjzatECbaQAJ7R+/2N5Al9g
         dJkvMxm93rnPvxI/EHIIW29GVv9lAespUDlWJtZalH+v4OTkqK2cKv25LkdEbvhTq0M3
         1Y6m/x89cK1IUB62axalAFk3o7byLfDXzSQI/EBxK0bFUpEkZrdZ5/D4NH8KUHdfFKVF
         Ev4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVphQ4X31C0SFvrwf0AQ8SwPSwp2whzv7Q59vsptiWw=;
        b=KxGPHTALu/MCj7mnBUxLyOFEZbP/bgUpYn6JaRMV1XkRghr99a003V7hzaROMgbKqn
         7po7Fcg2jCtq+QoLfBoClb+c7h41v4BLG9dzArEXvS706Nmecg3wvRKDsKs+VTd5kiz4
         ONpa3Q0Ir34at+Gq6ntTWNN/b5tt7TedrsmFi5UA+RmHLlq+XzDNqe7rOputO+RQJIEh
         7yYcZEeMQoGRglfjVV0c33ehcSxqe4+2YYfV0C/vx/T3QGAb40ywUQuuHmEOScydHvaM
         Vhbq6m7p7mqwt+vkW9XHBo4sAVbQTAXfVEM3HRWUxMNz6erC8w4hAhiC6xAgfCPf6MDm
         W5jg==
X-Gm-Message-State: APjAAAVM/XAIb69X/Easy41pmMoL5MbQ2Rd978A+2VO4znffs07RaQkU
        ulz4L0iLZMhm86udZZS+QA==
X-Google-Smtp-Source: APXvYqzYCcfOIrQdHyPocqHzyBEYwDPo/WS6deFyZzQ0TDhxryk8qERMnfjJ95oiPnBm1nKiaGwuog==
X-Received: by 2002:a1c:630a:: with SMTP id x10mr2447018wmb.113.1561546339360;
        Wed, 26 Jun 2019 03:52:19 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm15456929wrt.49.2019.06.26.03.52.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:52:18 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v13 02/13] trace-cmd: Detect if vsockets are available
Date:   Wed, 26 Jun 2019 13:51:58 +0300
Message-Id: <20190626105209.13200-3-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
References: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
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
index d34c615..ba726ee 100644
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
2.20.1

