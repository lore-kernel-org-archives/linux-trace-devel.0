Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38455C2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbiAZJxw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJxw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:52 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF0DC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:51 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id k25so37488656ejp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LadM73lqTUtDTGSoV/g9MNtuOhmQmX5nNaG1Uv1+FA8=;
        b=hoIleTQRZJ96ZU3xKa0XFl+bx5LWM4XDc4bw9IY23a3Kb7Wq5GjCZseJSxkyEwJVjC
         GUhtC46TkM4YqmR11Ia5fHore/9JhR+8cVVZssJe7QzWE+vKCzuuod84FhUu6aQtXp8f
         bUlY1av4ICBlG6AWxCl/UOj8JBN+Z27R1JW/D2d/7+YLiX5ii+gZDPvhpBuQNcGLGNgs
         +kTjvHRfSBBid9zdcwDu8SUBlOJ0WZNsEZSncwKRBB8qN50INlYdxjraGyVfsPgqCzl0
         6DZxlWJqIuUYoidbK4km6OF3Oldx5tp7A2MWQwr5OfmYuxSGyn5YIZKAMmc0no6R/WtU
         dhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LadM73lqTUtDTGSoV/g9MNtuOhmQmX5nNaG1Uv1+FA8=;
        b=j6sw0JPjX8DC22YePNzBCIGooUA1uzhCsf3bW9vM4uREbHhfINcUlf1BcdHwyE+fh9
         UhsQdKCm9WLvRadq4hX3PZSCkW8VbeveDrEvH1GwzsqjaxToVcfEOAd+b7siisVfd86w
         LuwtJiw2XOVL3uhrODYgH+i1dTlCR4CEKSNI0grkpZ+6q7SXcPgNtgRiDMIq8OpJ6QMe
         5oHkfzI+T7ttiXucOSYnlngRGQ6MCiIx/B9lPMq2VR80iblEFYxNo3qlC/L4tEBHQsaC
         lXEE1oo8MSq2xc7UFNEURXkjn2tC+lxjy2oYtD/cOJM3gdZiaZVHXc5AMOKnIe0gOJLA
         pX4Q==
X-Gm-Message-State: AOAM530HHmWX7aqtIxiEOCFvtxu7SVZd4ntsE3aNNSC4kiVP9g+bIxpi
        ggzxxKuz1N2dYIjovvVgb1+3sahER3A=
X-Google-Smtp-Source: ABdhPJytbH1AAQaMcoV90klEmuCqkSKXjDKMBJ4a/JWlioJ4ANuKuW5C20AmkB+RndP4tKcqHgd5xg==
X-Received: by 2002:a17:906:f1d2:: with SMTP id gx18mr19559232ejb.674.1643190830477;
        Wed, 26 Jan 2022 01:53:50 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 07/11] trace-cmd dump: Dump trace file version 7
Date:   Wed, 26 Jan 2022 11:53:33 +0200
Message-Id: <20220126095337.570867-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has different structure than version 6. Separates
parsing both versions in different flows.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index bb168370..31878c3a 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -950,6 +950,32 @@ static void dump_therest(int fd)
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
+
+	dump_options(fd);
+}
+
 static void free_sections(void)
 {
 	struct file_section *del;
@@ -977,15 +1003,10 @@ static void dump_file(const char *file)
 
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

