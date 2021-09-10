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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673EBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DFDE611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhIJNt2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbhIJNt2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:28 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11143C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:17 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id q3so2591634edt.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DhQmJDJGkcQ7eXfaCIDlchysjzm62x+Y5uYIVAkMUV4=;
        b=OfmE81OOUuN7cOMXc/F0qzerkM0eVyo2diA3UvY7RtsIugHS/GzgyA4qLkQJ9Nw70D
         tVTXxB7k1lc0EGAnsT7KfKRwzeqb0ojJ6XtOvyc3ct+Ku+L3md5JJqbtqFO9hGwj1BEb
         iVNcffIs2YLmKTleI26e28vxNDjcp6AnIhrclUt+78WnLr2uCcBaxILLLvJekUS8gppz
         FVfFUjxjBd8NH7VptaEDN9YJ6N469F5H/OZ2PTvcWcjN8f9Uk1LwUFryTRR+Q6d/6dix
         ZY4yHp1sbbOCrbGlw/8PM10UvvYofckoSpkbIck7hvt3/f1ubVzRtAfdtT3Y4HqWY9dj
         FqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DhQmJDJGkcQ7eXfaCIDlchysjzm62x+Y5uYIVAkMUV4=;
        b=jxEx9tkmhRlRFo6PvYReFsU+oTgAFHjm3RhTsJuttEKc1whYFw4HtykTLDBEjc+LAy
         u8dGgsUqjhz2ZEVwO68YadQXMHfG0IxnwjKLJCJy7Akewj26Gm0z8rhpQJW9XGFLc4Mp
         /tsLTKfsL84jLwfe5VY5VjAAnyMvl+ASw6xWF2np99eaTG/v1rymD8OO0bXQMNEHPhty
         lBLHRM1qcFWznr47hDozm3704g43LYYfu8bgO9mCAxAhNBv4SWSGQsgxE0KdN159ijIG
         IKh7+Vf+pBysiauOA7mcOfGG/NLxQ563C/pZwoW+jYEKXqSw97v26TV5UfTpMtwV/2Yv
         2cCQ==
X-Gm-Message-State: AOAM5332dCa/ilbKcAnYMvtRpl/Dtli9qv15xcOYlhvy93ZdvdjfY2Wr
        6dzXSqb5tcgNJuq0dKDrxlmCmhX0Vek=
X-Google-Smtp-Source: ABdhPJz7K77h5eSDg9ASeyJqR3HeHnPHMrn7+OZnG/F5DCtsojokzxDk99zYhlrKfcfD37/jDwPaLw==
X-Received: by 2002:aa7:d710:: with SMTP id t16mr8941885edq.42.1631281695682;
        Fri, 10 Sep 2021 06:48:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 15/21] trace-cmd library: Track maximum CPUs count in input handler
Date:   Fri, 10 Sep 2021 16:47:51 +0300
Message-Id: <20210910134757.2863982-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next trace file version,
where only CPUs with trace data could be stored in the file. Each trace
instance may have its own CPU count, depending on collected traces.
As the main input handler is used by the top trace instance, the
CPU count there is for the top trace instance and may differ with cpu
counts of the other instances. Added a new "max_cpu" member of the input
handler, that tracks the maximum CPU count of all instances, recorded in
the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index fbfc0d1c..48f6bbd8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -125,6 +125,7 @@ struct tracecmd_input {
 	int			long_size;
 	int			page_size;
 	int			page_map_size;
+	int			max_cpu;
 	int			cpus;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
@@ -838,6 +839,7 @@ static int read_cpus(struct tracecmd_input *handle)
 		return -1;
 
 	handle->cpus = cpus;
+	handle->max_cpu = cpus;
 	tep_set_cpus(handle->pevent, handle->cpus);
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 
@@ -2794,6 +2796,8 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
+			handle->max_cpu = handle->cpus;
+			tep_set_cpus(handle->pevent, handle->cpus);
 			break;
 		case TRACECMD_OPTION_PROCMAPS:
 			if (buf[size-1] == '\0')
@@ -4076,7 +4080,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
  */
 int tracecmd_cpus(struct tracecmd_input *handle)
 {
-	return handle->cpus;
+	return handle->max_cpu;
 }
 
 /**
-- 
2.31.1

