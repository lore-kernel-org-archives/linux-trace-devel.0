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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308F6C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AC5B60FED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhG2FLK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhG2FLJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:09 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDB1C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:06 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id j2so6364030edp.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D2407/DndqS7KvrDlWm40krvCPS/afqFfjBRnfcuyBw=;
        b=rs0QNMjxdEAmjLiQtVTSAxJzh71XwZpw0+g4rtmvIQpojX6M2T57CGWqxzGnAb+zCD
         PYbzTdREquMe/iUJ8htCjwIOni9BcCJUsLMaY2oJ7hkAfdCEb2AJESAG3Xh0D5CfYguQ
         0Xq4o5BT//DxY17EwGkP0xHu21M+RzBBkaGrsADDp4BkscVhgae60gqbQmAplJBmzQyX
         fecF6aLYvTygUn4WqvkX99qhtZiAOEgF9u4BkdOOqfjAgBznpP9YideA9UnzAtEmS+TP
         L8Wwd5nC92KYy+2dUjuFq6qPO9lrp28Fkx8rZRCmsZTYduY0lHvEJDrr/cjyLKE6K36c
         0x1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D2407/DndqS7KvrDlWm40krvCPS/afqFfjBRnfcuyBw=;
        b=o8hAtVmXjagdDkLGVfUDf3Dai9BfOrOHo0tw1YEewTfTxvBlWhZ8lXcchTX/CUALW0
         Od8CNyu4zFDKvfBklQhyilXaaf/9aB0wjM9MDL9BZ9zOb0u0MJi8LCwjBFYbwDk3tK5j
         PrQLhKz40x6f3ydbq0gLqUzXwOtSwT3XOu0aPcMboeUU9QpxI6VVJhlpxd/BrWwsPBi9
         kAXhcaQ8K/5JXeZcx/LHARxWHMR3X8aWa47TYM1dK2Yc/tRpbiSnGbrlgVA651zjdLti
         Dfq+bAnjI3KOqImb94Rk2TMAApmnT5xKdNDvnjwd54ZIKxZlHaJcsel+anIg2AG1Zxiu
         F+8A==
X-Gm-Message-State: AOAM530R9X0KA63ppBto7FBe+zFbOwFavviu2bJpEfQpuc9t1y5R/152
        gaedFgIGc70QHnTJBLpBqq3Nd6meN8mCsg==
X-Google-Smtp-Source: ABdhPJwrDXkBiV9pukkM0dH5rNpqOAQXdD++PJxb+56W6b/9KVA++7bamkLVCL4thxbskXNyzwiIeA==
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr3904150edx.149.1627535465158;
        Wed, 28 Jul 2021 22:11:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 66/87] trace-cmd dump: Read extended BUFFER option
Date:   Thu, 29 Jul 2021 08:09:38 +0300
Message-Id: <20210729050959.12263-67-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7 the BUFFER option is extended to hold a trace
metadata, related to the recorded instance. Also, a new BUFFER_LAT
option is added for latency trace data. Implemended logic for reading
and printing these extended options.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 64 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index f801e0b6..63d8bb81 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -446,19 +446,72 @@ static void dump_section_header(int fd, enum dump_items v, unsigned short *flags
 		*flags = fl;
 }
 
-static void dump_option_buffer(int fd, int size)
+static void dump_option_buffer(int fd, unsigned short option, int size)
 {
+	unsigned long long total_size = 0;
+	unsigned long long data_size;
+	unsigned long long current;
 	unsigned long long offset;
+	unsigned short flags;
+	char clock[DUMP_SIZE];
+	char name[DUMP_SIZE];
+	int cpus = 0;
+	int id;
+	int i;
 
 	if (size < 8)
 		die("broken buffer option with size %d", size);
 
 	if (read_file_number(fd, &offset, 8))
 		die("cannot read the offset of the buffer option");
+	if (read_file_string(fd, name, DUMP_SIZE))
+		die("cannot read the name of the buffer option");
+	if (file_version < 7) {
+		do_print(OPTIONS|FLYRECORD, "\t\t[Option BUFFER, %d bytes]\n", size);
+		do_print(OPTIONS|FLYRECORD, "%lld [offset]\n", offset);
+		do_print(OPTIONS|FLYRECORD, "\"%s\" [name]\n", name);
+		return;
+	}
+
+	current = lseek64(fd, 0, SEEK_CUR);
+	if (lseek64(fd, offset, SEEK_SET) == (off_t)-1)
+		die("cannot goto buffer offset %lld", offset);
+
+	dump_section_header(fd, FLYRECORD, &flags);
+
+	if (lseek64(fd, current, SEEK_SET) == (off_t)-1)
+		die("cannot go back to buffer option");
+
+	do_print(OPTIONS|FLYRECORD, "\t\t[Option BUFFER, %d bytes]\n", size);
+	do_print(OPTIONS|FLYRECORD, "%lld [offset]\n", offset);
+	do_print(OPTIONS|FLYRECORD, "\"%s\" [name]\n", name);
+
+	if (read_file_string(fd, clock, DUMP_SIZE))
+		die("cannot read clock of the buffer option");
+	do_print(OPTIONS|FLYRECORD, "\"%s\" [clock]\n", clock);
+	if (option == TRACECMD_OPTION_BUFFER) {
+		if (read_file_number(fd, &cpus, 4))
+			die("cannot read the cpu count of the buffer option");
+
+		do_print(OPTIONS|FLYRECORD, "%d [CPUs]:\n", cpus);
+		for (i = 0; i < cpus; i++) {
+			if (read_file_number(fd, &id, 4))
+				die("cannot read the id of cpu %d from the buffer option", i);
+			if (read_file_number(fd, &offset, 8))
+				die("cannot read the offset of cpu %d from the buffer option", i);
+			if (read_file_number(fd, &data_size, 8))
+				die("cannot read the data size of cpu %d from the buffer option", i);
+			total_size += data_size;
+			do_print(OPTIONS|FLYRECORD, "   %d %lld\t%lld\t[id, data offset and size]\n",
+				 id, offset, data_size);
+		}
+		do_print(SUMMARY, "\t\[buffer \"%s\", \"%s\" clock, "
+			 "%d cpus, %lld bytes flyrecord data]\n",
+			 name, clock, cpus, total_size);
+	} else {
+		do_print(SUMMARY, "\t\[buffer \"%s\", \"%s\" clock, latency data]\n", name, clock);
+	}
 
-	do_print(OPTIONS, "\t\t[Option BUFFER, %d bytes]\n", size);
-	do_print(OPTIONS, "%lld [offset]\n", offset);
-	read_dump_string(fd, size - 8, OPTIONS);
 }
 
 static void dump_option_int(int fd, int size, char *desc)
@@ -665,7 +718,8 @@ static int dump_options_read(int fd)
 			dump_option_string(fd, size, "CPUSTAT");
 			break;
 		case TRACECMD_OPTION_BUFFER:
-			dump_option_buffer(fd, size);
+		case TRACECMD_OPTION_BUFFER_LAT:
+			dump_option_buffer(fd, option, size);
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			do_print(OPTIONS, "\t\t[Option TRACECLOCK, %d bytes]\n", size);
-- 
2.31.1

