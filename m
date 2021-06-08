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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E08C47082
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9217161351
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhFHN51 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 09:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhFHN51 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 09:57:27 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506CBC061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Jun 2021 06:55:20 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso2016964wmi.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jun 2021 06:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uXsrh8XAqCRsJNUF8izn/jBJQ2kGPlJB7DeWfnr9SFY=;
        b=Kt4bWoMdPz9DfttmCrmpBWZ3ihCgrllN6TNSmqOvixFd6AEww7fojstQMZd+bVYTKl
         ghjkRoTAM0vlDDM1s/H6ODLXp50jl16v+DfndReQEiC6vF59zTqzCgAbPycUVSiPFssj
         No1mZvonb3Y8DNx0mLZuWNR31jwQdMZ+gwNIp9kZ4Avza/23JmWVfOCjkkBBuKoUtCev
         2jEc1dD3nJgfH9853zrb4cFWmS3dFz+sGIy+ajtoYi2zbq3Sl3ntmxiZxXbjVNrh9DXM
         bcE9H1Z+M2f8iZjBwMT4GJUERAA9TErhrPjk/T4lsBHH9eicESU4bUhXhQnClQvhrRhf
         mVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uXsrh8XAqCRsJNUF8izn/jBJQ2kGPlJB7DeWfnr9SFY=;
        b=YtEFNDIExRLtbOrPEIdKCCpyHebq9lkWhtplqa6xvb4XhYjMCQ57ag7109Emq8c/1d
         gx1frM7Xsq3beHB0mzb7Sow3kyjszL8mpkQe5veDTUwaq1HQWXaLiA80aH/L550U+HBL
         SxFJF6hmK1ecC9yD10PlKH0qAjiT4A4K7JQ12XNeHx5k1UHXOaClHl06UtbKimS7NQW4
         9UTV02U2WHa84LuYN+w2YEuaXI4gpG3KdE6IATcO397He2/VFEFn6TsaYdODtgGhOocp
         012vgV7f15gY4CHqFkJxLPDDdp8oqk7u0bjylQFLfYDVe8Io5mPduRURTytYWSGkbMyk
         hUkQ==
X-Gm-Message-State: AOAM533AVuJsa69h5X8kBr6cBNn41+EeGZ8fEhMy09mjwvJ8f4ZueHO7
        pyE95mJRqq4tP9nKpE9psVo=
X-Google-Smtp-Source: ABdhPJyYi+nWFD8nDhnXbpdx6L+mcVo+UXg+kRSWdKRVOTNIYfir4xld3fghbLy6QaQS/pOVkbu+xw==
X-Received: by 2002:a05:600c:4fd6:: with SMTP id o22mr22243092wmq.83.1623160518117;
        Tue, 08 Jun 2021 06:55:18 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id w13sm6806973wmi.48.2021.06.08.06.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 06:55:17 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] libtracefs: Fix typo in function name
Date:   Tue,  8 Jun 2021 16:55:02 +0300
Message-Id: <20210608135503.12135-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210608135503.12135-1-y.karadz@gmail.com>
References: <20210608135503.12135-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixes: 5c013e7 (libtracefs: New APIs for trace options)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h   | 2 +-
 src/tracefs-tools.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 08dda13..e29b550 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -159,7 +159,7 @@ bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs
 const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
 bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
-int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
+int tracefs_option_disable(struct tracefs_instance *instance, enum tracefs_option_id id);
 const char *tracefs_option_name(enum tracefs_option_id id);
 enum tracefs_option_id tracefs_option_id(const char *name);
 
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 993fb3c..ca40d4d 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -307,13 +307,13 @@ int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option
 }
 
 /**
- * tracefs_option_diasble - Disable trace option
+ * tracefs_option_disable - Disable trace option
  * @instance: ftrace instance, can be NULL for the top instance
  * @id: trace option id
  *
  * Returns -1 in case of an error or 0 otherwise
  */
-int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id)
+int tracefs_option_disable(struct tracefs_instance *instance, enum tracefs_option_id id)
 {
 	return trace_config_option(instance, id, false);
 }
-- 
2.27.0

