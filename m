Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53E0C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8896821872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfCOIiC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:38:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38558 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbfCOIiC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 04:38:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id g12so8627891wrm.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 01:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=CeevfyJeQgqD4nAVPR3UKGWtRnH2SSvXOOLttHdvXT9W3oB4J21tb4uVZV6O6V8cwP
         cwxvrQtakSC+dpL0ONI+BG73WkVVSNb9sNiUrPMmom+MkvBlfj/5eaeSotWxXV+89UYx
         r8xPnVmVptYE2ply9POJUrlcOv6Zdi0XBU8NItf40kmSndtJC2xJQieYLDiT5za9yUhh
         ZO6Ia7hAmU3gMLyLqhdd4SEGWDV71Z59QPUZCVK6z1qFvvp829XJT5dYHIZIoT2qMB0g
         k12mNjt++JblK4n+q34NSCgP4hdMn/Fth4Vb3pMrB3uIuYfH2BReUa5sjwI8NBD57LiZ
         Z1Mw==
X-Gm-Message-State: APjAAAWel5r8AAvI6S+j3P08DCPzHACrUi/wNcIn69anVWWg8V3Nhbbo
        MDkA5WMRtkD2caSZQ1WHePiN8dQD
X-Google-Smtp-Source: APXvYqy24LQP7t0C0dZWQK2aujlrq+7noQOZBZF1+vGUeOqCDixG4+EDKZI51V+AjXBUVIgk4CesFQ==
X-Received: by 2002:adf:e2ca:: with SMTP id d10mr1432787wrj.250.1552639080614;
        Fri, 15 Mar 2019 01:38:00 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o5sm979395wmh.12.2019.03.15.01.37.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 01:37:59 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 4/9] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Fri, 15 Mar 2019 10:37:49 +0200
Message-Id: <20190315083754.27532-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315083754.27532-1-tstoyanov@vmware.com>
References: <20190315083754.27532-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added implementation of htonll() and ntohll() as
macros, if they are not already defined.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/include/trace-msg.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tracecmd/include/trace-msg.h b/tracecmd/include/trace-msg.h
index b7fe10b..445f799 100644
--- a/tracecmd/include/trace-msg.h
+++ b/tracecmd/include/trace-msg.h
@@ -15,4 +15,14 @@ extern unsigned int page_size;
 void plog(const char *fmt, ...);
 void pdie(const char *fmt, ...);
 
+#ifndef htonll
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#define htonll(x) __bswap_64(x)
+#define ntohll(x) __bswap_64(x)
+#else
+#define htonll(x) (x)
+#define ntohll(x) (x)
+#endif
+#endif
+
 #endif /* _TRACE_MSG_H_ */
-- 
2.20.1

