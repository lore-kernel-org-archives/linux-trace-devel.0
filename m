Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6777AC4151A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45CBD2070D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfBVSGB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:06:01 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51914 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbfBVSGA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 13:06:00 -0500
Received: by mail-wm1-f65.google.com with SMTP id n19so2760609wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 10:05:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wGyYqYTaWp7jSzh02FXSmxuS07TS71n2orhCthe5OBo=;
        b=bOl4WsEV9na0BsvRNNKvfw6VS0mHKznv7iAH/IYkKKd16f7qdPnZ8m4D0eOmEJtMOD
         AoCwidLXIp50SfE08XmewzHMAbXBdGGNsLa9WbbAnNKYy6gnTweKAPSqAHLV1Kfyh6Jn
         JKJPsheNzY9Xr9Ya+4Re+Z3PyhQLqt7AmuQ/gGqXCKHH/SLmyUKEkuXGxf8xzBAtjLxr
         ngD84tOyw5XbiAaeiix/qi4RtJLc8UA0JOYe7CNti6tbY4LB7XAUE9P3Id/HzXSEAkcL
         Q4Df5R6+FDWpu1t3v/EwWyLl4UB8cmIT997fOk+IWx+Om7KByom1zwcIEqdOSRL8Bcc/
         +bfw==
X-Gm-Message-State: AHQUAuYb6fxN8wwU1r6oSVfSpj5kXsc/8t2fvFvmpfAK8gReNog3e05N
        zBz//cX2IMrp13bixg7R1qjkOtE=
X-Google-Smtp-Source: AHgI3IafQZ8aVw+grzGUxh+qxhn6fKdDBmc5xNTQeetVdxLvJb7CUcHtGdXzugmWYMKkmrKqnVVhfw==
X-Received: by 2002:a1c:a104:: with SMTP id k4mr3229070wme.54.1550858758161;
        Fri, 22 Feb 2019 10:05:58 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c18sm1320678wre.32.2019.02.22.10.05.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 10:05:57 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 10/13] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Fri, 22 Feb 2019 20:05:36 +0200
Message-Id: <20190222180539.27439-11-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190222180539.27439-1-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
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
index 5e66551..15ec637 100644
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

