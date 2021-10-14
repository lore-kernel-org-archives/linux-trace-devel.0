Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CB0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40BBF61039
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhJNPOL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbhJNPNN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 11:13:13 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1BBC02B8FC
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:15 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k7so20313923wrd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UnrTaJucvP8KStCn1jvDja+mjxB7JobPdys1FSeBDAk=;
        b=GFqnfODYp+VVf8ePwmFnWmV3GV/ZZtelNF5Sun+kTXMF5S9gJl8SrxoQf/QCCzNyRY
         YnEQeRGKkmEtzaniaRnDDxvjwh1LKDgEeO3Jn1MhnOJBhrJLKgPlC0IFiEcdg60ufINY
         M9+lhNGZSy6FjjH1YdPBLv+Kjs73vj+SGwC8xcqWJXnzLuSKincDzqCsEEYtnXXnaeik
         imUF8JBETH+VHD93fBu99crk7Yt/UjEjNz+sNV55cJz9omTdglMkgTS7QKxpQHXsbspT
         fTTFSthoOpk9DMDZsu7U4fnKL8IO+GSLF3/C22kgTNtv04ow+mK9x4hnHeVctMyUEbdi
         1Rmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UnrTaJucvP8KStCn1jvDja+mjxB7JobPdys1FSeBDAk=;
        b=UimW8Vb2HO1cdytSZbim7hgS0CQJ5piVxKvtWduDn6f/H5jPn7gTZeDagTRindrKNK
         3vpdeZkuxR3vw1ScXIU5Jo71qixQY2caCiWHc7MCa74usON9Tzn7/rKL11hDAxmGWk8b
         40WKW9MWAcaugyfZP60lTSa+IU9SuGXENH6y++c2GBEmwejcWKP1i0Y6sHAKzvTXM485
         graZAuPRuKJpGOjc29bV9CayGPc6sJ9Ek90b3ZCck5M+VSNzVV3eBEHgmXjP6qDhjZv0
         RiDicMVwdMHz967UMQ0aPQBYuhX/dPCJ7QLsl+zd87TkJi0XdfNR2GKz23MIu3RdIDuX
         hVIw==
X-Gm-Message-State: AOAM533fem8jNrTQi+P7Hq+xlJJEVglLjVsBgjOCs3kl487fsLJiUfIT
        306g6ww5YiVCaXhYVmsIx3N8vITjSsXvsg==
X-Google-Smtp-Source: ABdhPJywevTqDnU2WJ+BDoFdai1jdP8Nz3Rlp+13t0F1ulaW2mQq41L4B8aq7N1GAFO44LK9cOUQ1w==
X-Received: by 2002:adf:ee8b:: with SMTP id b11mr7046072wro.349.1634223733650;
        Thu, 14 Oct 2021 08:02:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm2738065wro.25.2021.10.14.08.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:02:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/4] trace-cmd: Dump fraction bits from TRACECMD_OPTION_TIME_SHIFT
Date:   Thu, 14 Oct 2021 18:02:04 +0300
Message-Id: <20211014150204.2485499-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
References: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As the TRACECMD_OPTION_TIME_SHIFT option is extended with new data,
fraction bits used to calculate the guest TSC clock in case of clock
scaling, it will be useful to dump that new information.

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

