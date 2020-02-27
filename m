Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5844C5ED34
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D0D424690
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NcIBPNSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389275AbgB0OUI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:08 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39484 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730238AbgB0OUH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:07 -0500
Received: by mail-lf1-f68.google.com with SMTP id n30so2213320lfh.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XXTKd2psy9mP8VEKnv7+0siRIXSAJcGRCU8ojoFidxY=;
        b=NcIBPNShofD5hJ73u/EWZSj3+d4VhqCpVgz2oAC1PyI/xDE8AXtBtPju/uhYqn2Ud3
         gs76M2LRMrz2WlBRkLRXKYMSEzJ/KmWKldo6xD3rmGeaEBZzfDFvBleY2AEFI5kYhGvG
         7iWV77DDth4awoyIKyT7Sh1cNxguQelviw44at8IYTqo1Ens5xxOAT21mxoMMTFJkQpH
         aO17Yuke+X9U3gYMyltd0m28zPL7U/C+0ZVrRsl21gBMu+2P+X0phIu4QWZpx7HWOHjm
         HN/VK6YJ9nypNC54Uo3I+mFoltNV7xABv7bIHNvJnUTHLRet7ytWIq34QRKkUEGZSojy
         kibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XXTKd2psy9mP8VEKnv7+0siRIXSAJcGRCU8ojoFidxY=;
        b=sLvIKi9ce2ufPiE9sFB1v3d9kZSySOPFVmJVfaW+W7JWiHGmZPv0Vm6ZtlXL2Es15a
         f4R5f/fmzUllfiLNFdSrSYH5d5fDtiinrLWqfs2vaGr7nmzpKD19S7VjMJwmOpesZHhz
         ycU3M6AfXqNEeZNKIfwYwe5KGQo6GSsOmaNzfQTuKUosrLJyNxfgP7Mf2ys/Np1jTHYG
         bAI441p0EUkpC5bYBx0N+pGtZGaIv+1p3X2+XeNvLXutRd75n6VpjBRJtQm1WuDXfmMk
         rOCTjKXZIbJGuxxtF0Oq7ih+3PmIhju1fnadFy+QQd/GZqsjhbcX9t8UgVrB4YzOrn/h
         1jJA==
X-Gm-Message-State: ANhLgQ3YFBTO3obKMcjS1XFy/XVmNEYbgpjF/92P/DZMKjspey/8LmgJ
        5q/rbae01RUDkMg03grxKOU=
X-Google-Smtp-Source: ADFU+vvd2S9JXaxm/fdR+qSipFL4HdvBnj9cRwiw5RJRPo8Nr9BnSpj2DXGcztXGz6pBz4vQYvwhJw==
X-Received: by 2002:ac2:5c4d:: with SMTP id s13mr2426223lfp.128.1582813205703;
        Thu, 27 Feb 2020 06:20:05 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 01/15] trace-cmd: Add support for negative time offsets in trace.dat file
Date:   Thu, 27 Feb 2020 16:19:47 +0200
Message-Id: <20200227142001.61577-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

When synchronizing timestamps between different machines, there are cases
when the time offset is negative. This patch changes the way time offset is
written and read from trace.dat file - as signed decimal, instead of hex.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h | 2 +-
 lib/trace-cmd/trace-input.c   | 6 +++---
 tracecmd/trace-read.c         | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index a243c250..6763715f 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -161,7 +161,7 @@ const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int ind
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
 
-void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
+void tracecmd_set_ts_offset(struct tracecmd_input *handle, long long offset);
 void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
 
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a402f687..842a4c3b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -93,7 +93,7 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
-	unsigned long long	ts_offset;
+	long long		ts_offset;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -2036,7 +2036,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 }
 
 void tracecmd_set_ts_offset(struct tracecmd_input *handle,
-			    unsigned long long offset)
+			    long long offset)
 {
 	handle->ts_offset = offset;
 }
@@ -2215,7 +2215,7 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 
 static int handle_options(struct tracecmd_input *handle)
 {
-	unsigned long long offset;
+	long long offset;
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 8c2b2ae3..c184c627 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -58,7 +58,7 @@ static struct list_head handle_list;
 struct input_files {
 	struct list_head	list;
 	const char		*file;
-	unsigned long long	tsoffset;
+	long long		tsoffset;
 	unsigned long long	ts2secs;
 };
 static struct list_head input_files;
@@ -1466,7 +1466,7 @@ void trace_report (int argc, char **argv)
 	struct input_files *inputs;
 	struct handle_list *handles;
 	enum output_type otype;
-	unsigned long long tsoffset = 0;
+	long long tsoffset = 0;
 	unsigned long long ts2secs = 0;
 	unsigned long long ts2sc;
 	int show_stat = 0;
-- 
2.24.1

