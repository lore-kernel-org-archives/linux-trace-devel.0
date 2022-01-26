Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600D7C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiAZJxu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJxt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:49 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF16C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:49 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j23so63034976edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MXh/PXlQ/XSIgp9uo48l7Um3pQCiqoeuuS1vtlevE8A=;
        b=T7FyBh6lh6cVhXOhqq0XeelFjTzsQvT14nNHOjt1exjMBztPhud015c9IbVWljuQ1E
         U6IyTXDLc1xasr3UkYQsmmhnbmfY3I3f+oV6KXiT2Hb09Z39ctec3FBUE5RS8engn+NU
         94GWMbbVSvYQ5CL+iy9QU53LIWf3vPdskuyi9Nomgsu5dKADhbTauLYBjs3JjecBF5K0
         k8KHlY8THz3bRP13OXepdJ1lyymaVp8unI4AVzj0saxMlAfl0/eME0F4MqQaU68R75yN
         toEJq+EXVEi9Q6VGU1XJOTfLHBM1JkN6P3onboNsNhAoEIvAFzKXlOSF9Q+LKEP8J59p
         kDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MXh/PXlQ/XSIgp9uo48l7Um3pQCiqoeuuS1vtlevE8A=;
        b=rTyQy8n+h+szDla38Y1Q36oHZl29ELcWmQj4NldjqD5Pz+8vIGH8HIHwUH9yFQI5Jw
         c2p32VXz1GFPS3dg0ph9+HVWInObA1ZWmlsNmcMpvx4Y8X6dWCG+k9t09OSxI+GKOFGZ
         8RY647NNLwhQUZEVNJqsYeP5/Be0zLNaEul5m/OEpZ3upMlTr1Wc1N1RkDBDwLe1PMPx
         50Hmvghrt7CiCvDdj0X5kNjk21HJCejH2afqZDoNXPXyo4n3KL520lcQgBbD0sGJNm62
         wwxJnRqJtiu2sy+Uf3Q3XRVWL+GprU6hwjfD4vWutppQq1NoBQi+X4HYNhQSOuD5q8Wb
         PQcg==
X-Gm-Message-State: AOAM530Ebv3T6wffXczKKKLpul5KXiiu2y0GOuVz/wrv/1s3xAgp6i3O
        wwtieQgQeR1sO4+fjspRN8y33lrIhPg=
X-Google-Smtp-Source: ABdhPJzrKs4hfPZtxFy+1pIW10bGx6/b+WMLzcytilFlnOyr6Q/hjKTGdI7V2jLFBB5YsFSmXq3R2Q==
X-Received: by 2002:a05:6402:190a:: with SMTP id e10mr24134463edz.135.1643190827910;
        Wed, 26 Jan 2022 01:53:47 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:47 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 05/11] trace-cmd dump: Read extended BUFFER option
Date:   Wed, 26 Jan 2022 11:53:31 +0200
Message-Id: <20220126095337.570867-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7 the BUFFER option is extended to hold a trace
metadata, related to the recorded instance. Also, a new BUFFER_TEXT
option is added for latency trace data. Implemented logic for reading
and printing these extended options.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 70 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index e04e275a..e88fe033 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -454,9 +454,18 @@ static void dump_section_header(int fd, enum dump_items v, unsigned short *flags
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
@@ -464,9 +473,59 @@ static void dump_option_buffer(int fd, int size)
 	if (read_file_number(fd, &offset, 8))
 		die("cannot read the offset of the buffer option");
 
-	do_print(OPTIONS, "\t\t[Option BUFFER, %d bytes]\n", size);
-	do_print(OPTIONS, "%lld [offset]\n", offset);
-	read_dump_string(fd, size - 8, OPTIONS);
+	if (read_file_string(fd, name, DUMP_SIZE))
+		die("cannot read the name of the buffer option");
+
+	if (file_version < FILE_VERSION_SECTIONS) {
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
+
+	do_print(OPTIONS|FLYRECORD, "\"%s\" [clock]\n", clock);
+	if (option == TRACECMD_OPTION_BUFFER) {
+		if (read_file_number(fd, &cpus, 4))
+			die("cannot read the cpu count of the buffer option");
+
+		do_print(OPTIONS|FLYRECORD, "%d [CPUs]:\n", cpus);
+		for (i = 0; i < cpus; i++) {
+			if (read_file_number(fd, &id, 4))
+				die("cannot read the id of cpu %d from the buffer option", i);
+
+			if (read_file_number(fd, &offset, 8))
+				die("cannot read the offset of cpu %d from the buffer option", i);
+
+			if (read_file_number(fd, &data_size, 8))
+				die("cannot read the data size of cpu %d from the buffer option", i);
+
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
+
 }
 
 static void dump_option_int(int fd, int size, char *desc)
@@ -724,7 +783,8 @@ static int dump_options_read(int fd)
 			dump_option_string(fd, size, "CPUSTAT");
 			break;
 		case TRACECMD_OPTION_BUFFER:
-			dump_option_buffer(fd, size);
+		case TRACECMD_OPTION_BUFFER_TEXT:
+			dump_option_buffer(fd, option, size);
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			do_print(OPTIONS, "\t\t[Option TRACECLOCK, %d bytes]\n", size);
-- 
2.34.1

