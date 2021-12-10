Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEFEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240250AbhLJLI4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240268AbhLJLIz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:55 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29024C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y12so28156859eda.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cWEUjQFfa9nsvCpsv3XrVF1BP0Zlh07mx2tOZFBg20A=;
        b=eTtfwP1grjULwWNO0QA4ap/t3yyhRhcXLQ/KaK97WQ3TP2HtBuoB/vS15eOjLwm/6S
         NWLH2k94zBQTxB2YFgVrZl6quI+12VxGFBlAkvmdsrMrZieGBkX/zxniOBTnKdBkVnP5
         wJGlY9HSUofu7NhGM6U2T4k/tnFmYCqavMkU8IMy0p5R8HSs9W+DKUDrUYmrITeSFM+i
         h5c4WcXmNReiqEuudkQSR8LeL8vbxQj2/kYY/fFKqUFmE+gSIJ9+fZlRh5J6Z+dsGPEX
         eCMU8GqV5njcDa7EDGXwVQlO2mZsuleNFycw3QPFlMtrNpcj1KguuNpSvfkYK/VnB08B
         b7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cWEUjQFfa9nsvCpsv3XrVF1BP0Zlh07mx2tOZFBg20A=;
        b=Fggk4VvsHxIjmUiDgpGafFFRJxgvS3/lUDDD0gomfCpfFehzsdIXd0vsiYEZrVOWfY
         3XS/HwiBKq5lMuPYIgmoBkjywWJfR601J9q4dQbYsvV/38ICaBpU5jmMct1BZUdzWT/b
         GelkE3ZW/yMH8NXRu0TG3PttR2hI7fSWXVFg80yZ7qe/imM1nAug8nBdc9qbl1ztSyMV
         2Cec4PoTqD61q0z6ACIGQRFnteyXu+a2OuKbhxY8z/tjMvwokHxSA2iXvd53qnw0v0Ej
         sBzPPuoPT62eoaC/jTuINsdlnUPiUcNWOyx/dMfQ0CN1nkLet0uobYwJn/TUk7WYz2l8
         r4JQ==
X-Gm-Message-State: AOAM532hOw/Sqed3kkI6Socg7SLlQMlBwF/J/NMi3syGCEkTCAvzdf2t
        e2zklz8NAamVfslJeC4YypFx1u13tXQ=
X-Google-Smtp-Source: ABdhPJy5di6HKyBGVx/O26ONHX+GqYY0Id7RnD1eS2ugxjl8Zp5N+QQt97bor/zDklNfeU01Sb09jA==
X-Received: by 2002:a17:907:7850:: with SMTP id lb16mr22997356ejc.67.1639134318622;
        Fri, 10 Dec 2021 03:05:18 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 05/11] trace-cmd dump: Read extended BUFFER option
Date:   Fri, 10 Dec 2021 13:05:05 +0200
Message-Id: <20211210110511.98856-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
index 53e2f9c0..e4609c39 100644
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
2.33.1

