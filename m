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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A38EC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6217D610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhDBNUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 09:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhDBNUE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 09:20:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A652C061788
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Apr 2021 06:20:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u17so1136937ejk.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Apr 2021 06:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bx0IwbYTflDi7XjK37L93nsygl+2jWgYd7hRljVpQOk=;
        b=p+FpM/MFgn99kgNxIGkFbTfkXkxbx5wcycx9o6fNmlOfA/dUc2aMFXCwXUQttmOmYH
         uawVNnKQmqV7H/gM3vWKpf8VqnuDLB83UJxd+TTilqKxcxEjcmy97+uv6S366bYHQIli
         1AMbUGGxOR9Dludi2mwS7DyyPP/9Yg9aa/JTFYtqQPUqQXu0K08HpWOdwcn7cO6MhMV8
         xoEhjnh4vz8/pVmAGYypb4tqTDIUPvyX9OypQZrpTI25YihFsn7HPXGZfluFyIHRmkk9
         puM20wbWggA5yR1B/SpKWZE+DQphESN8SnrAfEpkSLrixSOE03SmWQvl+KMvwRZucngG
         mH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bx0IwbYTflDi7XjK37L93nsygl+2jWgYd7hRljVpQOk=;
        b=T4GiDqafC+ndRo/NL8KAO1BdSR+nzxAwVs91LDTXfkCtL3G2aWwn/eQS41Nae6EHPo
         NfbIj/HVG6T3z1y/7foHcVLvmL+3CABBXhWIUSS3tjXaH9Yr7soNCrpc7FRdSvjTrlCs
         RvNUl1pUFDq6YJEQ319IfTVzneNZkY8tiKLUv8RKYBweufhQmIb/YACY4FOxt3RtwC1f
         xb6tHg/TpvviRqIMuAwnyPBnvjX1+eTA9eqSwrUmvMm8FUS3ML/gXsapm/CoxtCdaDEO
         bzypYu5XwL8aRUSjYVwUhFwpGO7HK4PAwQ8h3Ezv/KY642SmsHFGvvO6+fiL3hGReSh0
         IxaA==
X-Gm-Message-State: AOAM5337/LlaUsnxj8ojfIdRpOjRdSoAHh5W4fePr9ZttrdIvDtEae3O
        gXlm+T+cuWWXzdPTyeqtpD4=
X-Google-Smtp-Source: ABdhPJyvJuxH4d4OJqkeFJ0OmQcXrr8jzHrNv3q/bbgwDhimGwTwSFlmEEl/IBvBwJYZlRTrmItT1A==
X-Received: by 2002:a17:906:7d48:: with SMTP id l8mr13850788ejp.108.1617369602028;
        Fri, 02 Apr 2021 06:20:02 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id n3sm4120476ejj.113.2021.04.02.06.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 06:20:01 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/6] libtracefs: Fix issues with tracefs_option_id()
Date:   Fri,  2 Apr 2021 16:19:42 +0300
Message-Id: <20210402131947.346235-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402131947.346235-1-y.karadz@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
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
index 05bd0ef..fbd7db5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -145,5 +145,6 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
 const char *tracefs_option_name(enum tracefs_option_id id);
+enum tracefs_option_id tracefs_option_id(const char *name);
 
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index e2dfc7b..51a7971 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -181,7 +181,7 @@ const char *tracefs_option_name(enum tracefs_option_id id)
  * Returns trace option ID or TRACEFS_OPTION_INVALID in case of an error or
  * unknown option name.
  */
-enum tracefs_option_id tracefs_option_id(char *name)
+enum tracefs_option_id tracefs_option_id(const char *name)
 {
 	int i;
 
-- 
2.27.0

