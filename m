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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4DCC433E9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB5361A1B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhCXNFd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbhCXNEq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:46 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E919C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:46 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e18so24382347wrt.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nokKjdGn8oLDWt+O4i6e2PcrVh0FAmGZtYgsKS/GGHI=;
        b=hSRdNrPWWFI3PwXjXIcPGOqLvxSNmB2OVHnWUJQqxn59wTVJh7LUnJp7uns6vw9Kct
         0Kx14mRmNn9HT2ijSRYrW7dDoxL7X+ll8z0KdxOml08TTb8nsxaSMuwI2TPqpsbN0wZa
         joFGe8llY2KV3zWoHrcqosSVemPTsq2PuPbpuxnsoCw/AxHejGdmvskWSXmzooXRupC0
         1mjxDZfdf2nZjpa4tb7+oyLBugptWC45+Mi1LidRiLnfux5NzJeW6ohwCAwkHm+jgObD
         arDkVF7NMWfJa3qnC3OKTVBI/bhEjUZt6CfS6x5XOLXoCaetK1Wtp2vKZLbocIfTL+Sh
         +KgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nokKjdGn8oLDWt+O4i6e2PcrVh0FAmGZtYgsKS/GGHI=;
        b=Xalehk40RQeoYGrSLkVmY98+1n7JfiySVNlrPIRNgxOHQn2vU5bQ4D1ePE4POAbRkT
         D9tDATZTwfGplGW2QkbQBJxhqY6SPIB4GXklwXJLS5LqP47ewTTNi2V9q0BKq0feUR2X
         9v8wHkM4rq4ENNNqmmtFP2E29doA0c0NlMxKjuZIRg/Kx0YGlMF301Yh+WnmwckPgEZr
         hU8uKiUWRj6eLJU4deJsaCnaiLBKTcn9yfKd5mAw7293RKKTxDQVT5HkbZHou4WRmi0z
         WCkaJDwLL0MnxA3O+NYSCYL1BfCYnbybQD4RMjYqBZyenCLipA83fSpVQK7yvxB8xQiT
         3IOQ==
X-Gm-Message-State: AOAM531g0iokXtNAxoLpDwcH6jIhhu0Bit6A6AzkZHV+jBRLXtMTZZeJ
        GtUd5tbMcXtnxgKtDfnMRIM=
X-Google-Smtp-Source: ABdhPJwsYComIB4ehC531sHwOxYwErXuaiH8dQu+YNC6+KVISUg479kkDodVE6OGMR0X/fARwdmzIA==
X-Received: by 2002:adf:bc46:: with SMTP id a6mr3388836wrh.418.1616591084653;
        Wed, 24 Mar 2021 06:04:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 17/23] trace-cmd: Change "--nodate" option to affect "--date" option only
Date:   Wed, 24 Mar 2021 15:04:12 +0200
Message-Id: <20210324130418.436206-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When displaying a trace.dat file, the option "--nodate" disables all
corrections on the events timestamps. It was originally designed to
suppress the "timestamp to date" translation, triggered by the "--date"
record option. When more timestamp corrections have been implemented,
the same option "--nodate" was used for all of them.
Now there is a new flag RAW_TS and new option "--raw-ts", that is used
to show raw event timestamps, without any correction. The "--nodate" is
changed to suppress the "--date" option only, and the new "--raw-ts"
affects all timestamps corrections.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 27ddd8eb..9b4f8cca 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2618,7 +2618,7 @@ static int handle_options(struct tracecmd_input *handle)
 			 * Similar to date option, but just adds an
 			 * offset to the timestamp.
 			 */
-			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (handle->flags & TRACECMD_FL_RAW_TS)
 				break;
 			offset = strtoll(buf, NULL, 0);
 			handle->ts_offset += offset;
@@ -2633,7 +2633,7 @@ static int handle_options(struct tracecmd_input *handle)
 			 * long long array of size [count] of timestamp offsets.
 			 * long long array of size [count] of timestamp scaling ratios.*
 			 */
-			if (size < 16 || handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
 			handle->host.peer_trace_id = tep_read_number(handle->pevent,
 								     buf, 8);
-- 
2.30.2

