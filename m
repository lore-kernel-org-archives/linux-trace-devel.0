Return-Path: <SRS0=aEXj=QI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1947BC282D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFCB42084C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbfBANpn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Feb 2019 08:45:43 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43546 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbfBANpn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Feb 2019 08:45:43 -0500
Received: by mail-wr1-f66.google.com with SMTP id b4so239418wrq.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Feb 2019 05:45:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=iQDyxT4jewetsDGUYyTjRZutVDdVF3iVsp0LBRant89wQDGh/Qg/OLVc6pUvYpoBPW
         eVwAVJLXN9KXZLXCU1WoMa9H1ShPXm1JMVhvqE6ytj5dFztHSRgJpVquQEEiOgkx3Jra
         ayh6HKkN9PbRCIAQDKQy3ichro3MsLhud3iss6jwM/UEnVAIF2DN2YiMDaAydIdmulTb
         WzBQPhJEUixQenoRaYIyiJM7GC4aalSl02+Wg8KHf2TWJyqR50C0PtQPDQeL2YQE2dvk
         EPnT+rn6+aVwIVk88W1DE9V3Sdmn+DzMYT7rQMYSkgp63pEry2A20VTYScmSf0M8J4JW
         4EFw==
X-Gm-Message-State: AJcUukf2M5qAwoOhKUGmV4J0oUUX9iJeiMLVVmv6MCyykAQURsjn9VpE
        lqP6sAA6u5zToz8Ywuvjhyk=
X-Google-Smtp-Source: ALg8bN4/0owydGVOBaVoSlw66Q31VUwEGEq0c+F4KVoAPBFbNcNlURIuUSHZ7En3DsoiAVwk48QyDg==
X-Received: by 2002:adf:9d4c:: with SMTP id o12mr36433713wre.94.1549028741879;
        Fri, 01 Feb 2019 05:45:41 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v26sm1468732wrv.78.2019.02.01.05.45.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Feb 2019 05:45:40 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/6] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Fri,  1 Feb 2019 15:45:33 +0200
Message-Id: <20190201134535.2979-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201134535.2979-1-tstoyanov@vmware.com>
References: <20190201134535.2979-1-tstoyanov@vmware.com>
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

