Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E54EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B70D61284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhKKPPt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbhKKPPs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:48 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B17C061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:58 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id v11so25489868edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QPIUFJpkqiAuUFuCW3190ZdxIDY1q5QX69WLW69uC4o=;
        b=pbgGKIgvrN3RDX5yJjS04DYAO9nwvYnHqSB2HCYP3H4bQOmWuD7F29yl7Ls5gn+1A4
         hhT1cHOsQAF9ZYIfw5SKNYhEfYGpepT7tekdp+Bxgy8JBY+FHA7KoleTG9vi3XPOH1uI
         qvy8w4sr0fCwf/H+aKhE9rvLjGRtPWKNY5jfjAWRA5rJQLuMhlc3vpTjnhr/vzhcPfJA
         7yU7SPJCd5bHLJGZa+Cd11WhLscOaAGbAWaxyOCOuFo3plKmPQdxpub8e9tk36P+/Qqn
         dyKhwd2G02gq9hptypTaQoTY+FaPiOQPjvNmN8SXXUS+HCySg4soMu92PL35e8EOHHIE
         gobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QPIUFJpkqiAuUFuCW3190ZdxIDY1q5QX69WLW69uC4o=;
        b=vc9b2YuWreU1D293h08ny4Y8YAT6L15z4zaJq+Db4dT7XIqpXLoNs8x9csMLsh7mh1
         KU+aBV5h4mtGTCCrpFsp+BM7Lv1kCdHig2eQshZW++NKCHodJ9xYxWJ5ZMlxKJRsrqCS
         dd2YXeQfOzEC85AgCC4J/as0yN7QryR/Mr8B+uVdghpeuLOQZ3JZ6fzTY+/Gsyhzs2kD
         PlGabsj4GKvtEf9UDt19SJAKueMeQT+Pp48GSaRUB+nQ10pq/uJ7VxB28xO8vJdXPVds
         OYeMop7U0bccCzCaQGtDzztxl2WMaTcSJwWw2FyQiftLMrAUFrXY3GSjqaDWzTBhSjzN
         m0Qw==
X-Gm-Message-State: AOAM533gsqCWKfi3Vwd6KYkRzq4630l7vxKIzlF7Bo2mb2dKwYnw+/8v
        hQwfhL0F9lwBM3+E0jHR/RRVSTT1KRfRsQ==
X-Google-Smtp-Source: ABdhPJxIGZKu1ujIw3ihAn0eZmeEgqKlB0tG9ihw/VCcOamZ/7tGwO67Nl62aiyp7DMLoahtvXIWLg==
X-Received: by 2002:a17:907:961a:: with SMTP id gb26mr10150908ejc.71.1636643577550;
        Thu, 11 Nov 2021 07:12:57 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 05/10] trace-cmd dump: Read extended BUFFER option
Date:   Thu, 11 Nov 2021 17:12:45 +0200
Message-Id: <20211111151250.87023-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 64 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index a808c7d7..f8909faa 100644
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
@@ -710,7 +763,8 @@ static int dump_options_read(int fd)
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
2.33.1

