Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4E6C432C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 761D1206F0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OdHm6J9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfK0ODB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:03:01 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41911 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfK0ODB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:03:01 -0500
Received: by mail-lf1-f66.google.com with SMTP id m30so15407935lfp.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mbo/FhDWiM3iQRKq3HmZqi0SKBs3Z36LWNAIYDw5KJA=;
        b=OdHm6J9W+J40uKADy9dH+JZmgHNKCEZ5ud2aaSERrbd8zjgyHa6NuDmk44JtRIXGWE
         YGCk0Mif9F0jaA18cmRUrf6ov1FiyV4xptwDQO8fYvezhKakmDoBlaSs+9kljJfHWPOS
         rh5yD4wIDyCY9OKHOy/rcCdeLKVbnBv3DusmIszz5fM8yZpSyNSDQBoPcpAGNJrNHEfR
         HftP4uDGiko6DqEnNN4co2T2CFDdzp+4ME7gwnyNZBCf/mDcXEZa/WAhnTzd98scsoaH
         uTf5hjNJ9AJuxERFef97qEmgJ5OCYhILGh7aDQhlSaxgxgh4W9HkH/R4irXOxYdEEUzq
         BVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbo/FhDWiM3iQRKq3HmZqi0SKBs3Z36LWNAIYDw5KJA=;
        b=UdxzPEeyE5dH+eKuGv9MFxEzGb0mFShyL519W21wzRmbIsshisujY1RwkL7zqkVNis
         oEXbbdnoXnLP4i2EmNDhZqFie5j2BPAbhc64mm5Lo/lTUxIOU2SRj86hGhKKtQOPNYs6
         lt5DLiXLxga6XT8K97W0NgjHZLchbzd8AKYoUc4ijK4wJpysevyuiYRq7L26BmYV5Z3X
         tOMCCzWfMIfenUzyAR2CHMIPnnHsPB8ZjWk/tP/9cIxJQwX0uw8r3jUdeucU5lo2YhZE
         nfg4BM1rm6fc+E/BuJBgqvWaer7WIXPmVSJqunZtKhEghpNqzACiMv8rIPzhWgJ5+aY9
         ilIw==
X-Gm-Message-State: APjAAAUdTT0/vNk2nI2kE/bmXXAULaJjn6gf1EFNVCbXOoMrQhaC7o6o
        Ks11dZ10ZIhS9e0nTkMAQLc=
X-Google-Smtp-Source: APXvYqyh5H1Z1plCulI2pVQro1N0NBAX6kyID2JWn2TcDlwa7AVW1dJ9m2uNMVl/THtUdjgVOYfhHA==
X-Received: by 2002:ac2:5e9c:: with SMTP id b28mr15611156lfq.138.1574863379137;
        Wed, 27 Nov 2019 06:02:59 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:02:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 08/19] trace-cmd:  --del the tracee address map into the guest's trace.dat file
Date:   Wed, 27 Nov 2019 16:02:36 +0200
Message-Id: <20191127140247.258766-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd option "--proc-map" saves the address map of the traced
applications in the trace.dat file. It does not work if that option is
specified as guest command line parameter.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fd7ca82..a08ee52 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3802,6 +3802,7 @@ enum {
 
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
 {
+	struct buffer_instance *instance;
 	int type = 0;
 
 	if (ctx->date2ts) {
@@ -3818,6 +3819,9 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	add_option_hooks(handle);
 	add_uname(handle);
 	add_version(handle);
+	for_all_instances(instance) {
+		add_pid_maps(handle, instance);
+	}
 }
 
 static void write_guest_file(struct buffer_instance *instance)
@@ -3953,10 +3957,6 @@ static void record_data(struct common_record_context *ctx)
 		if (!no_top_instance() && !top_instance.msg_handle)
 			print_stat(&top_instance);
 
-		for_all_instances(instance) {
-			add_pid_maps(handle, instance);
-		}
-
 		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
 
 		for (i = 0; i < max_cpu_count; i++)
-- 
2.23.0

