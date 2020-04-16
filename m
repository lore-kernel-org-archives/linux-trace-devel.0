Return-Path: <SRS0=rfvd=6A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2743DC2D0EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 07:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0716E206D5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 07:22:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKY3jAVO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439175AbgDPHW5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439180AbgDPHWx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 03:22:53 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C352C061A41
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 00:22:51 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id l11so4808913lfc.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 00:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RIpkkXrxqEwjS9wGiX0zkTSPDY/YukVr7pLtY6yZEjM=;
        b=UKY3jAVOPoR1TaFP2LIPOU2uAsWqHjL3vK7efibJHXAdnPlkF8lA32zo1nHMvqc6HH
         oKKR8KPDjTG3c4modeE6s6JUpnlVgtLzzrPcMIe6Qg9O5+7c+9b1Qd9rM3JObMU2lD/h
         hnvf6HQTI/8B3XyPnTV/7laN3klgDTIBgZBCMWSi1lxP83MRBBiisFoDIabZ9BwQGhLn
         z4qPXPyMNjwqQrEJEGmkEQkUw2dv89g3TU2xK7du+ZX+kDXIJSsmUr3jKgoBXAyIlXYy
         yBkxNOOF9n2dnOVC6aFOXHun2jQ843rkZAZJfvdwxDbkIsENBqynV6MsdZcZ9CLUzyb3
         6Z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIpkkXrxqEwjS9wGiX0zkTSPDY/YukVr7pLtY6yZEjM=;
        b=Qp/lPYSH7E3DSvh88VNS9/Qs1Hv0VrEDvgzC9L/ZSfL9Im8SJNu2PELFooEyhYKW8g
         MxCbOFLM+QKqzeXfnmN9ZPZeGEI2IrM+RVadm4Gq2B6ZU8YLvYwgr0uXHhRfuZF8JqFQ
         xjpc/PUe8XOFRUILTw7lhRcpu3R7eknSrcDgnuk1rKMDBfbKJcIyEYvog7Voamr70FPz
         KroAC9nzFXoIrXEtZEC+I8VkHwWZlX7sfi6GRQMvxcm+jmvFQhppCjywy7Ec6NSTp0Hv
         soVMubko2GjWBN/MrqskMGzTGXExF9LkqC1gPR4gYTOOj2SdtBYlOuZVt5Xij/pSwVP5
         620A==
X-Gm-Message-State: AGi0PuY4RnSf3lhe/GcaQCeR/G6I+c58Y9Cz3yW5MsId+TxZNNEMn5Fi
        o4uuhgT53+Ze+/2BfIoctTQ=
X-Google-Smtp-Source: APiQypKeqeK3AS9IWN/MD/Ep86SllGnlNlvuw41lo61sYF1PC1Ikn7z9S1HtqozSfkEzR634/UWQLQ==
X-Received: by 2002:a19:c3c5:: with SMTP id t188mr5379079lff.199.1587021769586;
        Thu, 16 Apr 2020 00:22:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o3sm9914077lfl.78.2020.04.16.00.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 00:22:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Add error_log dump to trace-cmd stat command
Date:   Thu, 16 Apr 2020 10:22:44 +0300
Message-Id: <20200416072244.50239-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200416072244.50239-1-tz.stoyanov@gmail.com>
References: <20200416072244.50239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In case of a ftrace configuration problem, the description
of the error is printed in the error_log file. It is useful
to dump all recorded errors in "trace-cmd stat" command.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207291
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-stat.1.txt |  2 ++
 tracecmd/trace-stat.c              | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/trace-cmd-stat.1.txt b/Documentation/trace-cmd-stat.1.txt
index 004fbaa5..2f1a9c8b 100644
--- a/Documentation/trace-cmd-stat.1.txt
+++ b/Documentation/trace-cmd-stat.1.txt
@@ -43,6 +43,8 @@ system. The status that it shows is:
 
 *Uprobes:* Shows any uprobes that are defined for tracing.
 
+*Error log:* Dump the content of ftrace error_log file.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 3f7b3493..c5057978 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -897,6 +897,22 @@ static void report_traceon(struct buffer_instance *instance)
 	free(str);
 }
 
+static void report_errorlog(struct buffer_instance *instance)
+{
+	char *str;
+
+	if (!tracefs_file_exists(instance->tracefs, "error_log"))
+		return;
+	str = get_instance_file_content(instance, "error_log");
+	if (!str)
+		return;
+
+	if (str[0])
+		printf("\nError log:\n%s\n", str);
+
+	free(str);
+}
+
 static void stat_instance(struct buffer_instance *instance)
 {
 	if (instance != &top_instance) {
@@ -920,6 +936,7 @@ static void stat_instance(struct buffer_instance *instance)
 	report_kprobes(instance);
 	report_uprobes(instance);
 	report_traceon(instance);
+	report_errorlog(instance);
 }
 
 void trace_stat (int argc, char **argv)
-- 
2.25.1

