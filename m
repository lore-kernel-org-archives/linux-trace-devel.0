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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1C3C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A33D61130
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 14:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhDHOAs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhDHOAs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 10:00:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351AAC061761
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 07:00:37 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s15so2566583edd.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 07:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uFCmyoZmsYF6TR1HKFUQCv6oPEMxr+ouFLjkaPL86hk=;
        b=Rf1Me6UIQkziM5QMiM+r96A4y90P22S2MsnOi/Uv+o1cyMGS0rvJxK2xdy3mt64E4s
         3fENdp+3Ov3NGekbv1CIvKQRLthJiQXNzGxj3IRKitnP/+ubl6Oh+eRjEjI3o4bfDzwW
         OjqpDlgQaMpon/JOb/e+mf9vOI14mTkHFSkXOtBs/Pwjl3BZlxbErpBFVsANBoxR5AGa
         tX6oVi7bhzw2NzJVDOtlYIU7gJx9EZsVDYB4V/a1mdAcOzMqE/wLgIHHjq/yey9y57qQ
         NImXpMPPYkwpWk7smhl9qESGXSoaxZP0X91Aja5EHyHNu03beJCD7LGALSqQBHbWkKS9
         Af+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uFCmyoZmsYF6TR1HKFUQCv6oPEMxr+ouFLjkaPL86hk=;
        b=P7T+LEo+gW/Q1SGn5jCvrPtZd7SxaNUBM27EUEoulnkDpRzKEhzC9YSuagaoIL7MUd
         7sOUO4rtLWZiOKy1EIcs7gIESLsg5mKEo52VDgwJFw0atSuOYCu6/4flJl79/FLY/viM
         N/uBlJsyotTDZ2vQn71MJhEtGjnn10HdOAYnoeLNrkA9uxeUR97CWfvqFruxkdDnlE+R
         LOySj3SzkYRa/1eo9Thuj/vcB5bMS2FlLiooCmm82nm9wR1y4lIq0zHZ5IM4saCiew/5
         HDqF87SmG4gWKEgAj8FTakGP0R7aTdbAXvV1jiKY0C7GwaLgVkyQ4S+GZas+kJuC0T8E
         kdrg==
X-Gm-Message-State: AOAM531IAEH+8AVt0DqnRzweXlBBgooHRrrbzdEz5lNrG2lFQlzc7nSW
        CacnXwmfhPIbVrNGXSBZipo=
X-Google-Smtp-Source: ABdhPJzulMcrt1Wke23DklPP/BJGglYby7wXS8fZ4+wRgwDJyTdxm2/c0pB9EUjUSCeOpvdeOfjSUQ==
X-Received: by 2002:a05:6402:42d1:: with SMTP id i17mr11237567edc.131.1617890436006;
        Thu, 08 Apr 2021 07:00:36 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id jt18sm8212150ejc.96.2021.04.08.07.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 07:00:35 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 1/5] libtracefs: Fix issues with tracefs_option_id()
Date:   Thu,  8 Apr 2021 17:00:20 +0300
Message-Id: <20210408140024.13093-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210408140024.13093-1-y.karadz@gmail.com>
References: <20210408140024.13093-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Few mistakes have been made when introducing this API function.
First of all, its declaration is missing from the header file.
In addition to this the argument type is missing "const".

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h   | 1 +
 src/tracefs-tools.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 70b7ebe..d3db8b5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -145,6 +145,7 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
 const char *tracefs_option_name(enum tracefs_option_id id);
+enum tracefs_option_id tracefs_option_id(const char *name);
 
 /*
  * RESET	- Reset on opening filter file (O_TRUNC)
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index d48062c..f409def 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -192,7 +192,7 @@ const char *tracefs_option_name(enum tracefs_option_id id)
  * Returns trace option ID or TRACEFS_OPTION_INVALID in case of an error or
  * unknown option name.
  */
-enum tracefs_option_id tracefs_option_id(char *name)
+enum tracefs_option_id tracefs_option_id(const char *name)
 {
 	int i;
 
-- 
2.27.0

