Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF4EC4CECD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC42F2171F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfIQNP6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:15:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53028 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbfIQNP6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:15:58 -0400
Received: by mail-wm1-f66.google.com with SMTP id x2so3390194wmj.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 06:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JCNgQ67sbTc5rsl3eJYEuZk9Li9O5zUsndsWEkzhvh0=;
        b=Ydr+WEgzT+xhyYNGCvjNZYEFCTEn4FQOzy+UMjknwS8IVf1HUoUWyFDx8cknv4mojr
         nMJkdI2xXOWw9bq4eu1IqVeS461cJN5jnRNVzJHO2GQlmCbwhJ1J7JoI8w4mWsSW411D
         dMG6pni8QbG1P/ayjPO4DWN5T9jjuzj+RfttGLrhM4gz8f+AC1VfabGQ2b9YtKlHQJJo
         FEhGWFcIaxSMRDxAarnZ7rEJ4hu9GYG8JUYfi19aGUgJlSTXF7S9qv/AaUHJ4pZF5VWw
         UxUXbjHUUaFK4o/Te6NAN4U1Mzi1YyjGg9m8p+5BxEVdvvUS6wyQo8QcJiq+tOT/RhCs
         t86g==
X-Gm-Message-State: APjAAAW+uV530spdztz74CaVQu6tMqDZPhQY3hO0SiRoYp5RfKgoUDzJ
        AIfTzur6C6/5nb4F7z+cG3ZiNpU6bA==
X-Google-Smtp-Source: APXvYqxDam4a5XQ266DaQ9goa7jvl3Ne7Bg3yrtSEnqKRlal3gTTH9zjTp0TNBNikddA+UJk7r2d3Q==
X-Received: by 2002:a05:600c:291c:: with SMTP id i28mr716861wmd.98.1568726156437;
        Tue, 17 Sep 2019 06:15:56 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d22sm1667265wmb.44.2019.09.17.06.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 06:15:55 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 10/13] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Tue, 17 Sep 2019 16:15:35 +0300
Message-Id: <20190917131538.31926-11-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190917131538.31926-1-kaslevs@vmware.com>
References: <20190917131538.31926-1-kaslevs@vmware.com>
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
index 2caff0e..6c8dc10 100644
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

