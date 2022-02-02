Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE18C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Feb 2022 21:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiBBVqx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Feb 2022 16:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBBVqx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Feb 2022 16:46:53 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7FFC061714
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Feb 2022 13:46:53 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b2-20020a252e42000000b00619593ff8ddso1926841ybn.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Feb 2022 13:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3c+fa41f1QjWO1FIuf+NG7yCP51GprvCfPxv3HBHEqQ=;
        b=BZu1RYV/leLrfdlwg/kCsNJKgx+2yatd0J9R+aApI48cAldPYjUn/7jQVUVuq5x6yf
         Fh94k5xHU1s7oIsH+WJDBQyNopGZxnmkQ3T4SJHpBXROl6lj5hrvS5ZLWHze/xnwSTeD
         vXljYtZDhQlDLm+paj9bX9zwscvH7p4uDvY/j5ECG9yQb3RCpDFcIzDhtWFoXPtyiACR
         OuWhvxpIWeI+FwZACjMz+HR6tgJ8hgy0rd75POFCUfS16CX4k4ZgcMPGuGGijSLzYjqp
         6IVzB+XNhzQA74GQPIZNd/E3PLW5jp5wKAT2r7owVcnIQBG8AORE1NIUNvX5Xy4Lr2rq
         AZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3c+fa41f1QjWO1FIuf+NG7yCP51GprvCfPxv3HBHEqQ=;
        b=gCl/0piGugUjNWyeaILcJyzDnak6L6chrb8JVtga3ew4A6hWLyGryNCvcHLMG1kdKI
         X/LJoVuk8ffiVMk3dwxsI3pCswM/AZd6tkWZnDhXlqqKhWb3cgO51dJVZf2YHY4rV6uL
         In8Zi98R11uWETKDS15dzBeghYJUCyB+2HZjdojD5LB7JA+cIy0bIyH5Mhleg/di/bBh
         cCb8IpQA2vpbOEwHQHdb8fkpDW/VPfdBgS5Iq0Ouinsudyyfb8a2xK4iIvv/z4q+puWT
         IGzySi0Gmc/UsjEqdlno8mU3Jv60tbPlks3nk4Ur4wFQepg73T4eKE1eJYR8Nwgflru3
         xBoA==
X-Gm-Message-State: AOAM531Gp02TWf117qzYdapz0RBrOK9Tjkq27iDNxZeuCvIpGVOZOioX
        SMtXUPoZWHNjTnsJuPJZ10RgJ6icVjnCp4BoNdCXHPXAwsF/hv+cMhqXYqjvKQmO+k/TkDgsuyK
        S3//JR1jTL9kJi8tu4yInRsZYsJSf4UflrE/U1DjLWD/gqlvrpGHS1rBcLWEbi3bnVxbNEzYCO7
        JjVks=
X-Google-Smtp-Source: ABdhPJwioQSiSizjUsj3IxZnIGbC8eSH+g1UvEBzBs4BAkVqeTevRsB9h3b2ajkHI7lPI0owbGFwqrejcf6F
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:adf2:a985:b1bf:dcb8])
 (user=irogers job=sendgmr) by 2002:a81:48c1:: with SMTP id
 v184mr2358877ywa.340.1643838412266; Wed, 02 Feb 2022 13:46:52 -0800 (PST)
Date:   Wed,  2 Feb 2022 13:46:46 -0800
Message-Id: <20220202214646.553872-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH] trace-cmd: Fix use of uninitialized variable
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Caught by clang's -Wsometimes-uninitialized and accepting the suggested
fix:

lib/trace-cmd/trace-input.c:4325:6: error: variable 'sec' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (handle->file_state >= start_state) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/trace-cmd/trace-input.c:4336:6: note: uninitialized use occurs here
        if (sec)
            ^~~
lib/trace-cmd/trace-input.c:4325:2: note: remove the 'if' if its condition is always true
        if (handle->file_state >= start_state) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/trace-cmd/trace-input.c:4311:26: note: initialize the variable 'sec' to silence this warning
        struct file_section *sec;
                                ^
                                 = NULL
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ecb5682..57bd4ee 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4308,7 +4308,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
-	struct file_section *sec;
+	struct file_section *sec = NULL;
 	int ret;
 
 	if (!start_state)
-- 
2.35.0.rc2.247.g8bbb082509-goog

