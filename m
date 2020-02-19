Return-Path: <SRS0=qXaB=4H=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10CDC34047
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Feb 2020 13:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8625D21D56
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Feb 2020 13:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mRfsDNIJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgBSNOQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 08:14:16 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33336 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgBSNOQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:14:16 -0500
Received: by mail-lj1-f196.google.com with SMTP id y6so347950lji.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Feb 2020 05:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xMitNcptm8evXgZbVR7z8Uz24VrIh48Mnh6jK7793Dk=;
        b=mRfsDNIJa+aafYMMAioxaHEAYRgVw9GXVDn7uvw0uJHzfVGlsxX8GfOK8I6BWQQaBz
         ++oq/zbeQCBZFgqhPUzQwIGsnW/dsKW+9OkafVeHkSwzCAqbn4DMEsQOKuhkt0pNFiYZ
         1TlE1F/4FO0eyOQnBZrHhnZw03wm7zR+HCdykgLMZblQsvhUAkI5T5v2aPMPXoaFcXtP
         yJHjv6rWISbd+TPkHulhGKMa03DuGAYk69IJ0YdrwOd/OiTzBY3MuVHnR220Wt6x0kL4
         0nnFWFGtkZcpY6qPFiVRv4//fgLR7CnWvBIKyGfav8KV0NlYsOIoA+fIZBKQh8CPFMmA
         Nfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xMitNcptm8evXgZbVR7z8Uz24VrIh48Mnh6jK7793Dk=;
        b=J1VWhIqhJl265jAvEZOPGFZAgEXMrjkdI2mNlddFKsC7LniJhPiZRKMOQxW2EHQ7l4
         JUwfGmpLWhJlcURUEwbyYtG8TmuayHPwK1PhsqF1AOXeypI2KLkYzze2cIItujoT7SWr
         gD7AOfpS3oENza9AaWvM1rC5q91Sx25LhqGURRSyHP8Pto63ua+ozuFMD4d/zr1zhfJo
         iS3JRdfMxEOyEnbkVw22jDpQ/XQNP3gAMiAb+RKyzlb137Q5JfxpRLSajxOkGW2Zf/YG
         gufIZ3ggCx2IiwvsWR5LfUvXl8ObnB6WXRtHB5E0Ww0rOQNuQbC2a1Ad17ayWXCeKyL6
         SZKg==
X-Gm-Message-State: APjAAAXmC9+/kZbXNLQvmzQlhyub/HsJdpgGNZTPjLg/zGrKkxuyfwHw
        CZcPnpjIma5WN86K95bLVWY=
X-Google-Smtp-Source: APXvYqxSO8ge/wdHsLYbEDqi+ojrfvLoZwRLjW87I0nV2utuJ1IOzILXKFqH1zDGkF9Yz6iIxMt7Zg==
X-Received: by 2002:a2e:9e4c:: with SMTP id g12mr15491480ljk.15.1582118054482;
        Wed, 19 Feb 2020 05:14:14 -0800 (PST)
Received: from localhost.localdomain ([151.251.253.122])
        by smtp.gmail.com with ESMTPSA id t29sm1285195lfg.84.2020.02.19.05.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 05:14:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/2] trace-cmd: Clear error log on reset subcommand
Date:   Wed, 19 Feb 2020 15:14:10 +0200
Message-Id: <20200219131410.447103-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command is supposed to set the ftrace state to default.
However, the ftrace error logs are not reseted.
A logic is added to delete the content of "error_log" file when "trace-cmd reset" is executed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b6a412e..3e0d066 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4638,6 +4638,25 @@ static void clear_triggers(void)
 		clear_instance_triggers(instance);
 }
 
+static void clear_instance_error_log(struct buffer_instance *instance)
+{
+	char *file;
+
+	file = tracefs_instance_get_file(instance->tracefs, "error_log");
+	if (!file)
+		return;
+	write_file(file, " ");
+	tracefs_put_tracing_file(file);
+}
+
+static void clear_error_log(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		clear_instance_error_log(instance);
+}
+
 static void clear_all_synth_events(void)
 {
 	char sevent[BUFSIZ];
@@ -5382,6 +5401,7 @@ void trace_reset(int argc, char **argv)
 	clear_filters();
 	clear_triggers();
 	clear_all_synth_events();
+	clear_error_log();
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
-- 
2.24.1

