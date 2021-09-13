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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F74C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6DC60555
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhIMM3Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM3X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:23 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11526C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:08 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u16so14415454wrn.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZeyT15SqFOCewNiJ5wWZIoGsE6RejnJ66ku3xcCgS5c=;
        b=Edi6MP/+qAiUu0CfD5hyWUzQlRZf0w677ECBuXP4lBDrf/8ZN2DhaeOFZbk9SrDz0n
         VqUoSecC4pBLYs6Egmy/6rzgtfaj92Za8QmYujZKRQRla7+TtgbvmK6Ptni5IuBBCeWj
         WTWng2/eERViB89wakwKxzLTLO/2WUBTpnMTca+jPNLfuEUzaaThaGWgq0JCaYXJmn3t
         Xvy+NGCza6gf3hVLqZuDMB4O3XrKLunkb2iLD3tf9kz0/sctdp1gBDie78z2cliwVxI3
         H/JVtAg5XKwp1xSHhoUTEfbBfoThRKNo5vTyPAF6q1v73IFjlv+RsIMNShPkDfknHF3U
         SP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZeyT15SqFOCewNiJ5wWZIoGsE6RejnJ66ku3xcCgS5c=;
        b=AYoEDd9gKo6ojFjBQyVTyHEu6oqh5Iy5mjM1SPHj9fJ98dgLfc4QwYGcCyNmrettzl
         KCFYmTn7cNjGO39PrzxPsi6Eo4q0QqPdP3mgpqUXHdqdJJK5k6/qs+ZaJUJoabtmeInl
         SRrMXaZN3royIyb0lgKqG90rUYdJfhFSoaBcfLAk9Eyx2w7uEHW7Ige+OmU8b4YieeXt
         vA76XxttE4GPTxN35V/hhDDOc7Xcyea3BDpTaT6f7xUQdRe1332o3DYd39MS/4DmPPp+
         GL9mjGk0LjexeXBA62WOXkFSEJjkCFn2outwmHEbGql7EsbRwVo/2Ld0/48zXZidWZJV
         sGAw==
X-Gm-Message-State: AOAM533T+gvAK4o3AlZQuJRi+Sd1S4NmLDqAhIywsFiDop0iRLNHm8kK
        pItxB9imIyLIzhe47WWw9Atm6NxXuSA=
X-Google-Smtp-Source: ABdhPJxyjL0wRPPkSax9wMwdXfAubggfzUneLWwYnXJccekhKDMH+SKlstcewJm6EuuNhy1+IK/SyQ==
X-Received: by 2002:adf:cc82:: with SMTP id p2mr12561553wrj.5.1631536086740;
        Mon, 13 Sep 2021 05:28:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 05/21] trace-cmd library: Do not pass guests list to a buffer instance
Date:   Mon, 13 Sep 2021 15:27:43 +0300
Message-Id: <20210913122759.3672494-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace buffer is read from the trace file, a new input handler
is duplicated from the top one. The pointer to the guests list should
not be duplicated, as it could lead to a memory corruption on
handler close.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ffe87e8a..e5c8c332 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3966,6 +3966,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
 		new_handle->trace_clock = strdup(handle->trace_clock);
-- 
2.31.1

