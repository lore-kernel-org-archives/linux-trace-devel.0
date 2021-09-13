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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E28C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0932760FBF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhIMMwF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbhIMMwF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:52:05 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333ADC061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:49 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n7-20020a05600c3b8700b002f8ca941d89so6525607wms.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBqB9KoV1o24qWOyKjje4CKxWGz3YUwcOPKCLKEWJ0Y=;
        b=YASa7JpeEqHPKUOc5kUiX5zexD17YdfkCMUA+1JW2KvHnzmGX5w3MbIRbZRuk4STFp
         iGKLRq0267FdAXgBY/K8skWMB03EtATjmqEoi//LfMBdSNgif1wyA8jfB9otFQT1T1Ed
         qhgT7CUxMAdHtZ4jVez3hUi0kAYGJTGGVLlBQLJMKZslPJBxX/kvCLuX3p7gTccnVjOa
         kUB0lgXp3yLUngcAgBIajf5ZueNjfKVwwP5EdJxMLqFvw4V8phOIgtD7Qmy20Pcw3QsA
         Taxaz849lXMscq8FlbSarYp6k04U/nFMhWlyVHshcIyvLyTJ1/EUqrKbwSvshcd5WCCo
         35NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBqB9KoV1o24qWOyKjje4CKxWGz3YUwcOPKCLKEWJ0Y=;
        b=rf0I+Q7mBkvXDjEWZxhJ0rsEPK+ioEg8JOTJ0VKI4In2gSh80/ShpJpNOHNeerAsRk
         2NSW2GscwMh/pCx5wTRSlBz/qH/jWGsFPU03YNwECJfQf2fvByc/2Esj3rnYkrs743Xc
         h5xzEIzlDAE0xtlYQbhdm+JQLvDSXslFliMnCv0xvYFtbHYDp2CS9duRjMx5IP4cC8wz
         kMX9LUaU4FVMnxDgLCJeo+NGv9XK3s3eujFfCa+vnPcpxYCliRgSGAbYg4fKgqKv7TLi
         Q63HgImbGikfoa8ZQoSAhcp7TOcmLWgNNF7Nctq5YAHKxlnp3/ZxXLw2zfs3+mu2KMHe
         0cRg==
X-Gm-Message-State: AOAM533itD3ONLx0q+A2mZgXtQDSnD6vx1lR13MTlUACuAZ/e/uZzQRr
        wOvoYRbRhjA1p4OTyQmTDLYwAm1KpZo=
X-Google-Smtp-Source: ABdhPJyj7OZxw4G+Z/fgjVmH6nVcd7MeemDCK6Y1k6sDELkACdcczPlbdNfiC+i7wRngn1lcSQAmEQ==
X-Received: by 2002:a1c:7f84:: with SMTP id a126mr10863161wmd.33.1631537447799;
        Mon, 13 Sep 2021 05:50:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u27sm7756448wru.2.2021.09.13.05.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:50:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/10] trace-cmd dump: Dump trace file version 7
Date:   Mon, 13 Sep 2021 15:50:36 +0300
Message-Id: <20210913125039.3680986-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
References: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
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
index 3394847c..44f103d8 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -884,6 +884,31 @@ static void dump_therest(int fd)
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
@@ -911,15 +936,10 @@ static void dump_file(const char *file)
 
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
2.31.1

