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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670C1C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 511B360FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbhG1NeX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236798AbhG1NeW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:22 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF417C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:20 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id o5so4678528ejy.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zEv1MZeUsNI6L/y4FA9YCqMxAgJ9KFRYM7MuterFTYU=;
        b=d+Gm/ZkQQ8DKDK7oGA9jeEx5wb1UXWAlBBP80L1EIjgfxV3y9LGaTQRODo2RKHRGAq
         JuA1e5OHdbxioPOwv/M0CNTI15gXzvfrweYaV5nzg/9j1erKl+EwH5LB3lprIzy4iCmk
         6Vx+9fgHxT5FfKdJkN1ldzTn/U52kdB+56/+xBCCUR/578qIzjksE3+OZUyQ2RabxFoc
         1umnA1hcrZVljKh0tkdP29uw5TDfRkS5Q4nkZrsX4lClHp9HMdZSO7sL6qwXLiDDdIEw
         qt2HF/ejpMn4gLc6JamxH9i1g5f1JL7SO6sCgUHmRLgF4DktGNB/H8syTlBbOlfru7/W
         7c9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zEv1MZeUsNI6L/y4FA9YCqMxAgJ9KFRYM7MuterFTYU=;
        b=doytlrNa7eYbfuEWfuhB25xYgEu8e5zPl1j8mZ6Njs2m3Gt+OQCsDvD65qtfVx/6M8
         k7x0wYMRKzJNnNVEQ2A5j5sPVfGAE6yoMarLxO4ipP1INGbiYsWUHAXVSYTzadvqjMKq
         YSpkU/9R6J2VxFo+QhJo6HbDbwtU+x1PTCRguCf2S8Kr4YQEYFh9u42LbCuNw08tPQnj
         /XmZl6PZMhHLkHLWFTOGvKsfLB4WZOktpGObGtAyfJl830MgZJLc48E5rqW9TSY/kD9m
         S2/0Hq8aRomF8v4RH8wvPs2Saoc3n0sxs0kKXO/PIOHS0Xv8YbtcfSOox9HLBAT4RFU6
         idOA==
X-Gm-Message-State: AOAM530Cf7GeNtNfbVSC0hTegYX9eiOsxcDAmK7hNSMVu+EDlIiOS5Ui
        Pk38OLVG4jG5u/cbx72MApg=
X-Google-Smtp-Source: ABdhPJxUDwgSv+NviA5HEKWGxL/whxj0MbIL4NhPxDRkf8VK0P9MStqvFvJRqoAgYpqj4TL1rOcaKw==
X-Received: by 2002:a17:907:aa7:: with SMTP id bz7mr26515356ejc.396.1627479259388;
        Wed, 28 Jul 2021 06:34:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 81/87] trace-cmd library: Set correct CPU to the record, retrieved with tracecmd_peek_data
Date:   Wed, 28 Jul 2021 16:32:44 +0300
Message-Id: <20210728133250.234140-82-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace files version 7 stores only CPUs with trace data in the file,
empty CPUs are ommited. Fixed tracecmd_peek_data() to handle that case,
set the CPU in the record - do not use CPU indfex, but CPU id.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 593ea3bd..c62d5fbe 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2404,7 +2404,7 @@ read_again:
 
 	record->ts = handle->cpu_data[cpu].timestamp;
 	record->size = kbuffer_event_size(kbuf);
-	record->cpu = cpu;
+	record->cpu = handle->cpu_data[cpu].cpu;
 	record->data = data;
 	record->offset = handle->cpu_data[cpu].offset + index;
 	record->missed_events = kbuffer_missed_events(kbuf);
-- 
2.31.1

