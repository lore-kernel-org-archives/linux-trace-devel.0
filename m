Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D98C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D09B120661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfCHNob (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44586 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfCHNob (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id w2so21413689wrt.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=eYHZW7fksGxOz3giiEQURtbtPxmCImoCT22/m7/vjUr5XvlLavpJux9dXqhFbiGBIK
         huEeVv33sT7zt1IDVSbjHN2avFc0QbHZNk8vyNVvlycGX4itj6WF6IbYi2uMCOaPatFW
         yBm9e2XbtmDX+pJA7i7Nn+5JPnYsve/s7ODytjvhgVkln/WAzE2Vl6y2QLqUl1qXMXyt
         3YWux6D01DiWG7u/8RtDD1BzJE8jz4owjVPmwGjStgqgVZX1wTZ4KD7Drw2ecoVVcp3I
         v0fpTKgs4Btxva1T+X0Mz+CKq4ojqxMeJEg0wwa+kN3Hz0tNV0LwUds2We4fP5sigQpd
         o8aQ==
X-Gm-Message-State: APjAAAVwwP6Z5oGtbGhU9h+uwrkA4EuDlvAV0bjCxfzarmAMmW8T8RaN
        G1aR7m00jKVsUmB0XGjr9CIgmsbO
X-Google-Smtp-Source: APXvYqy9KgOcvoD4F7YJLW3hJEeQ8odWKZ9Ve8IOrJ7w41mhfKXnJ3yYRsXEy19w3yWf9pvk5Rq27A==
X-Received: by 2002:adf:a382:: with SMTP id l2mr2284647wrb.79.1552052669318;
        Fri, 08 Mar 2019 05:44:29 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w4sm11631872wmg.8.2019.03.08.05.44.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:28 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 4/9] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Fri,  8 Mar 2019 15:44:18 +0200
Message-Id: <20190308134423.22008-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308134423.22008-1-tstoyanov@vmware.com>
References: <20190308134423.22008-1-tstoyanov@vmware.com>
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

