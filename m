Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC59FC432C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2F98217BA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7kVGB38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfK2KRm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:17:42 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37734 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2KRl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:17:41 -0500
Received: by mail-lj1-f196.google.com with SMTP id u17so4018573lja.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xcPmnM5x0UQ4YKDSV2MogiGotivYJlB+VWUCe41AAqY=;
        b=i7kVGB38wD2pdiZfXsm8An0tMqwFagcRe5Ou4H2TQR2uERfW1Dpah8J+53A07Xtzjp
         hveaCpdgzal/F0+PVWmyNHSkC6jGHgMzx8yvzdhftUnHH/RPxisYDZmF6hlO009doZ5F
         yAsCOd3j31CQ13fwH+Vs2+pBPSC7FpbXTYBbvKxF6ISj84814RmxLH6difBvEfogwIIQ
         KRFf65qhE2ESlUQ506gcpn+lh/+XZFM+zIRQtXbKBZYgNG+f1FJQ1k3AkUhzwp7IIeWj
         0Ud+bjzlAqGfwH7Q9Kg6zN9VYNB03MKVyWByC9X1odK9Tm7mxlOwh7god4o17pgNC489
         SEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xcPmnM5x0UQ4YKDSV2MogiGotivYJlB+VWUCe41AAqY=;
        b=gKzf73XbvWqs0ZpVSL9mBZYIF1kQK7LshfV/7vPSFM9WkQEx370hXkHYfDeg8cUg0Z
         xHu+Zn8pHpCWMEB4xODQuqUn1eIeSi3TqdpEnahNqRjeVdakuUXOcZyEZsEwTY7bP+e8
         swKOlrX+iAMuo1+Hf+hMX6a/PVW5+ZLTU+q8mREOTxwuhoQFOYURwnqCtDpT8TEG9T4Z
         W+/aYXSpxlYvGL9rBIKbDVzbZAiJEpABmRe7ZMVriUiVNIs6CFEdnLG54rmaIgBkGxtZ
         HLb27kX4chDfQ8zHvIgSvCr+aSc5Ao5KsqJ7pbELjya9D+Yzh5aXIl41tGoX/pPlJkPH
         q3cw==
X-Gm-Message-State: APjAAAW3IlSFbBulPqWv8vIirQs1/Z/FAFDERFJHnleNErMYmH3FA9GI
        Q0O1D+E7/uBwVODuOkvk+tQ=
X-Google-Smtp-Source: APXvYqwA5NbWA1vLhPEBFov5nGU+Z9dcU76Li+sCgF4OMEpgs8LyVKjC59rC/fJzEJhPur3QN2uztg==
X-Received: by 2002:a2e:890b:: with SMTP id d11mr9045425lji.232.1575022660102;
        Fri, 29 Nov 2019 02:17:40 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:39 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 03/18] trace-cmd: Add implementations of htonll() and ntohll()
Date:   Fri, 29 Nov 2019 12:17:18 +0200
Message-Id: <20191129101733.375808-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129101733.375808-1-tz.stoyanov@gmail.com>
References: <20191129101733.375808-1-tz.stoyanov@gmail.com>
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

