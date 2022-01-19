Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AF3C43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352485AbiASIad (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352487AbiASIaa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:30 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FEEC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:29 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c24so5231344edy.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mNMmF/NVraF92oJMtfPPWEpO5yqxIVJPYTVqlEtYYqg=;
        b=E6dvAiyZNXCgG1kbYav1X2HrWbCP6fLW9YTTrj1vVdYcTn3zdLul+TrQn1z1Agq64J
         o215sNYM/PQmNTt733pS4+cMim6lyyL8g9JvNechwakCYNtEuZO61J8ap7xSGLcUJMn8
         y1SdqACn4GzmmMvKl8oFWXL41WA/YUsPKGc1QT+7Q8N7F1cj6OqjvTyacYGxR6sPkLX7
         WeDCbkj+VSqabJkIHaIRDW2OykPKzjQn8rTK3/krfhM1qOsTgZUaPKouuQOvvnWszTvC
         rmEQ4hXpDdCtf05T/b04qo+Bn/sH8cZcxK5dvB88nyNQpphN/E0td4KPFK42Wzwjzft+
         k/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mNMmF/NVraF92oJMtfPPWEpO5yqxIVJPYTVqlEtYYqg=;
        b=TZ9Ux89CZVtMQbfIhOMsK1pjWqlfjEldusG1nzVfqw+w/n+ivS5L98Ag7TiGlRr++X
         Hd35UUzT7MRTyssLSNehAlJCWTin3bpjp9MtDg75kiEXOy0X/WvwSstWyei4KcZu0il+
         0pGW5PNPjVhoYg6X5tvjnUFhss5dFcmeqcLbOBYzq47ZWKvSpV0EqRUsdgiPUMJ2DIR2
         5ZrHAtsBgaa+axQaGUAW2tiz4FcIzaPhBUwpqfSg3MbulzbhRiTfU89dHt4AEISXHAEQ
         EqocKyxaDM9u2AFeES/jXigTUPqX8lxt8UuBk5UQqWSjhliHQXKy1+rR9gJaWqF0Tu+q
         l1ww==
X-Gm-Message-State: AOAM530ZJFdiJCTGq/1QHDsYWUS8S4fKW/rqSJi/8cPj8S6w2LoMXC0k
        +MESSzk+Vz3M6nVuYWsIa89NQs/q3F8=
X-Google-Smtp-Source: ABdhPJxMY6zCKTXvzwFnxWuPzXqJUFq88e7b5Ro0xhtdM91QbattVgePUo2iedkDKcDmK7/pBNk6TA==
X-Received: by 2002:a05:6402:4486:: with SMTP id er6mr17109549edb.185.1642581028245;
        Wed, 19 Jan 2022 00:30:28 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 07/11] trace-cmd dump: Dump trace file version 7
Date:   Wed, 19 Jan 2022 10:30:15 +0200
Message-Id: <20220119083019.246153-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has different structure than version 6. Separates
parsing both versions in different flows.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 2ae53885..cbf94206 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -930,6 +930,31 @@ static void dump_therest(int fd)
 	}
 }
 
+static void dump_v6_file(int fd)
+{
+	dump_header_page(fd);
+	dump_header_event(fd);
+	dump_ftrace_events_format(fd);
+	dump_events_format(fd);
+	dump_kallsyms(fd);
+	dump_printk(fd);
+	dump_cmdlines(fd);
+	dump_cpus_count(fd);
+	dump_therest(fd);
+}
+
+static void dump_v7_file(int fd)
+{
+	long long offset;
+
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read offset of the first option section");
+
+	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
+		die("cannot goto options offset %lld", offset);
+	dump_options(fd);
+}
+
 static void free_sections(void)
 {
 	struct file_section *del;
@@ -957,15 +982,10 @@ static void dump_file(const char *file)
 
 	dump_initial_format(fd);
 	dump_compress(fd);
-	dump_header_page(fd);
-	dump_header_event(fd);
-	dump_ftrace_events_format(fd);
-	dump_events_format(fd);
-	dump_kallsyms(fd);
-	dump_printk(fd);
-	dump_cmdlines(fd);
-	dump_cpus_count(fd);
-	dump_therest(fd);
+	if (file_version < FILE_VERSION_SECTIONS)
+		dump_v6_file(fd);
+	else
+		dump_v7_file(fd);
 	free_sections();
 	tep_free(tep);
 	tep = NULL;
-- 
2.34.1

