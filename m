Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D28C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D96AB2070D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731491AbfCZPG7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:06:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44381 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCZPG7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:06:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id y7so10656165wrn.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Mar 2019 08:06:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZrqIpIWaDsmqIPJyX90jfu7nox1DuIvSLjj1esD/k8=;
        b=IxG01f8QUUKtfRuyR04cHnwlsgqgeyoFUk1HiYMSK7zfZruI9TLT0qBTRaxChK4kts
         b6xdrawGj8uq2A75xdsvskeH5AW7dixYGOKHav6zIRajaedFRZnAoVte+EDAZIihFm6Y
         QK9bAKPfYEGOLh5LhfsHE2A1bZecGYqD/VNCBfrXXi0mzqb8tcIJTN7QN/xYw6qYB8Ur
         Evxk0USoLWHCspiO9qFIsdnrkuqJ68EVN955NYhbzsaX3mt21sApHL9q9WaTchEJCWd7
         TAumw7pFq1x8H94ViC/vPL5WEN8rPqdF/juamj2cFGKMDSirmsn0LEJrxzg25H407atN
         bz/g==
X-Gm-Message-State: APjAAAW91uyHFwlT37Q6F2fwskDHfmKU0atzHoWz7M1eAVa6/4fZBmHa
        5yhvyqTm/Mdq56j4qSMrf1AugDFn
X-Google-Smtp-Source: APXvYqxJS7hhXfazRVBfVGkcB6pRX1obDo6n79GYWhl915P4ArWoLWKvPzF3j//9ok/9KJIywwdK+g==
X-Received: by 2002:a5d:4a4f:: with SMTP id v15mr18639718wrs.5.1553612817964;
        Tue, 26 Mar 2019 08:06:57 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 13sm6833631wmf.23.2019.03.26.08.06.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:06:57 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 4/9] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Tue, 26 Mar 2019 17:06:46 +0200
Message-Id: <20190326150651.25811-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326150651.25811-1-tstoyanov@vmware.com>
References: <20190326150651.25811-1-tstoyanov@vmware.com>
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

