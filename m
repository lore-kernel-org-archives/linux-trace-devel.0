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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA49C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E884610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhINNN7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNN6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:13:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019EBC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:41 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u19-20020a7bc053000000b002f8d045b2caso2513939wmc.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6uflLdcxtwKc9UdYaXGxzpx3D+nzjM4vg/8RpU5kByg=;
        b=k2b8JOCYsE5SJgylRZePDaErpp+VjrXFe8jwbuCkrFcDXGl5pUhH7eFeSJxfKA5bM1
         IPxU4PNKdRUOqCT5hl/mF0oMLmo6db/+i3s42GRVJqdtnLMzl9+F5M70xoidmVkXZKu6
         LiPkTic2IwKPah2QFcIyQH98D2vH+3HT17TXMUC3lEuwPMqHnr7c8AQPIDPOvKz3zn2O
         CQsMvxuBWWWM8Y167FXZYDs5LpTG35O9MPDb7aGbT08zqZ9F+dqelkp16PbpC5AZ8ZDz
         3pK5jxU+JsssviW4dNWM/siGwqmiPm9Fi/MSBbM2mJKXCED1HXJxFYYxiu0jj+FMXSEO
         tWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6uflLdcxtwKc9UdYaXGxzpx3D+nzjM4vg/8RpU5kByg=;
        b=YWO2snB4z2XGg2Pql9Eg9HcfoxX7I11WMAJO1Rkq3pp8nYzpNLmCxfM4ikF5E/SJy7
         sR0iYUoin0+jMBRKu7BKvI8Iy7HzwysfR1OhrBzAhzm0EOm6aCfsfJ8LVO2Pyl/4sQjl
         Qyb/RzyDHvLfhUAeHwJ03s4y3Hhxd1r5oKt1OEVLfKbrRoMpCLnw2+8yJpneFQspBtcF
         u1JG4mHsOmPB3CamF3E+vmm/CVM4knvH3uqHiDwsRP5qTfbPFfao0SzI0YmYQjxjmowd
         zDSn7IJr1VfR98/3Po1/K4AklcdeAOSP1O4iXH1plXMw7LKNsFTYsHL9S4jSjELuRMJZ
         2DTw==
X-Gm-Message-State: AOAM531SJd/1OZFH01fXX24GWEZt3fTZNUuhrvHd123Q5hpLUYYyzr2z
        F7ytz1nZ6htZhyJ0xy5sze8ZN/rOYz4=
X-Google-Smtp-Source: ABdhPJyhvD7GgxjzPmsvQ8W4XQYqST94/TtZZoqEyxKPf7ssd/tanYHO0pZX0ri1NRLHyfLMTm6v8Q==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr2138872wmh.61.1631625159558;
        Tue, 14 Sep 2021 06:12:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 04/21] trace-cmd library: Fixed a memory leak on input handler close
Date:   Tue, 14 Sep 2021 16:12:15 +0300
Message-Id: <20210914131232.3964615-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When an input handler to a trace file is closed with tracecmd_close(),
the list with buffers is not freed. This leads to a memory leak. Added
logic to free that list.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9253bc37..ffe87e8a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3484,6 +3484,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
 void tracecmd_close(struct tracecmd_input *handle)
 {
 	int cpu;
+	int i;
 
 	if (!handle)
 		return;
@@ -3521,6 +3522,10 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->version);
 	close(handle->fd);
 
+	for (i = 0; i < handle->nr_buffers; i++)
+		free(handle->buffers[i].name);
+	free(handle->buffers);
+
 	tracecmd_free_hooks(handle->hooks);
 	handle->hooks = NULL;
 
-- 
2.31.1

