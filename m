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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA72FC4320E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D466660FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbhG1NeI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbhG1NeH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:07 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09357C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:03 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id go31so4631500ejc.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVgcQ054TzlseuUkjG0ta+zXAdH5bdxjdFF14khoTQI=;
        b=sxP1J+VMAj2K3/PBfLv4kU1I6GtJkv5rF91EEMCdLxTluro3Kw2UrjJy5Hr0EI0a7g
         Swm061lX0ls002Z6eJ+f31yUzs91MtF+qPJ9WtsFyLRxURXXYPb4Xba2wwvjHwwJLXsB
         4IQvll1N8gTb0IbdHEcg8Pz/RO34VMwiCieiFWDwfngEqXr4b2rfry5MD1y58qyxW7Ky
         iNbgOSgACRaj905fU4HH89MUamusCEhZEeacYYfwDRvl5NlHP1TgxPOfeE5Lr2SNVxps
         Xzlmy0GLX62zpjiNNbIGojeF2GMkcTfO+bmg91d8ugJiacnw3PBam2BDSNdMg4ROnnrZ
         oLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVgcQ054TzlseuUkjG0ta+zXAdH5bdxjdFF14khoTQI=;
        b=ZNEMrjWkRkuWkpsRGx4uG2Bg2BGChKiJEQqOICEXbmqO8L6UmAtbHDKgoHfZrWoeST
         IlSXEiyTPrk1HiCA1O77ry2jU86HSM/WvwQAuWLcVUXglV7/p/UndelgS+01WfeeRtcT
         ocu1TuY/KjOrZ2dI36RyxsLRZaLLhFaSpqdhabqcoYWZl8gZenzX1D/m72i/aLFit8za
         bqHRu9SwyLdURkvjOY6TS8kbXEI5iexC1T27HDc7ABr/kjXmI65JxN0Ba0HOcgD27zyZ
         cKHQr+2/nvBdFnEVSAPc7APDKKfy0BLB6PV4SbBldEUd4mktx/DOf4E3eVuTV4WTT6I3
         5XuA==
X-Gm-Message-State: AOAM531VoY54Sq+dFfxCIn/OBFm+Hvw5Vh9Ds2V8PaWTIZ5AtHmsBgGm
        VQxX4zgy+GB6ODInRKJ0BOEHMuobRyOSFA==
X-Google-Smtp-Source: ABdhPJxQMMUq9KQLPv0Ne/TGt4Z6abw6lZhkm3Tm5mhqeSE38nO7ks4pfNppkds8McGqITIY1T3i8A==
X-Received: by 2002:a17:906:7111:: with SMTP id x17mr26850439ejj.294.1627479241624;
        Wed, 28 Jul 2021 06:34:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 63/87] trace-cmd dump: Print compression header
Date:   Wed, 28 Jul 2021 16:32:26 +0300
Message-Id: <20210728133250.234140-64-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Dump the compression header of trace file version 7

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index e150a17d..e6f774bd 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -217,6 +217,29 @@ static void dump_initial_format(int fd)
 	do_print(SUMMARY, "\t\t%d\t[Page size, bytes]\n", val4);
 }
 
+static void dump_compress(int fd)
+{
+	char zname[DUMP_SIZE];
+	char zver[DUMP_SIZE];
+
+	if (file_version < 7)
+		return;
+
+	/* get compression header */
+	if (read_file_string(fd, zname, DUMP_SIZE))
+		die("no compression header");
+	if (read_file_string(fd, zver, DUMP_SIZE))
+		die("no compression version");
+	do_print((SUMMARY), "\t\t%s\t[Compression algorithm]\n", zname);
+	do_print((SUMMARY), "\t\t%s\t[Compression version]\n", zver);
+
+	if (strcmp(zname, "none")) {
+		compress = tracecmd_compress_alloc(zname, zver, fd, tep, NULL);
+		if (!compress)
+			die("cannot uncompress the file");
+	}
+}
+
 static void dump_header_page(int fd)
 {
 	unsigned long long size;
@@ -715,6 +738,7 @@ static void dump_file(const char *file)
 	do_print(SUMMARY, "\n Tracing meta data in file %s:\n", file);
 
 	dump_initial_format(fd);
+	dump_compress(fd);
 	dump_header_page(fd);
 	dump_header_event(fd);
 	dump_ftrace_events_format(fd);
-- 
2.31.1

