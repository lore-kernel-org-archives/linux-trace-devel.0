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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E22C43217
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04CA761241
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbhIWJrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 05:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240245AbhIWJrE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 05:47:04 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EB2C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 02:45:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g16so15447874wrb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 02:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rtzFmkjXWBWJhMriJIHKyYSGZjqKrmiMzYU4YZpBHNM=;
        b=MbhvcAPIUriQQUGYoSGjbSpgYggoZ8Ynz5sJ2VygZjzLDMDO3qRrIlah3JTnWY+XFm
         EX0niMecRympRW3seqMpCaEr0ojTCnql7GlE/gZbmWgWKdhkhU1RpcmRZglT6siSemo4
         DHxRaxJE7vz7j5vVqrJUKPXgLWSji8WN7yUoT9HAPSTi8zzBl5VH/ysRfY/A58wGVunI
         gGW62wTHkzlh9kwGPHDsTcxij1pjVD/xafUKjhqL8G4IkpXsUhCFp0KAJ3AqGcBwWJxu
         L4K4nqjITK52qCTIO6kOcNL0Sjj7TpC3ey+pGKlA0nAHF2Az1KH9ZkGqD9dhQ/2ElTTC
         lBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rtzFmkjXWBWJhMriJIHKyYSGZjqKrmiMzYU4YZpBHNM=;
        b=1lZQUIi9Abtg+L/A6674pPoof6Ga7mFapoZ+JiRAIQn9nLa+uuXbfrVbUDcHYGPxNu
         plQM3SgOHvaTn2MIroGtnlVvAJyuRWOwsJX83RE5GfxBa/Yhe2R9QJJe4EzSo0JjcHta
         GQpFIKfETEM3skitp0rzrDmLRrOuDRTo01UtYDS+8V3KJPjrkKgtdyErhOb2sgNRBozP
         uZ+dMAHLBLLVCLwOD2JjgXD2yC/rsNMetbu5zZ+IkS1eevnAMaTG5x+Qzy9RcF/TGvTt
         GfkD2AweJMOR5X3t5OtOBBcHUoIIDIVERm0SbePJYqvUI/hqFRcZ6iOxASRkGQk/b13/
         NjHg==
X-Gm-Message-State: AOAM533/bFly63hIpKt2NUPw4tyI9sUO4xqFLsB1XIOuGM7ctuetMZ2u
        fJ388dM519YsnIVX/rw7zTsrQevWC3J9Mw==
X-Google-Smtp-Source: ABdhPJzuYVEXi+DKFqKWwwbGekR0z1dQ/hJlL7Yx7ZlectkxihoWj0/qctcdvgmhlOG5Ebn3B2dA2A==
X-Received: by 2002:a5d:5241:: with SMTP id k1mr3881073wrc.227.1632390331771;
        Thu, 23 Sep 2021 02:45:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d7sm4969523wrh.13.2021.09.23.02.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 02:45:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Dump fraction bits from TRACECMD_OPTION_TIME_SHIFT
Date:   Thu, 23 Sep 2021 12:45:26 +0300
Message-Id: <20210923094526.765059-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923094526.765059-1-tz.stoyanov@gmail.com>
References: <20210923094526.765059-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Dump the fraction bits from the extended TRACECMD_OPTION_TIME_SHIFT
option.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 102 ++++++++++++++++++++++++++++++------------
 1 file changed, 73 insertions(+), 29 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 2334b57e..ed97bd3f 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -376,13 +376,18 @@ static void dump_option_xlong(int fd, int size, char *desc)
 	do_print(OPTIONS, "0x%llX\n", val);
 }
 
+struct time_shift_cpu {
+	unsigned int count;
+	long long *scalings;
+	long long *frac;
+	long long *offsets;
+	unsigned long long *times;
+};
+
 static void dump_option_timeshift(int fd, int size)
 {
-	long long *scalings = NULL;
-	long long *offsets = NULL;
-	unsigned long long *times = NULL;
+	struct time_shift_cpu *cpus_data;
 	long long trace_id;
-	unsigned int count;
 	unsigned int flags;
 	unsigned int cpus;
 	int i, j;
@@ -400,41 +405,80 @@ static void dump_option_timeshift(int fd, int size)
 	}
 	do_print(OPTIONS, "\t\t[Option TimeShift, %d bytes]\n", size);
 	read_file_number(fd, &trace_id, 8);
+	size -= 8;
 	do_print(OPTIONS, "0x%llX [peer's trace id]\n", trace_id);
 	read_file_number(fd, &flags, 4);
+	size -= 4;
 	do_print(OPTIONS, "0x%llX [peer's protocol flags]\n", flags);
 	read_file_number(fd, &cpus, 4);
+	size -= 4;
 	do_print(OPTIONS, "0x%llX [peer's CPU count]\n", cpus);
+	cpus_data = calloc(cpus, sizeof(struct time_shift_cpu));
+	if (!cpus_data)
+		return;
 	for (j = 0; j < cpus; j++) {
-		read_file_number(fd, &count, 4);
-		do_print(OPTIONS, "%lld [samples count for CPU %d]\n", count, j);
-		times = calloc(count, sizeof(long long));
-		offsets = calloc(count, sizeof(long long));
-		scalings = calloc(count, sizeof(long long));
-		if (!times || !offsets || !scalings)
+		if (size < 4)
 			goto out;
-		for (i = 0; i < count; i++)
-			read_file_number(fd, times + i, 8);
-		for (i = 0; i < count; i++)
-			read_file_number(fd, offsets + i, 8);
-		for (i = 0; i < count; i++)
-			read_file_number(fd, scalings + i, 8);
-
-		for (i = 0; i < count; i++)
-			do_print(OPTIONS, "\t%lld %lld %llu [offset * scaling @ time]\n",
-				 offsets[i], scalings[1], times[i]);
-		free(times);
-		free(offsets);
-		free(scalings);
-		times = NULL;
-		offsets = NULL;
-		scalings = NULL;
+		read_file_number(fd, &cpus_data[j].count, 4);
+		size -= 4;
+		do_print(OPTIONS, "%lld [samples count for CPU %d]\n", cpus_data[j].count, j);
+		cpus_data[j].times = calloc(cpus_data[j].count, sizeof(long long));
+		cpus_data[j].offsets = calloc(cpus_data[j].count, sizeof(long long));
+		cpus_data[j].scalings = calloc(cpus_data[j].count, sizeof(long long));
+		cpus_data[j].frac = calloc(cpus_data[j].count, sizeof(long long));
+		if (!cpus_data[j].times || !cpus_data[j].offsets ||
+		    !cpus_data[j].scalings || !cpus_data[j].frac)
+			goto out;
+		for (i = 0; i < cpus_data[j].count; i++) {
+			if (size < 8)
+				goto out;
+			read_file_number(fd, cpus_data[j].times + i, 8);
+			size -= 8;
+		}
+		for (i = 0; i < cpus_data[j].count; i++) {
+			if (size < 8)
+				goto out;
+			read_file_number(fd, cpus_data[j].offsets + i, 8);
+			size -= 8;
+		}
+		for (i = 0; i < cpus_data[j].count; i++) {
+			if (size < 8)
+				goto out;
+			read_file_number(fd, cpus_data[j].scalings + i, 8);
+			size -= 8;
+		}
+	}
 
+	if (size > 0) {
+		for (j = 0; j < cpus; j++) {
+			if (!cpus_data[j].frac)
+				goto out;
+			for (i = 0; i < cpus_data[j].count; i++) {
+				if (size < 8)
+					goto out;
+				read_file_number(fd, cpus_data[j].frac + i, 8);
+				size -= 8;
+			}
+		}
 	}
+
+	for (j = 0; j < cpus; j++) {
+		for (i = 0; i < cpus_data[j].count; i++)
+			do_print(OPTIONS, "\t%lld %lld %llu %llu[offset * scaling >> fraction @ time]\n",
+				 cpus_data[j].offsets[i], cpus_data[j].scalings[i],
+				 cpus_data[j].frac[i], cpus_data[j].times[i]);
+
+	}
+
 out:
-	free(times);
-	free(offsets);
-	free(scalings);
+	if (j < cpus)
+		do_print(OPTIONS, "Broken time shift option\n");
+	for (j = 0; j < cpus; j++) {
+		free(cpus_data[j].times);
+		free(cpus_data[j].offsets);
+		free(cpus_data[j].scalings);
+	}
+	free(cpus_data);
 }
 
 void dump_option_guest(int fd, int size)
-- 
2.31.1

