Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDC7C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351699AbiASIac (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351821AbiASIa2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:28 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3CDC06173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:27 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j23so2487679edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YA2X64lWedr3ZEFbV5C4jNS63GjKA810+pq88SpYLeI=;
        b=myy6z7E+OU+HAnkV8OUBnhnAz1pCOHPhQqw32ZDT2kOudwqNI0csMTvsiIHL7c6/n8
         gVSDv+tcj58J/Ctjx2jNxT5BM7C5XfxB9khsOHdiIXshusblKVBOd/QxwFxiAcfnOix8
         CJQ4oTTpx7wxPzaHobVeyYM7j7pUnnuL1sWkNeP2EnXoMjVkvUzU+2HFWIpo0KSXZNaa
         1DA7vd8/WyR2V9YtgJHp3dCBjP6H2FRqYbDgA7Hzd5+Q2YgHrvjOWw6dfa8MZJf+RUnj
         MHgDs1+ZE/00vd6cNGEvPYfYHz3FxHgKjn+bOvMkUYbGgGqJ0nnJ/glMmTh3hwjoCG3E
         hpLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YA2X64lWedr3ZEFbV5C4jNS63GjKA810+pq88SpYLeI=;
        b=tfhhJmdeYH7UNcFbFzG+sDNUrCyKO0RpVZUAi/VOYJMpw/bC6r/5r7/BN8DQ8Iv1pC
         jNtaxA+GmyLOsd9LglpztJGOTOD8zaitQQik5108rG/MaVkehc+7gno4WZKshcsmjhUO
         UlShSQekeeCsHqsJr7LnX6qE8Vi17fdiTk+UDY2lhRkT95iA7hPlgvWlvvomMtKhTh0S
         U+6StiL/5+y5fNAZ2kqIAXxDrV8CzFbButjp7uTjDmB/oCKNjSchkOpk/aBgCCKu4mRX
         IMhzZDUb7DK2WoSAl75ohNSXHQ/eE5YfeR/u/wGeOS/zQaIHEibUk1Sj6AZ0ycZoloJC
         Rf7Q==
X-Gm-Message-State: AOAM532jqffvYMMt/HNdO+i35fqZDzxlL4LXYGt+PKPhgD5Pn1PGnPcU
        VoM3L9wvQn4mYqOYukh8IifTvfHdPfA=
X-Google-Smtp-Source: ABdhPJwktKqadYqEYkqbKKoj6r0vIkjBAhmw8igFI6fGTRres8gTc5JsvioUJRp/TrYBIM8YA9Dv/Q==
X-Received: by 2002:a17:906:318a:: with SMTP id 10mr23098044ejy.154.1642581026368;
        Wed, 19 Jan 2022 00:30:26 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 05/11] trace-cmd dump: Read extended BUFFER option
Date:   Wed, 19 Jan 2022 10:30:13 +0200
Message-Id: <20220119083019.246153-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
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
index 7e203ae2..8f81ddb5 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -445,19 +445,72 @@ static void dump_section_header(int fd, enum dump_items v, unsigned short *flags
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
@@ -712,7 +765,8 @@ static int dump_options_read(int fd)
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

