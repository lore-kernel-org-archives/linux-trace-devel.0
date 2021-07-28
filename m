Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3F6C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6CD60EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhG1Nd2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhG1Nd2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:28 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D877C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x14so3195681edr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qjf8gZDAEIXV6LoNKWZSIrOAj6brMR4fwqnQ1pVEicI=;
        b=rfNHZi038I/LMEPR4wfldpa4eluG51z/ym84jz4DS0h+nb1zFStkTXiSirjMnkozec
         WvqiHYDyGBbUhxFBbTG0c9Rseyj9v0coDfjhxgw3GAqMP+yVh9i2FDbiKTXRrCpYwZ+A
         rql8I8Lgb4m5KQFrXUSyCVKnANFcBcFV+Y+XeuUX01Jlg3F/c79/eqd7ebB5H/lUeUO3
         Vab7LeEh7zAr3sYEcw6F0XZVEZiUQuOFxSN5LNNP30kwTFzfbCb/+iScAGIhx/dBryz4
         b3nbbQRJOphJKt7VRCeG/uavlsfv4ZghbI/POZkopiB2lGswNtbR3p3bni88xLmhvhmL
         brWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qjf8gZDAEIXV6LoNKWZSIrOAj6brMR4fwqnQ1pVEicI=;
        b=k8vwHHosDEoEvyrIZB1kx39UvlvTwKkwHaaD2OLUCl41LzdWyYPcl6xeyU9ogzMzld
         r8xYz+rx+50zow17rkaIV4Z6vo+4g7zAPh76IhiALmesP4GFPuBGKtwkD8ppMSOdRxiJ
         Npa5t/oQJv4XuhR+5WMKqzL6x99knsyUOKMfOtph4Bznjyqw/14teLCY0axyZIoOmzbb
         fhTGZkXXXily8vHVTZAfOG65DiMnVmL7837jZHqLyw1LvM/Uyz+4rJ14pGHdpwl21hMQ
         HWQVwApuk/tYZjFs+3JA7f/l4KI8BYfiJipmdhLKxZO52iX3dOAAfWau8fWUvFbl/30b
         XrhA==
X-Gm-Message-State: AOAM532fpdM6Gfr+Eix+cGi8ACzy0/5/+SRiNuHFIuvhiOChuyVi89Ea
        gNcb7eIpJqC+97IMXzD9YIs=
X-Google-Smtp-Source: ABdhPJyvz8EOXe7QTgwQQNr+u6F7YQ0ZZD9vQ7VCJlfKZDnt4UA+9ihMmsCYeJgw7qzTHcynXmQyTQ==
X-Received: by 2002:a05:6402:b19:: with SMTP id bm25mr17011811edb.213.1627479204115;
        Wed, 28 Jul 2021 06:33:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 32/87] trace-cmd library: Do not write CPUs with empty trace data
Date:   Wed, 28 Jul 2021 16:31:55 +0300
Message-Id: <20210728133250.234140-33-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has more flexible design, which allows to write only
CPUs with trace data in the file. If a CPU has no recorded trace data,
do not put it in the trace file version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e6dadba5..0c6fcc6d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2331,8 +2331,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	if (i < cpus)
 		ret = -1;
-	else
+	else if (size || handle->file_version < 7) /* do not write empty trace buffer in v7 files*/
 		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+	else
+		ret = 0;
 
 	for (i = 0; i < cpus; i++) {
 		if (data[i].fd >= 0)
-- 
2.31.1

