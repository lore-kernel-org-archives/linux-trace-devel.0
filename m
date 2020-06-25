Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F44C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE967206B7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5Dy7um5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390891AbgFYKF3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390534AbgFYKF3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:05:29 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2405DC061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o8so4955001wmh.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X8DLV5rRHvZhVX3GXW2sxLps5T9JPNZYA9ELLkrCsYw=;
        b=C5Dy7um5KuOsPXVvFrFQiMAMMHSdSew4Qpjnd2SfITUyeWTFiV4EQj6ckjSfNYWyy8
         ITMCxwGEQGKzFay6XbHGjpexQSbutApmkAkukTysELBFqx0RVLetktC8cgxubyM2ZHtq
         4Xh1nlfPUoJGtXjRrc7657M67uoGmmnlKIaGDj1qmBtCVWbCImR5pCKwck04J5K889Tb
         l1Cj27eEslUXYOnTsMuGfVrNLDDRWzJVOMiGNj2HHYyPtAhkBEFZNUqAFeqPrhehnSZu
         /TD2peT3HQMP+bS302H9AF6JVLlHcqweHwdySFAbINTjZFZEIvvljd/RMDZn+Hq84gTQ
         PbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X8DLV5rRHvZhVX3GXW2sxLps5T9JPNZYA9ELLkrCsYw=;
        b=V00K5SfGgvsTiEycVBvRcQrFLlvkRQSb4pmNdKwHhSGifsGqUEeg/fM+6V8QuJwbXp
         aunpEMNnwdMAufB5aI1434Y2yhJso716o3Vi9JxKY7MlPPrCz7Q9WyepP5dK71ExluD8
         I6CsNUtXLeTAG34Kzp8RvhFJG8H4hNq5yaEPnqCox/idYcxe6dH7DVtV5MB8SaR7FNaQ
         bZcNM9ly27WnOa4FIzs80QITXt1ZUZFFxm8lXFMADc/ltG1IkqH4lS959Hbn2iUaXp7Z
         KxLfEi6F1rFV0ijUUZyPqHGyK6eMX/P04OMIzxnYbeFBE3CsT64sJCMGMshC4Ir+9RaD
         xgGw==
X-Gm-Message-State: AOAM5338gCNlYr3khjq9H5X237fcR0/aSrk5OUx7bTZY9AFnLH7fHDoD
        lq2NvBnHzX8hjlpWBkBO3wuztbNcjWI=
X-Google-Smtp-Source: ABdhPJwYgsMJGHgC90nDBCTCgIX1Wmtmsg90XTrTVLk0tccr7Bpj/FObL9+EINvS32aKeUhR0Ud94Q==
X-Received: by 2002:a7b:cb59:: with SMTP id v25mr2419715wmj.141.1593079527915;
        Thu, 25 Jun 2020 03:05:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v7sm31268204wrp.45.2020.06.25.03.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:05:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/15] tools lib traceevent: Add more SVM exit reasons
Date:   Thu, 25 Jun 2020 13:05:16 +0300
Message-Id: <20200625100516.365338-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625100516.365338-1-tz.stoyanov@gmail.com>
References: <20200625100516.365338-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Exceptions require individual decoding (only feasible intercepts
listed), XSETBV was missing and the AVIC brought in two new exit codes.

Link: http://lkml.kernel.org/r/5741D822.3030203@web.de

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/plugins/plugin_kvm.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/plugins/plugin_kvm.c b/tools/lib/traceevent/plugins/plugin_kvm.c
index c8e623065a7e..768c658f5904 100644
--- a/tools/lib/traceevent/plugins/plugin_kvm.c
+++ b/tools/lib/traceevent/plugins/plugin_kvm.c
@@ -155,7 +155,23 @@ static const char *disassemble(unsigned char *insn, int len, uint64_t rip,
 	_ER(EXIT_WRITE_DR5,	0x035)		\
 	_ER(EXIT_WRITE_DR6,	0x036)		\
 	_ER(EXIT_WRITE_DR7,	0x037)		\
-	_ER(EXIT_EXCP_BASE,     0x040)		\
+	_ER(EXIT_EXCP_DE,	0x040)		\
+	_ER(EXIT_EXCP_DB,	0x041)		\
+	_ER(EXIT_EXCP_BP,	0x043)		\
+	_ER(EXIT_EXCP_OF,	0x044)		\
+	_ER(EXIT_EXCP_BR,	0x045)		\
+	_ER(EXIT_EXCP_UD,	0x046)		\
+	_ER(EXIT_EXCP_NM,	0x047)		\
+	_ER(EXIT_EXCP_DF,	0x048)		\
+	_ER(EXIT_EXCP_TS,	0x04a)		\
+	_ER(EXIT_EXCP_NP,	0x04b)		\
+	_ER(EXIT_EXCP_SS,	0x04c)		\
+	_ER(EXIT_EXCP_GP,	0x04d)		\
+	_ER(EXIT_EXCP_PF,	0x04e)		\
+	_ER(EXIT_EXCP_MF,	0x050)		\
+	_ER(EXIT_EXCP_AC,	0x051)		\
+	_ER(EXIT_EXCP_MC,	0x052)		\
+	_ER(EXIT_EXCP_XF,	0x053)		\
 	_ER(EXIT_INTR,		0x060)		\
 	_ER(EXIT_NMI,		0x061)		\
 	_ER(EXIT_SMI,		0x062)		\
@@ -201,7 +217,10 @@ static const char *disassemble(unsigned char *insn, int len, uint64_t rip,
 	_ER(EXIT_MONITOR,	0x08a)		\
 	_ER(EXIT_MWAIT,		0x08b)		\
 	_ER(EXIT_MWAIT_COND,	0x08c)		\
-	_ER(EXIT_NPF,		0x400)		\
+	_ER(EXIT_XSETBV,	0x08d)		\
+	_ER(EXIT_NPF, 		0x400)		\
+	_ER(EXIT_AVIC_INCOMPLETE_IPI,		0x401)	\
+	_ER(EXIT_AVIC_UNACCELERATED_ACCESS,	0x402)	\
 	_ER(EXIT_ERR,		-1)
 
 #define _ER(reason, val)	{ #reason, val },
-- 
2.26.2

