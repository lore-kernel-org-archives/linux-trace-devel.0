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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6981CC433E4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414E961A21
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhCYGlf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhCYGlF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:05 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0A2C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:05 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c8so1078259wrq.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uv/CogdT8ceOEw3qj2CE7HWQcP8kkyyYvyFfuCggMho=;
        b=fp2QmcsqpniWGcu1XMtxrepCDRbti84E6lq/JSmAYMjA3gocfEbh1pJWhmeCCT1SoA
         koRe4vvds8hGUh7g2dwOn/oku1EPlfwio4ejGozNNjtcusMJmMLw61GXQFUVyB8fCtED
         PEVnbXFQV/8KZmHsyuVDVPLvxQmIr3Mokw06z3p5sH77G2bw+qhbG9kEJ0+0kTF3Rx+q
         Z4Z0luzX4e1+G0b3DcjOqGR8geh/Sd2Ii0umcSPP/xyO3UETNFYNrgGxgsXZe8Zxt7yA
         rHjBY4LSF4ONkvfQFneBEqo1NkU0ebqkPgaVoaTjsxUEySQIi7N2wuIPTktieb+gWqon
         Qx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uv/CogdT8ceOEw3qj2CE7HWQcP8kkyyYvyFfuCggMho=;
        b=QH3MLM+zAlLgRwq7cict7lHEdYMFnd3eJIhbZE0Y8rWrJB4RBu8ZPX3Vg8otQRnCYK
         Axn+t7lNJxTZaowv4e469tGQqx1yued0OLyEzKczOlmnhpqGqis7Ty+z9ic3KBi89oqk
         Op7IWoNmJFamQQVvgoFoLaaOVLu0y6Hg7J0juZzZShMW1Jc97vQBezFrRb6OimRFNoHe
         gqkI7LBtGJpKHTe6UUsJkFPQOg2nm24MaQS2NFBD/7wazM3PEcAP9RdyALiIuK0NPARd
         VTnMOWuJkHnbuRIG37qyYvnZi/IWNoDfTTlvI1HE+ffCRUwHMCiNuFi3WIWTPAnXWBLb
         ZXIQ==
X-Gm-Message-State: AOAM531CXlpQO0s0320HWpc5/KtwlzunjiDa4eShe5JoKhPs63uexVXZ
        ZbPXszm3zte56aQabuof0yV0EmRX0Gg6Og==
X-Google-Smtp-Source: ABdhPJyYHEk6+ZsMLJinUVWDjaaK+BYEu/qtVoy8t/HA5DjKJ/lUb76eVoMDjoKp4bqnXDrcbFYHyg==
X-Received: by 2002:adf:f005:: with SMTP id j5mr6919179wro.423.1616654464119;
        Wed, 24 Mar 2021 23:41:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 07/23] trace-cmd: Define a new option for tsc2nsec conversion
Date:   Thu, 25 Mar 2021 08:40:39 +0200
Message-Id: <20210325064055.539554-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a define for a new trace.dat file option for tsc2nsec conversion.
Added logic in "trace-cmd dump" for parsig the option and printing its
content.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 tracecmd/trace-dump.c                         | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a4637046..ce3d8dc0 100644
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
index 5db1ecfa..24ec9695 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -483,6 +483,22 @@ out:
 	free(buf);
 }
 
+void dump_option_tsc2nsec(int fd, int size)
+{
+	int mult, shift;
+	unsigned long long offset;
+
+	do_print(OPTIONS, "\n\t\t[Option TSC2NSEC, %d bytes]\n", size);
+
+	if (read_file_number(fd, &mult, 4))
+		die("cannot read tsc2nsec multiplier");
+	if (read_file_number(fd, &shift, 4))
+		die("cannot read tsc2nsec shift");
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read tsc2nsec offset");
+	do_print(OPTIONS, "%d %d %llu [multiplier, shift, offset]\n", mult, shift, offset);
+}
+
 static void dump_options(int fd)
 {
 	unsigned short option;
@@ -543,6 +559,9 @@ static void dump_options(int fd)
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
2.30.2

