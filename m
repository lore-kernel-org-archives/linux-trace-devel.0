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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B36C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8929960ED8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhINNXR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbhINNXQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:23:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB63C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:59 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id x11so28945234ejv.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84CJPvhzlFAC7i9Uo9LZqs10p/gs28x2Da/5/NO4GPU=;
        b=YInYjSFnjTdWRaKGFnyNFMo8maxsQPsENUDrhXVD9fXoV83tCsJACuvT9oICiEPxqJ
         K46REcR1bE8YSVWvPixgnnHPR7r/kh55qXXFUGK5HXLCx4aq8d3aD1NbJGQbPv8TUxvT
         9oHGSuFFtKOO/CdZRyX4MeBak/dGOvVhPRwJnrbE8+QyxwoUFWxyCLG+fZtobc2vBDyZ
         Yt7RnZjziIqjH5Ond5ElWH/GGHJ66oH/kfdR3gUbbozEyrX9HmbKq7HV/tyhecNXBlaR
         9w3k2QxGJAWkEt9U46miqhlmMXHgQ0p0oTA1Y26pQtLXOsbSIM7PobWE5YYfzDlRv6dE
         1NXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84CJPvhzlFAC7i9Uo9LZqs10p/gs28x2Da/5/NO4GPU=;
        b=79zDJ+M8aOU0DC8Sfzvf66V4jdJL2E3s93TjRO9c/jfQqAmofuBYFfJ/c/n9ay0w4g
         xE5SvcRDLiUFHww10z5noJKvWdxa/e+XuVkEXwdOFpzbBR4iPy7ok5J2MO7GGyfSPI3R
         CWUmMHjN6QtOxBO/FpmbAP5KCljxfcdz9UvRnjoqJlLE2wtNAK+uN+jil9bDfSdWxYji
         wo2FHTaxfZOL7jR8q2czKncczR4xsfIa8S3c1AffcPrFEBHU/gJVeznyVl3w/cen+wXn
         /0CpE5IraSRhY7oLb/UNhrhirc0qe3ni6sKI3uIyLLOdrhPkJJ+6pokK4RDkP+nYK7xQ
         wx7w==
X-Gm-Message-State: AOAM531Qb8eY6b5q8gVm5QkY2xRxyGhjXa6TvC5WPqVbx3/EugCb47k5
        9rqF4XaMX/HORll0Ha8HfcTamQPhR/0=
X-Google-Smtp-Source: ABdhPJwao4dlkxNdFKlDLcvbHv+4dtn4szbaec0evrE5SpHhWY8S5rk/XGU0q8mT+cPhCMDTELhTJQ==
X-Received: by 2002:a17:906:1d41:: with SMTP id o1mr19124581ejh.232.1631625718086;
        Tue, 14 Sep 2021 06:21:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l7sm5708431edb.26.2021.09.14.06.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:21:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 08/10] trace-cmd dump: Dump sections content
Date:   Tue, 14 Sep 2021 16:21:46 +0300
Message-Id: <20210914132148.3968401-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
References: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, dump the content of the headers content, that
are stored as sections. Added logic to dump these headers:
 HEADER_INFO
 FTRACE_EVENTS
 EVENT_FORMATS
 KALLSYM
 PRINTK
 CMDLINES

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 44f103d8..c222cd66 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -686,6 +686,46 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "%lld\n", sec->offset);
 }
 
+static void dump_sections(int fd)
+{
+	struct file_section *sec = sections;
+	unsigned short flags;
+
+	while (sec) {
+		if (lseek64(fd, sec->offset, SEEK_SET) == (off_t)-1)
+			die("cannot goto option offset %lld", sec->offset);
+
+		dump_section_header(fd, sec->verbosity, &flags);
+
+		if ((flags & TRACECMD_SEC_FL_COMPRESS) && uncompress_block())
+			die("cannot uncompress section block");
+
+		switch (sec->id) {
+		case TRACECMD_OPTION_HEADER_INFO:
+			dump_header_page(fd);
+			dump_header_event(fd);
+			break;
+		case TRACECMD_OPTION_FTRACE_EVENTS:
+			dump_ftrace_events_format(fd);
+			break;
+		case TRACECMD_OPTION_EVENT_FORMATS:
+			dump_events_format(fd);
+			break;
+		case TRACECMD_OPTION_KALLSYMS:
+			dump_kallsyms(fd);
+			break;
+		case TRACECMD_OPTION_PRINTK:
+			dump_printk(fd);
+			break;
+		case TRACECMD_OPTION_CMDLINES:
+			dump_cmdlines(fd);
+			break;
+		}
+		uncompress_reset();
+		sec = sec->next;
+	}
+}
+
 static int dump_options_read(int fd);
 
 static int dump_option_done(int fd, int size)
@@ -907,6 +947,7 @@ static void dump_v7_file(int fd)
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.31.1

