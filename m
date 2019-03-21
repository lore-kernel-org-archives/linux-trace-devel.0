Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C259DC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 949D7218E2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfCUPrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:47:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38209 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbfCUPrR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 11:47:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id a188so3244092wmf.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Mar 2019 08:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=KNYoPsavxp+jE6uXySHrKMxH5zR6Ji46mHVSUg126aExjL37mw2CvvXrOQxUO1DitS
         uBjJe3mMjbV57NT+/Br/6gNK/ibyxz77c8H7rSlnTRT08LXbzbl0u8zcDKpDDFwar0vG
         hwCOTL0s6RxbR5s/OU0o09WKRUuZLcnLwkbUSeUXGYSFLwTHoJZpiFkjQ+4VBPVizjMn
         gsjfYMWnB3L0TJ/EEvnrV+GxJweyzMgDqmBxQR5OVknKihVxQMbUYrrKJNQgrA2wa0ac
         wAoYJEt6fv+IuwtxVVbpJmwv8jQDbnXycoktbML9xI89C9rdNBVAysU1GN+V2AEnHP+i
         CItw==
X-Gm-Message-State: APjAAAXiOlBJgOrhV/XYVBq5fawHqZstdq4uNfznXCda6d9gKlOYFDW3
        h2yZqeGuM2ggC2+h+/Gq9W4E5rUv
X-Google-Smtp-Source: APXvYqwCBCPeN44OFkAPXVJzHpBofs49jEMJQEYKMLEezuji3LfooVtZKpBbu/Un1SIrSMEHhQqKTw==
X-Received: by 2002:a1c:1a46:: with SMTP id a67mr2833027wma.21.1553183236166;
        Thu, 21 Mar 2019 08:47:16 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c10sm8940049wrt.65.2019.03.21.08.47.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Mar 2019 08:47:15 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 4/9] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Thu, 21 Mar 2019 17:47:04 +0200
Message-Id: <20190321154709.24163-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190321154709.24163-1-tstoyanov@vmware.com>
References: <20190321154709.24163-1-tstoyanov@vmware.com>
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

