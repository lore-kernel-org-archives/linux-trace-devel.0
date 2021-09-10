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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5280FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3237161208
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhIJQkX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhIJQkV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 12:40:21 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471B3C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:10 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a25so5442812ejv.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Ztix/mSisIcNTomnFYxEhhxtgmrLBPkGI5Fz5tlIKo=;
        b=HTBzJ6RTnI3fx1wL3lG2ldhPcTsrAHWfoVucIxwV7aDw2rfvlqY+2NjgmoKpOfY3xJ
         jzRsEtVKaITy6itMN6ouzA2MDYkBrHiGDvqDVppBLr1wvzXURJhLsFnxl3oQeLjDkeaH
         FIzxYJx26Ft78Q15l9WRNKsMf1RFIi33iUajk+F6hZxX7zS6n9sUEOykF/cDGlA0agBj
         MzCPwK4OgtCh0s/dezgOJug+tkK/BSmNuaSCpU82umOFRGUOUqDxLLaIxbOUcJFaO39g
         ah+PFobL1w5px3cIPBuk29zC0qOnrNxq+Ae4onAzO+QSlDe091rTwizRySjXFnidWAK1
         m/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Ztix/mSisIcNTomnFYxEhhxtgmrLBPkGI5Fz5tlIKo=;
        b=TZTYHNHUER9v6cq6C5GjVZWPzfVxdxQ/dTjlqTgLNEU87vIfljfnXDvCnETB9kxrtt
         ETDE6L9KP51nSA4I+h4aPbo12DAD7u8tV+O20Kew9CtpB3+CL10fPcLjdKWB8HDQBO3Q
         zj4JCXjpx9xkx4uOLuEloxC9vsxnZljf7nzK5vwn6P8aFTKFhZKSkc7TRKUTKeeHrY7J
         W7jyJwZFgBc88HZGk0DX/4HYFEx68X2URpEaggyDKjs8CJg2DJ3++5foFNfKR7QjJZxj
         +xcgztAZKiwNkGAHgbqyYrSJ9Kd6OrfJ/loEX5P/hflt/8G6XA/DtbdlGHi7+PE2zvzm
         vBVA==
X-Gm-Message-State: AOAM531r3gzGWfIQiy7bzu6KjtyzCk5nNDX6AaUItt0j/hUk+FzcrRTc
        5o3p0bx/aQ7SDJ+iMpFit6s=
X-Google-Smtp-Source: ABdhPJyYAor1u1mZqGpplZawmp1BO8pbWtMC4u0HXEQ0YAdkb1O76o8dfO5gKxyhxIJCCVD5HnvCwg==
X-Received: by 2002:a17:906:9241:: with SMTP id c1mr10375347ejx.125.1631291948838;
        Fri, 10 Sep 2021 09:39:08 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id g9sm3095290edk.54.2021.09.10.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:39:08 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH 3/4] libtracefs: Add new 'hist' APIs
Date:   Fri, 10 Sep 2021 19:38:56 +0300
Message-Id: <20210910163857.324696-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910163857.324696-1-y.karadz@gmail.com>
References: <20210910163857.324696-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new APIs will be valuable in a number of different scenarios.
For example if the user wants to implement a function that does
the readout of a histogram, the only argument that will have to
be passed to this function is the histogram descriptor. The same
applies for the case when the user wants to print an adequate
error message in a case of a failure.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h  |  4 ++++
 src/tracefs-hist.c | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index c3fa1d6..255be9b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -299,6 +299,10 @@ struct tracefs_hist *
 tracefs_hist_alloc(struct tracefs_instance * instance,
 		   const char *system, const char *event,
 		   struct tracefs_hist_axis *axes);
+const char *tracefs_get_hist_name(struct tracefs_hist *hist);
+const char *tracefs_get_hist_event(struct tracefs_hist *hist);
+const char *tracefs_get_hist_system(struct tracefs_hist *hist);
+struct tracefs_instance *tracefs_get_hist_instance(struct tracefs_hist *hist);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 2ea90d9..175b627 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -34,6 +34,26 @@ struct tracefs_hist {
 	int			size;
 };
 
+const char *tracefs_get_hist_name(struct tracefs_hist *hist)
+{
+	return hist ? hist->name : NULL;
+}
+
+struct tracefs_instance *tracefs_get_hist_instance(struct tracefs_hist *hist)
+{
+	return hist ? hist->instance : NULL;
+}
+
+const char *tracefs_get_hist_event(struct tracefs_hist *hist)
+{
+	return hist ? hist->event : NULL;
+}
+
+const char *tracefs_get_hist_system(struct tracefs_hist *hist)
+{
+	return hist ? hist->system : NULL;
+}
+
 enum tracefs_hist_command {
 	HIST_CMD_NONE = 0,
 	HIST_CMD_PAUSE,
-- 
2.30.2

