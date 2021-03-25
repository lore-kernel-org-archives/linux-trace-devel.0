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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141EFC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00E5461A10
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhCYGlj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhCYGlP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:15 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2109DC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:15 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so3768282wma.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hI0EV2GPDxR7VVKXt4QZMSRqrlxjlh1hduRz4xlbz8g=;
        b=cWmIBqtUD6np9ONFF2hgQEp8fYZQh7G1LM2jortfBmTn0ccWJveNyAi7I6bty7Gg0T
         OPfwKxmk4bh4NgXJDJqaM6RAqcA9B4/uK+qdCqkZ+XWSakHrl9geKhmCiyN1qE1bQmrn
         amVlrvKnEneRHrSDiBup5L3w+e2c2DY0bPujR8BPg2LsdUiubEOy/VvXC1hBLBI8pjGX
         8TrMgB3WZGHls2+8wSpDHRcNaVkiGeYpZniJWl5PeElhb9qACFYgiJZhmaY7lK9dAW3B
         c/w8K1a7+YuCd7bW0vv5wFL336Uj+esZ5LI/0dtsercyqcIcV8Nfk8Dmvkpp0k+hvtJ9
         eeAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hI0EV2GPDxR7VVKXt4QZMSRqrlxjlh1hduRz4xlbz8g=;
        b=D+Xor0qENslMtVR0P5TU4/vi8ZF7HRLwnwECEOFHtCpsRwyFEZxfoF/cC03AkQsWsK
         7W8bWlQECqUsEN+NXIaxwS6RzQq08MRLNk8XQQFwRoxVAR6hYRnHQnz9Rx/9XQ5UgIYl
         /MXy6KYa7bZylcw1WNhCyowGGk0T3sHhnlMuoA0ZUQ8zQCrPMK4WYcZNba0iYmpzjUU9
         QqLBSAxlFUcrwfwAR4DJbQMBHnxfaBwSTyCsNRKgNEBDjYClXOiEpK/+Xo9Bu5PZCvIz
         TWFU2sJtjl1rl9oQArZQP1dXlilJmo4Rs+0voXFgX5Z4ppyak2nz9Hx+LNZe/D/Zi+bZ
         S60w==
X-Gm-Message-State: AOAM533Zyt1vYkqKLizSO1rIONZB+Jyb3r3AC5LQHYIIXsWzlrIABep2
        TtiNJ7xrzgkxiv04WPtscJ8=
X-Google-Smtp-Source: ABdhPJzYF9lpHdAduyhsaQVwaFV4P7BwvikSETi7nQo2lnln1LRV7z6UA6TIxzMfC+POYh52jFnUkQ==
X-Received: by 2002:a1c:4b11:: with SMTP id y17mr6040333wma.171.1616654473890;
        Wed, 24 Mar 2021 23:41:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 17/23] trace-cmd: Change "--nodate" option to affect "--date" option only
Date:   Thu, 25 Mar 2021 08:40:49 +0200
Message-Id: <20210325064055.539554-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
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
index ef2f9678..d9a2b6df 100644
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

