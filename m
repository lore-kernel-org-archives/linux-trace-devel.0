Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024C3C3B191
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36FFA24721
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBGpo+WS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLMPai (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:38 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32938 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbfLMPai (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:38 -0500
Received: by mail-lj1-f193.google.com with SMTP id 21so3124090ljr.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xcPmnM5x0UQ4YKDSV2MogiGotivYJlB+VWUCe41AAqY=;
        b=dBGpo+WSVElQrH8vbKw+1rzJN3xipDPxpdUGdF801fRH/eXfmsrPBzYlkT6fQRJagq
         xPnPEqeqPtRCpnVV4GNTLGXiC0oNgo5TBxYDtA6icOP1NU7HIshr/aCepaa8zeQg643o
         yPbQz2Nm0yKZM3vHSo9/GqqolY5NULZP4dbaUxLysTgp9phBXuRAU9s5H2Yt1H0BI7gk
         QBH3skvp1rlXNfpCBZpH1fItWLzXnYE8mQFcPSZM1OjA2Z35HUeHYNYQs2PZQqsBAoPq
         +wO2W/LC7ePkpyjOP+LXeLjWLnc/iUp4tT67zyd97ZWgpsV7ZSacBcig65nTRV8dooEz
         oXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xcPmnM5x0UQ4YKDSV2MogiGotivYJlB+VWUCe41AAqY=;
        b=aSwINJzjtGkCJEOdkAo+lCcqOTllP4HbMj5OiV67w+TXqTPP94atFeoEA6iqycIrpw
         OfQY3Nzr23s1LqWLd3PD/dgn4tubo81W+nBEGA8RjFbfim5mA9vyxS0LwHHh6/u9ui1o
         Yeq6qtHaqwtWqVjmFOlv8cRf71iIqUbGRDuuyHplyJeg/qRYrrEeR4/gVXeyZvNwoPIu
         Yzxq9rEGUXlEeTSLnkIFIXHiG4QDGtNi85hyBmN5BpYuvJ1qmwT8OP9vbrX7SRWYoIcu
         qrQDJFILCZhIGlp5LuTQKXX4wIPFSlSAvqJVWSznN2okYEkiX7Eiz/XwCrIaMvYPY086
         CK7A==
X-Gm-Message-State: APjAAAUhWJ3sG7SxeMWE276ZxshLj/AdlwSSzn9UIZzxVibWsV92+j65
        9GqLJXTD+MpVo00rhjMriiI=
X-Google-Smtp-Source: APXvYqx3o2TedypCw1JhjglrbJlSIfaRfPhTYIlcF2dIARClUs4Wwmm1TK8DoErEpDEjuxOdMRnI4Q==
X-Received: by 2002:a2e:81d0:: with SMTP id s16mr9516377ljg.166.1576251036049;
        Fri, 13 Dec 2019 07:30:36 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 03/18] trace-cmd: Add implementations of htonll() and ntohll()
Date:   Fri, 13 Dec 2019 17:30:14 +0200
Message-Id: <20191213153029.133570-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Implementations of htonll() and ntohll() are added as
macros, if they are not already defined.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-msg.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/trace-cmd/trace-msg.h b/include/trace-cmd/trace-msg.h
index aab8a69..654ca43 100644
--- a/include/trace-cmd/trace-msg.h
+++ b/include/trace-cmd/trace-msg.h
@@ -12,4 +12,14 @@
 
 extern unsigned int page_size;
 
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
2.23.0

