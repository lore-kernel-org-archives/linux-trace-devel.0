Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9F8C43444
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E6BE20866
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbfAPTSq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 14:18:46 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45796 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730803AbfAPTSq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 14:18:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id t6so8220015wrr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 11:18:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=KT2XmiO/jVgVfkdG0oEZh23/Vk8OuxecYf+tQihfWaGu+Eebvskx5AiYyBTI5Tqh8L
         uADj+KycSDv4KE9ZZhvxEkm1sSnmyFWUKg0keF6rwy32gYMedYMGFe0gWkKIm3ii6NOr
         67uzE05cPhjFyhlydHzDMxqgblX2tOUMDohKqerIOTXLmb8fP4MXnYpHR6akZdZzeNnB
         fVpZwDuRn6Tig25UxAyPF4QeBespavmMO86uWCs56R9dq43VV89MZt/N9QHBRx+JDals
         Ko/mGkcvzacWchDBIxbiadp7poe5PdU/2HFPjlOpeTbytcZjAbhEwp1+NiyOAXAn6Www
         1Xww==
X-Gm-Message-State: AJcUukeXACzEi5Q6FDbLtX2aIz0rBzYL64jI2tE4zIHLBGLDzZUaJAmg
        ZN1XblCMH54V5jdB3qY0n3M=
X-Google-Smtp-Source: ALg8bN4SHXAY7YjISet+roIIodlk3mCOcmCj7X3rqmlQ1+7tTeI+4wOKSiE9yCwy/Q8F1P8vPyH2rA==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr8436943wrs.7.1547666324786;
        Wed, 16 Jan 2019 11:18:44 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm98393345wrx.50.2019.01.16.11.18.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 11:18:44 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/7] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Wed, 16 Jan 2019 21:18:35 +0200
Message-Id: <20190116191838.32127-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190116191838.32127-1-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
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

