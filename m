Return-Path: <SRS0=JQUT=5S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8248C43331
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 11:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B318A206F8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 11:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WqM/CD32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbgDBLAP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 07:00:15 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43137 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgDBLAP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 07:00:15 -0400
Received: by mail-lf1-f67.google.com with SMTP id n20so2293910lfl.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Apr 2020 04:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e3sg2NbhAbiy2SgdTDVquTcl4Fkh+a8KDnG0VV7fEO0=;
        b=WqM/CD32iDKVVlGiCtfMa2URcAfnmQfchS4wCkWbOF8ivdL7k5t3sdbeLdubX0V3Ny
         tQ91WvsrAeb7LGJVo9QOMBTTJZZD/nn7Ub9oHDjdtBWtIb8tWJXkw7RdQXIIlwVkqxyi
         L8FX6yVgoqvfYJmAv+yPl2CTAQQaaywxCLBitKH2s/oaX+7h+Q38MQi490D/48OGMw5M
         3XfyOQkl/ZS4TXDcv9ETJceLn4o9OCvqHyawd+nfU6s6y+pOnK334KROVopbOEsn57kv
         CghsvacFZKJtBRjP26nA5jucjf7wSu41qNml+KcpgM2R0UQLR72FE2oxx5aHpzLbD5dv
         AhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e3sg2NbhAbiy2SgdTDVquTcl4Fkh+a8KDnG0VV7fEO0=;
        b=lp/KZNlo/aT+u3Y+QdRo4QmSb8ydef59y/RzbOe+6ji2sLtagCAhJ+fvTnWdbG0h+n
         al6sztN2gMShLQWgMFOGBc6Cos1Bf74odbgB3OfDlawLudNyYd58p4BwWUHbu7dY3yCv
         znd8muTWspu3b2y4RyWjtbya2/HSBHn4ULHYBeDezwK57o+zX17TltVUKxn2ZyclJx61
         tMf8wsjYsvzgb0t66g2L1A62FwZ32fwu+haeDTVMt/sWe2plrY0SMz8+kfGFCoiaQfQP
         OnsZV+hvjERQj/8yyD/lRBhkPubtWxlOTMv9+d1SqNFhRbGTZwiLYHVOtnOq04KqTb3e
         Q2Uw==
X-Gm-Message-State: AGi0PubGgAF2c04DtF0zV9/0+60bDkWn5X4AxsdSujMAlVfF+/G0yXAO
        XmE3W58N54Hj+1yWupwoNG+clXGYM/o=
X-Google-Smtp-Source: APiQypLNX7LM07ToZ9pvEKDJ7epKI08opINFDsf0ZrgPvEH5z2xjJOPDGqY9U3qX+V++L1SHlxK/+A==
X-Received: by 2002:a05:6512:3115:: with SMTP id n21mr1805404lfb.51.1585825213097;
        Thu, 02 Apr 2020 04:00:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z1sm3706252lfe.49.2020.04.02.04.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 04:00:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix possible usage of not null-terminated string
Date:   Thu,  2 Apr 2020 14:00:10 +0300
Message-Id: <20200402110010.264073-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

According to the
   readlink(const char *filename, char *buffer, size_t size);
documentation, the terminating '\0' is not written in the buffer.
As the buffer that is passed to this API is not initialized, this
can lead to working with not null-terminated string.
The problem was detected by valgrind.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-plugin.c | 1 +
 lib/trace-cmd/trace-util.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
index 6bec18bc..92f9edf3 100644
--- a/lib/trace-cmd/trace-plugin.c
+++ b/lib/trace-cmd/trace-plugin.c
@@ -199,6 +199,7 @@ static char *get_source_plugins_dir(void)
 	if (ret > PATH_MAX || ret < 0)
 		return NULL;
 
+	path[ret] = 0;
 	dirname(path);
 	p = strrchr(path, '/');
 	if (!p)
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 04dc804c..0ead96ea 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -269,6 +269,7 @@ static char *get_source_plugins_dir(void)
 	if (ret > PATH_MAX || ret < 0)
 		return NULL;
 
+	path[ret] = 0;
 	dirname(path);
 	p = strrchr(path, '/');
 	if (!p)
-- 
2.25.1

