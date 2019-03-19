Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94674C10F03
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64F9220857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfCSPzo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:55:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39967 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfCSPzo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 11:55:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id u10so14576523wmj.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 08:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=iZU8c6P/t46YLZiGSnzudm56Tu56JFE9S5XMB4hwBC/Mm0ZxcOzE23uVCbIH/7CS60
         JWcjtFAA++/XzDYGFI2i9D5BBtnlSkpIKb+2bC8O6AF2udnS9Y2hlvzkPSp7wAh/bDPe
         k163nuw8lenUgDL0JP9AnYS09U+BpAi5OkkO9eQQQq6CBKuprbPgMaDN7dk3MmBn8AZZ
         R4fXkNpuUSAgb+o0kVZ88Aa57XeqSO7WOhHgHL1F3aPYCYarzkmJVPLRHXp1+9jYsTKK
         91fbaLadG54fozJNLLeeIk85VhKlJvdvGs6sGSj+1oQiScvbcMomdG2P4700/RJTUTC7
         dgjw==
X-Gm-Message-State: APjAAAV3LEaJnY4MqwDQ/lv1x+zxIHCX3pxQ9ECnFyLK5EIcYiOZIsU3
        mw4nF9n8sSlIlZvNU/0IZ7Y=
X-Google-Smtp-Source: APXvYqyzSXVnye5JCticT4pyaYs+DvcUwLbPDpQUxr+eEf1DswvxSygDFnuL/6Sh/9XHas32s9nnCw==
X-Received: by 2002:a1c:1986:: with SMTP id 128mr4149843wmz.107.1553010942283;
        Tue, 19 Mar 2019 08:55:42 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t15sm9365911wrr.16.2019.03.19.08.55.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 08:55:41 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 4/9] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Tue, 19 Mar 2019 17:55:31 +0200
Message-Id: <20190319155536.19381-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319155536.19381-1-tstoyanov@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
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

