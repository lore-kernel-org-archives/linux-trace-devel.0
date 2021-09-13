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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADC9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A1D860555
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbhIMM3X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM3W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13413C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:07 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id g16so14443419wrb.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6uflLdcxtwKc9UdYaXGxzpx3D+nzjM4vg/8RpU5kByg=;
        b=MTHmD4C2FchSecpCLQ4LJQiM+ZXNxh69iycoy9eEMfGAAP8b4MRYZuyAauc1YJNAtn
         g0T5LUj2ycwAIxg1LF5d5vV5LF11mxZtfQkarqSR2SPz81YEP76/CPQwcBfVGjxSCRD3
         V3DHQFT1FFzIkWwZc6gdhDk7ZT+g3WzK2sLOd+uvCKpPnI2pFX5t7KinTpswRfupua+T
         JuKIWs4edTr0TY2WdfxnSeMULhh303+UP5FuoOZM20pLV7CsnhcK1nK80UZpi1GqLyqM
         ar9jJrCZZFWTzIbOZdYTzy1Um9p0V1JLqhkSbSM0R6Ftt5NIm+HH94ltjfnm8JNJT4F8
         RMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6uflLdcxtwKc9UdYaXGxzpx3D+nzjM4vg/8RpU5kByg=;
        b=BAbm8m+W9AvEJWeh3bH6pErHuzWowRDxsFItFLCZ74tzG29RDfE3Ln/H/E6BWJOWjN
         PRQ/mA14IEH8dDHvdFzF444nqqEXQb1D8wCf4RU+hOfOKyl1AMlLOWBAmdochfosmi3Z
         aOQBglwI92sf3RIAtoiTonP4nRMe8Oolb+KdUNiX+nyurlV3hg7TB8feFpudA9eURzfh
         LvJk8eHvI3PHpk/Mr2du+DMaQDfZUu+cApKMd/xrNSGTbMqAvTb2tUiVyih53S7dG4v9
         yJMreWLart0DD3//STgTIVTdnHV96eIFx5UYUefgurCSKbFiiBAA37/kJaHSWaZ+2om5
         XP5w==
X-Gm-Message-State: AOAM532XmfHYuDu05xg0FwWOE9NOGAvDGtGR7Q8A7r0RqyKg51urBZSH
        0X0J8mGMokqZtxJXghM80DCBS5t7q8g=
X-Google-Smtp-Source: ABdhPJxtiOUFqup0iR2DWj7Z1/VtTZ+bTArsINyeYHgHOMO+2egFzPHz3OKy8taQyD9arUWCrAXgOA==
X-Received: by 2002:adf:e10c:: with SMTP id t12mr12214685wrz.36.1631536085729;
        Mon, 13 Sep 2021 05:28:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/21] trace-cmd library: Fixed a memory leak on input handler close
Date:   Mon, 13 Sep 2021 15:27:42 +0300
Message-Id: <20210913122759.3672494-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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

