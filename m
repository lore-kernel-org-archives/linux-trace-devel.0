Return-Path: <SRS0=Y1eu=S3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FF4C282E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94BA4214AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbfDYLFk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:05:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38270 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730647AbfDYLFk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 07:05:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id w15so9924389wmc.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Apr 2019 04:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=YuMAIuKh0zN2vKYWSefMNUWJonunXIRBd+WiTXmBvjnc6OkDsuqrz+wwYVKhIh3SXo
         bPazj7GiIxrmv8dT4CIU0i5cYqw8hPQNpBkUmj1IMN17nISYdLnyMXVOu6lhzXx3LN2z
         zRLfk9OMXh5LM1/Ubde7JjnD1Q1y8yLKEXAQwTMoIs/S/+kEi+wxJlp4C1XOw10j55a0
         54FotDQdChEgUI5q/kljC8exdVSBnNh6ozPoD6ddGqi8WpHxU7A6MXmGeRHBf4DAfvYf
         b70NzGONHvjjb3SyJU/cRFhBjIXtuh30YXkSB964pAgil97rNjiPnou0RWp/JOYAVzIx
         1iEQ==
X-Gm-Message-State: APjAAAVhurE45AOj2xmGyHtREqTr7/czWtNjcsbfDcCTFxwuGVL0B06F
        oLpwid5lCQnuxote4/PJrk0Wo00Z
X-Google-Smtp-Source: APXvYqwoTa52Jlq8QNMAuMO940ZPJuypWKrU1BeAEOdYGPwLmvSKRYsHjGR5QwEV7rsCnZtCeuW+Jw==
X-Received: by 2002:a1c:f312:: with SMTP id q18mr3015275wmq.96.1556190337564;
        Thu, 25 Apr 2019 04:05:37 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a6sm23013606wrp.49.2019.04.25.04.05.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 04:05:37 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 4/9] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Thu, 25 Apr 2019 14:05:26 +0300
Message-Id: <20190425110531.8941-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190425110531.8941-1-tstoyanov@vmware.com>
References: <20190425110531.8941-1-tstoyanov@vmware.com>
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

