Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC354C4360F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96C2721736
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfBROzM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:55:12 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39865 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729907AbfBROzM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:55:12 -0500
Received: by mail-wr1-f65.google.com with SMTP id l5so17607981wrw.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VI1nGOh4YQXOruxwSs9vvtLfm/uvb9CWUk8ihZF6Ubk=;
        b=rBWsgVENGr7OEipRTjNss7mFZNR/TLPFOLOV5EU8tUFu1HGbrqCcqjUAbocTO7sy8w
         +Qr3pFRxL7JM+ycPEpa8lDERLxUkcsfT13OgVAeyR2asBqyRujYuoOLGAWnn0HAvP6vn
         XipomTw5I6yrdTPKZwjx0cdsQ0o3Z54dWRiJBlpZQa6per+HlcHzy+MsYnONuCWzjPJP
         uDUXrn+L1y3/cLz3eRSVbSpt8V8oczSMLPr4AZWU7fDYXOddNOrwypA3YXNyG7IthIhF
         wJGkdD/R50x/RokpMCnzqxr9iEU+ejLp+qJ+rgWXnCtiHxml0Af3b8x2o6qI4aPpKdGF
         AYOA==
X-Gm-Message-State: AHQUAuaA//XNOsFVDKuBQbUpJ3cILxrM0Q/hLXgLUSECqI+m5Z2BQNf+
        5tjiNNVicSYA1WRpIQ2cLA==
X-Google-Smtp-Source: AHgI3IYPLMgSH/nzU3KINURhYgu8YqOC2PhjVIf3atJm03Cn2kszRkRIzat6gBSkkvwsl6IlZFtzoQ==
X-Received: by 2002:a5d:5506:: with SMTP id b6mr16238262wrv.33.1550501710722;
        Mon, 18 Feb 2019 06:55:10 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id n11sm10172528wrw.60.2019.02.18.06.55.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 06:55:10 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@vmware.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v7 10/13] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Mon, 18 Feb 2019 16:54:46 +0200
Message-Id: <20190218145449.13360-11-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190218145449.13360-1-kaslevs@vmware.com>
References: <20190218145449.13360-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When no number of guest CPUs is provided with the -c flag to `trace-cmd
setup-guest`, try to autodetect it using virsh for libvirt managed guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-setup-guest.c | 21 +++++++++++++++++++++
 tracecmd/trace-usage.c       |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
index ded510e..789dc65 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -91,6 +91,24 @@ static int make_guest_fifos(const char *guest, int nr_cpus, mode_t mode)
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
@@ -169,6 +187,9 @@ void trace_setup_guest(int argc, char **argv)
 
 	guest = argv[optind+1];
 
+	if (nr_cpus <= 0)
+		nr_cpus = get_guest_cpu_count(guest);
+
 	if (nr_cpus <= 0)
 		pdie("invalid number of cpus for guest %s", guest);
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 7a8002f..9a13d93 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -249,7 +249,7 @@ static struct usage_help usage_help[] = {
 	{
 		"setup-guest",
 		"create FIFOs for tracing guest VMs",
-		" %s setup-guest -c cpus[-p perm][-g group] guest\n"
+		" %s setup-guest [-c cpus][-p perm][-g group] guest\n"
 		"          -c number of guest virtual CPUs\n"
 		"          -p FIFOs permissions (default: 0660)\n"
 		"          -g FIFOs group owner\n"
-- 
2.19.1

