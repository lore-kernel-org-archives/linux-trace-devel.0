Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0503C10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91330208E4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfBVO2n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:28:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56044 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVO2n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 09:28:43 -0500
Received: by mail-wm1-f68.google.com with SMTP id q187so2144317wme.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 06:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=aXqe2kQskkavPK3Pi2xhIZm9vIyluxC8oeW3il+nIULgJ5vXl8xCn29XjpUX5Tw9oT
         R45EFawtvwa+nL/wf91eM3J4EeE7AC1c0XFfVpo6QRnpow5uYvDU2vTlm4Xx9BBjLZZv
         a9XpdZypXO6vXVmq9ysTUq0oWqq6ZeZcUZDiNnY23lb8/vTGZZU490bpD+4biySBWi0E
         s2Naust7Witf1zEwV5+2sMzrxYLiKg2+b0/xD4jIDuWPgUKmaf6EXBAbI90zFf1tb/ae
         2CBLNLWiwXNFr8u0crcMGrAdsPJ0lDN8eci0LgNrMWDaRK2qMM6Fetr3hRrth1+9OZ3M
         oifA==
X-Gm-Message-State: AHQUAuZTND5a+ArkEQlqm5x7HiJWs54rKYfCnsoJKrrBXWcvhpL+1ZzL
        oWWnu1yqrVSfDH9ajaBPtVJmCACq
X-Google-Smtp-Source: AHgI3IafLAfiiH494oWFoN1esJp5MM9p27Kmw6HND6CKaajcxD//3Ue6jOVxpB+ouQovQkZ1TPW99Q==
X-Received: by 2002:a1c:5fd7:: with SMTP id t206mr2686687wmb.73.1550845721737;
        Fri, 22 Feb 2019 06:28:41 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q9sm848987wrv.26.2019.02.22.06.28.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 06:28:41 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 4/7] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Fri, 22 Feb 2019 16:28:33 +0200
Message-Id: <20190222142836.12596-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222142836.12596-1-tstoyanov@vmware.com>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
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

