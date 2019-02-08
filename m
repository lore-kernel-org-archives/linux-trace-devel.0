Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01C1C169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F68A20869
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfBHNt3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:49:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41940 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfBHNt3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 08:49:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id x10so3627270wrs.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Feb 2019 05:49:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=Ll6mlVy2YBURCch36Mktgf9/ASIeLXNtpoPUwN2ptWvvOkRO4mcropKg/yW5GGlPK9
         6YJYUsKFMMJHdPv2A9rf0eWGEDi7RS+vkvp4uQLVOsA9SDipNui31yDoyHKmxX08fnYf
         vchOGk8p0k2LfrWy+csXaeZ/ylFt1Uh0paxEoItka8ui1YESRrZM4kPRc4scB15obYNA
         UkVafWB3imusG96jSY2ugcqkN51/vGFocQ3Fn4QLjj73NJcayjHtha7j2xhqAo6ECqiQ
         ZXh2ZA/fswHg5ER8UteKC0QXRmKLxHmn2lT67X3RkZpyvuLJSk5jFODxw4q7H8v5qEUQ
         i0uA==
X-Gm-Message-State: AHQUAuah+LwX0ELNj2XfaaCyrcQkElWLpYpdOjK1f+L6dCnTLMQ9QLNL
        JzQjV9EbseIYkzh61aY2tVU=
X-Google-Smtp-Source: AHgI3IayuOhuNp1+84ECV/EgnblGyWFsvFNFa8vBT76s/kVq5eadQXgAUxAiozRnGBNYB91YpWTutw==
X-Received: by 2002:a5d:4004:: with SMTP id n4mr15913187wrp.80.1549633767501;
        Fri, 08 Feb 2019 05:49:27 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a184sm2534796wmh.37.2019.02.08.05.49.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 05:49:26 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/7] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Fri,  8 Feb 2019 15:49:15 +0200
Message-Id: <20190208134918.5618-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208134918.5618-1-tstoyanov@vmware.com>
References: <20190208134918.5618-1-tstoyanov@vmware.com>
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

