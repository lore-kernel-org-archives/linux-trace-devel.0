Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5D2C31E5D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2315920B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWyabBVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfFROpP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46219 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbfFROpO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so14272152wrw.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EXWmlzBvw3BAUKdyQKPZwLK9Y0qN0eFtSBA29XCQezA=;
        b=GWyabBVMeJvcaqglJx0DurnDEfB5+Eibl324hc/6x94zboKFxtyfBU30HnqBOSC9cu
         nJOwNKX5QiG7XMEUr+jBWf09fxXc11FreYnOlfcmwaGg6rtIjlUVaehfFHApPW0J00Yk
         sFhvT9NHpS5Yp/drW+Re1yUiVMotzdsjTlDhlLM9AHzji4Dd3S0FCIlGhEBxWspCDhu0
         IPbOh2gjfriUd2qbaCtIXI4BZYvmg6OnQ5wDZ/OmJqVzgr/6W0xQRQ8Xb2DV7kapzBk9
         vsvr9WGZRCWEItSIFRk4pxRHrMKhVJQdOJ8jPDJbc8mPGWuy8/VHs872L1NPtp+R5ZE3
         hPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EXWmlzBvw3BAUKdyQKPZwLK9Y0qN0eFtSBA29XCQezA=;
        b=VQ1bDNGoF6fmaWa13+eQd6t5EH/pNuML0CXmv397kI3BQ6Yu/lkAwyGsGgG3aAwKes
         95Thkdc7jbCNzpN5asenWM3HKnfeez/o4/C+Fs1ofkI2J0YclWaCdo/SsQZKYIwWa8kw
         wkGhStBtZ+51kbGhyBm6k28VJ5plvf0Q7noV6y6eHKIa8ynFleX5Dtu0CSjMizI4AiEx
         j8ruOrQwTxjgADDxu/RIXvC0Nh9BSgdqvG12D5yq3jkKRNx2qJIRZQXKhn3wabePy2ts
         OzhHSd/Tflv/5I4d3DYFZbeDbUjxIq8AoEWZh/7g7DxPw29t2ng//JDu+seH+f82cTFr
         r7Ig==
X-Gm-Message-State: APjAAAXYggGjg4QDmduxKPgrRWokztuZv1yS3PqkGyZdBqjZqReHLzFK
        A151cULu7akVX1SGpd679A==
X-Google-Smtp-Source: APXvYqyaZuLiZkfhecVY4pSQq7a1F+SkkS9xBJzoIZJTtoz7RUEAj8H74A6874wWrpuTKKt9FcfBtA==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr29938829wrw.8.1560869112468;
        Tue, 18 Jun 2019 07:45:12 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:11 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 10/13] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Tue, 18 Jun 2019 17:44:52 +0300
Message-Id: <20190618144455.3954-11-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
References: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

When no number of guest CPUs is provided with the -c flag to `trace-cmd
setup-guest`, try to autodetect it using virsh for libvirt managed guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-setup-guest.c | 21 +++++++++++++++++++++
 tracecmd/trace-usage.c       |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
index a6f58dc..a55a37d 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -93,6 +93,24 @@ static int make_guest_fifos(const char *guest, int nr_cpus, mode_t mode)
 	return ret;
 }
 
+static int get_guest_cpu_count(const char *guest)
+{
+	const char *cmd_fmt = "virsh vcpucount --maximum '%s' 2>/dev/null";
+	int nr_cpus = -1;
+	char cmd[1024];
+	FILE *f;
+
+	snprintf(cmd, sizeof(cmd), cmd_fmt, guest);
+	f = popen(cmd, "r");
+	if (!f)
+		return -errno;
+
+	fscanf(f, "%d", &nr_cpus);
+	pclose(f);
+
+	return nr_cpus;
+}
+
 static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gid)
 {
 	gid_t save_egid;
@@ -171,6 +189,9 @@ void trace_setup_guest(int argc, char **argv)
 
 	guest = argv[optind+1];
 
+	if (nr_cpus <= 0)
+		nr_cpus = get_guest_cpu_count(guest);
+
 	if (nr_cpus <= 0)
 		pdie("invalid number of cpus for guest %s", guest);
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 0d1b58e..a2a520c 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -251,7 +251,7 @@ static struct usage_help usage_help[] = {
 	{
 		"setup-guest",
 		"create FIFOs for tracing guest VMs",
-		" %s setup-guest -c cpus[-p perm][-g group] guest\n"
+		" %s setup-guest [-c cpus][-p perm][-g group] guest\n"
 		"          -c number of guest virtual CPUs\n"
 		"          -p FIFOs permissions (default: 0660)\n"
 		"          -g FIFOs group owner\n"
-- 
2.20.1

