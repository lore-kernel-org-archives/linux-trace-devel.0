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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B970C43216
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0820360EB2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhG2FLE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbhG2FLD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:03 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24BEC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:00 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u12so6435885eds.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xYZjx89pr2ljRxRd4T7dvQBQNHexYzaKEzijEQWYQHA=;
        b=MYkXsK7d8jvt6RZijHoc98nNV65k/iUCuaWktl4Lx8T4lk4lIDo8NIMR/G32XZfiWF
         4wFkN4o+TZzK4up0CsBHiZfX60bN+xm3aP0vKroGyMmO2WJdn4e7dYczJP9Bbi8Va/EA
         AXb4zoLM3SvmnBdy1bp/N1F632R4e6/7b3ZvmWbKQJOKqcrDr75LqhJo6it3pc+S119E
         rdwQp0EZ4FkT1RPyS1XINciREgUNxmlAhpJYUHypSvp5K0PUNlV0zybm8GD577G9vXey
         VKSHShBNzF4Z9E2hliFtaPp19hk8Xbrg9/UVe7hIWWsPKjSzPBJFeE5FGcJd79tpzINz
         f41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xYZjx89pr2ljRxRd4T7dvQBQNHexYzaKEzijEQWYQHA=;
        b=owsBO5EiEYAhNOrCq8ar7s55E+WYvdo2PRnqe0WcuFAGcDtnZt4GxSG9G/rTo8Ak9W
         /xhHvYKK4zHTuAsoEoyjldsmVBBxvzQ8LdySxwJDRkz95uuRs1svSM3KSUvE5A1DsbQU
         6C91vF47YB0i7H1f5G8Rm0EXwlnhKFtBXsGQ751Gz5/Ukjp4NXapSQqPWYiA0SB+xyF1
         feFrQA/41WxiFcW7Cc7KbZJ7qfxIwxsGT44Z6M5If904XvGrflFufF3fBHoiTyvBL47f
         g22gfpib995uZYXPqtGniCBKgXMrqXi8jUpOhkpPbGvCIOwtxKBf6UtNj+u9vEgVBuoY
         92eQ==
X-Gm-Message-State: AOAM531AI2KomWnP1wwJUYknZcxr+aLM/q9Z2WTScTnbgPN6JjOePLV2
        Tp87zKbLOuFdXSQuaWzv3q0K5zF+CVcADA==
X-Google-Smtp-Source: ABdhPJyrtfTrutnqZcwJl+YyMQRkMxQUsQ/Btxam7XUJzYpu0f9DagUukI2hf/WpnKEgo8zhcE3LWQ==
X-Received: by 2002:aa7:c6d2:: with SMTP id b18mr3895368eds.266.1627535459423;
        Wed, 28 Jul 2021 22:10:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 60/87] trace-cmd report: Init the top trace instance earlier
Date:   Thu, 29 Jul 2021 08:09:32 +0300
Message-Id: <20210729050959.12263-61-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The instance must be initialized before calling the tracecmd_cpus() API,
as in trace files version 7, CPU count is set when the trace data are
initialized.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 1868a830..cafceffe 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1217,6 +1217,11 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	list_for_each_entry(handles, handle_list, list) {
 		int cpus;
 
+		if (!tracecmd_is_buffer_instance(handles->handle)) {
+			ret = tracecmd_init_data(handles->handle);
+			if (ret < 0)
+				die("failed to init data");
+		}
 		cpus = tracecmd_cpus(handles->handle);
 		handles->cpus = cpus;
 		handles->last_timestamp = calloc(cpus, sizeof(*handles->last_timestamp));
@@ -1227,9 +1232,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (tracecmd_is_buffer_instance(handles->handle))
 			continue;
 
-		ret = tracecmd_init_data(handles->handle);
-		if (ret < 0)
-			die("failed to init data");
 		if (align_ts) {
 			ts = tracecmd_get_first_ts(handles->handle);
 			if (first || first_ts > ts)
-- 
2.31.1

