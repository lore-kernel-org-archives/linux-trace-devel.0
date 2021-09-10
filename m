Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75D9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D092E611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhIJNwb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbhIJNw1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:27 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE091C061760
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:15 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eb14so2580407edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MaEImYCpiN2XvKjRe0HOg1Z2ewmWFmNjfG7dnGuv1G8=;
        b=hN5YXsmAjLJLPNx9k2H+DulJM7k4wxVbG+xvlPwC8oX94hKO/G1eBGnx8MwHG6K83U
         HMnOcvlB9P//utviD/kepjq93MmklEJDs5QzKg0Wz2fTIoCq0E+MQguhefAMRcU2d+2B
         66xFtwVc4nrOuPpcPxEyx4iZgGB44MptnOMHIbj24V/7hA7L0zK2e8n8HuMcnz7xItpb
         oIhkha/4zT7Z/blfrL9IPpGqFQ4rLUNiyO+NkVCnATuHlsLuc9iPHFZLsUtXbJUlw84I
         e9Bf5jJLtI5iuor5DQ/jZODWbD7BQsLCjU/Qq4a5/CTwlqD9+08TY4dU839c505dEHtr
         Mo5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MaEImYCpiN2XvKjRe0HOg1Z2ewmWFmNjfG7dnGuv1G8=;
        b=Cal1BNg0nz5QHSzLHylMBuyFU4dhihueCBZ1v1vJbousjAh4TKWB72H1hdyCJ0L0an
         es6Yp9nOuPdxQXCT9Cbs5oWhyZvv/nfRHYaKZOnx6bSA8cSQ6hTfHqrP4+7FW8juq9pZ
         4e9a4EOFVlww6+DHuR9uPhrUSOo6Ijrt18VbqaHdUBJq0WT5SsMzBEamioatxEgQKZJf
         Tbq69tdh/jf0ot27hHVzPhrDKzs7b8p/LOiIlPu0kdi9kAd3cfBy2Ma81C+yJGkfVp7z
         aej0twzOftzGUimpMKrpYXTes2iRMWmAht8doj9QtXmdL1UgAOKF9eVRM6z3vIKm1bM4
         Q/Vg==
X-Gm-Message-State: AOAM530OV/NWf0oifIC4HoscHgkRxTSoubZM38waczLuipYpOC5OuBR9
        G5O4fOSDsOyB65hw+KkwPWU=
X-Google-Smtp-Source: ABdhPJxLOJSXNPe7QRra22CZeCNkTydJAJp1u/nfTXM0y2gRGENq57sQkBz4zGyfTLw1Wmx1ZmrMKQ==
X-Received: by 2002:aa7:d0c3:: with SMTP id u3mr9018804edo.158.1631281874507;
        Fri, 10 Sep 2021 06:51:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/25] trace-cmd library: Do not write CPUs with empty trace data
Date:   Fri, 10 Sep 2021 16:50:48 +0300
Message-Id: <20210910135101.2865226-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index 0e928858..25d51cf2 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2074,8 +2074,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	if (i < cpus)
 		ret = -1;
-	else
+	else if (size || !HAS_SECTIONS(handle))
 		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+	else
+		ret = 0;
 
 	for (i = 0; i < cpus; i++) {
 		if (data[i].fd >= 0)
-- 
2.31.1

