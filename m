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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F23C4332E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FEDD60240
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhCOGS7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhCOGSl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:41 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040DAC061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:41 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r17so64171977ejy.13
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BW3AIsyOrPEeGZPh0iFYitfuSlt6vel/Ntkp8lQyFpM=;
        b=WW00BQ+Gl+r/h38TwOzKlUR1j+Uq/NcxQMn/I2RJbmYRrOHpoLG/EpW3XaJuIlQg9r
         98RSPrbvckfOaMRhj3/YKBG9W4I0S/pfySpeja3pcUTbMRBbVzuCcgAkqyPTxJIMMPfL
         g/hpR2uNgnACzqsInsSZBXpUkS1UVsYUFMrEj1k+cuS+WeLb/oc7HdiiWDzwsBxBAv9Z
         BVV5XpVEqMnNqgbMPBAghY5EcEhH27QQBpvZPQId2l//sEjVx7/VFvPFcVm7uBk7+yXM
         FRClohx40N/ksNy8MgKIPQXotiSVs1Rrjc16TNDy+LTCg9aSUjyaZcADGkuBxE2FDWwn
         wy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BW3AIsyOrPEeGZPh0iFYitfuSlt6vel/Ntkp8lQyFpM=;
        b=d26wIqMCygRrUeL5oz5mTUu40Nyj+usVDOL35lVh7gpm7s+5YIZNOh99uEko6HwCS3
         6X0JadmxJRxj/fQtPhUbJSA1YX93k8zPALPKcBDk5AnnEansMeiOsYxrHwgZ1CVeiKbQ
         R2KFNvJuLmW3S+lIZRcziuebwCwgPrlDzMrHiNlQCb6vTeUEF9+dLAK8coTO5al5veBA
         qPXC3zgnbhqiwbeU58YHHsDAAEo4/XXgs3v/z32SObI2Mx7v4/WPPmUcmjDVl5UC2h/V
         Qo7YYUXCA6IrUyweBWAWV5LlxvBPygSlrwdGA66d5A2gNIt1jA9D36Xxw+BPzbUedhXj
         FKww==
X-Gm-Message-State: AOAM532fx8KmV85qMf7AH1A5Hva2fnKCpXn6p0vw2UlS2EPq1IhJIAnb
        /7ucGamRx1ZDX8hdkYbQhH4=
X-Google-Smtp-Source: ABdhPJwjeGMXD2qOWPmJq8WQch2ngCY4X3xYppawZhhyvb4e2V+BuY9nlnccxWTxHKS86m5j5TaUiw==
X-Received: by 2002:a17:906:2504:: with SMTP id i4mr22199782ejb.115.1615789119846;
        Sun, 14 Mar 2021 23:18:39 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/12] trace-cmd: Add a new option in trace file metadata for tsc2nsec conversion
Date:   Mon, 15 Mar 2021 08:18:24 +0200
Message-Id: <20210315061832.168495-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new option is added in the trace.dat file for holding the multiplier
and shift, used for converting TSC trace clock to nanoseconds.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h        |  1 +
 tracecmd/trace-dump.c                          | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 27a96c12..e2ea0dd0 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -125,6 +125,7 @@ enum {
 	TRACECMD_OPTION_TRACEID,
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
+	TRACECMD_OPTION_TSC2NSEC,
 };
 
 enum {
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 6172231e..86524d0f 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -481,6 +481,21 @@ out:
 	free(buf);
 }
 
+void dump_option_tsc2nsec(int fd, int size)
+{
+	int mult, shift, offset;
+
+	do_print(OPTIONS, "\n\t\t[Option TSC2NSEC, %d bytes]\n", size);
+
+	if (read_file_number(fd, &mult, 4))
+		die("cannot read tsc2nsec multiplier");
+	if (read_file_number(fd, &shift, 4))
+		die("cannot read tsc2nsec shift");
+	if (read_file_number(fd, &offset, 4))
+		die("cannot read tsc2nsec offset");
+	do_print(OPTIONS, "%d %d %d [multiplier, shift, offset]\n", mult, shift, offset);
+}
+
 static void dump_options(int fd)
 {
 	unsigned short option;
@@ -540,6 +555,9 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_GUEST:
 			dump_option_guest(fd, size);
 			break;
+		case TRACECMD_OPTION_TSC2NSEC:
+			dump_option_tsc2nsec(fd, size);
+			break;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-- 
2.29.2

