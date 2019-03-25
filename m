Return-Path: <SRS0=I4ei=R4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE59C10F03
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2CE42084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfCYOYy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:24:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34147 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbfCYOYr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 10:24:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id p10so10420463wrq.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Mar 2019 07:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=DTxEVUpbKQ7yq4YIOL92VNMcr9OD11ZO1MEtvWrhepPPrsnUoRJ8+ePF7CXamobRxy
         +nMdXTtPWjLtjW03CtjnynyHoV4rKe0bN5yanjPiGX014h2rrx77PkLHlkyxg9VvBWb0
         PllMcZ1TQHxW6lm0cXhnb3f/0XjfLJXBU1xfOYyAC651D45FUjyZhgjnnGS8h7Q1tA78
         c0k3LZMjvG6dgizSK/4jUHMz1pBo2HeWACIjAqQGg++5gIA17h9gBzjmZCX2pH6eJ7Eg
         FkPdtQqe9pDHy6zTtWcfEp2s7pUwPoXhwxdiWZS/oPrDdAAvnMGM+SBgUpB2FPB7wSXQ
         PqHQ==
X-Gm-Message-State: APjAAAUxPsGLLac03mm1D+d4Du6nYQvb/yj1xK3yAQvNsrm49DDtRLAF
        j37EYUmR/QN469KnNeknYPA=
X-Google-Smtp-Source: APXvYqxqtZf02fVD5m9MEQOJkWQuAnkSYFot1eI3X5NlDFLBrxR0jkjyHsv+YJDYTigQ6AohREXdHw==
X-Received: by 2002:adf:afd0:: with SMTP id y16mr15330323wrd.328.1553523885738;
        Mon, 25 Mar 2019 07:24:45 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s2sm1293440wmc.7.2019.03.25.07.24.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:24:45 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v9 4/9] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Mon, 25 Mar 2019 16:24:34 +0200
Message-Id: <20190325142439.22032-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190325142439.22032-1-tstoyanov@vmware.com>
References: <20190325142439.22032-1-tstoyanov@vmware.com>
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

