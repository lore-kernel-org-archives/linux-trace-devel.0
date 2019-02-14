Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67ABBC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 421F22080A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404695AbfBNOOD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:14:03 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46913 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404604AbfBNOOC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:14:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id l9so6605084wrt.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:14:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=57BUBS4rZy6xZY7bmnUkRT+WKYpMLBy8MxUJ4X1Pomk=;
        b=ikVESOuNi/BS6nCk2Qvb3c5iPQ1QD9idLD3OhTWhzNkHSM7WiAjATVSh28UO2/GzDY
         sy+oD9bNht+juiKFv88RRPzKx+ivcKpaeU2pxXBSQ12kLKYcGVv86xIMhobXtjBsVd4A
         2Echx3siYW2tyLPyc0sIkd13eyA1SFGAo2zwNs+xFu9MMHshKDXvVSM0FLaA5nLm/kq1
         w4fS/T88riJlNaOAe+IulvRXzDdLPjyiez+exmH7MSxqjA34BoymV8ZjR+cYiASsd4qG
         Vu0cd8rjX6wHeLwImHPPTHxJPTWu5IipIaR+8IQPwAPZsEgBFZfPn1Pq7+Vuq/RwdmEH
         k/MA==
X-Gm-Message-State: AHQUAuZWMn03HxuxUoBRshT4t9YUyYq+eOkjCW2KXQDa2f2sLkATft/d
        JV4nJKoZK9XrHW7Ys1Kkxkl3ydc=
X-Google-Smtp-Source: AHgI3IZ1N4k7nZe6n1hP4uShFOPpyDObBGg5yLUwzgFdK4IgSR9De6x2J/xbrTzNdjz3HMmqVLX4eg==
X-Received: by 2002:a5d:4a05:: with SMTP id m5mr3187703wrq.46.1550153640925;
        Thu, 14 Feb 2019 06:14:00 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id m4sm1844840wml.2.2019.02.14.06.13.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:14:00 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v6 08/11] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Thu, 14 Feb 2019 16:13:32 +0200
Message-Id: <20190214141335.28144-9-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214141335.28144-1-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
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
index 875ac0e..7ee6f06 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -101,6 +101,24 @@ static int make_guest_fifos(const char *guest, int nr_cpus, mode_t mode)
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
@@ -179,6 +197,9 @@ void trace_setup_guest(int argc, char **argv)
 
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

