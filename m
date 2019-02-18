Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D37FC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBDE021479
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfBROzO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:55:14 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36019 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729907AbfBROzO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:55:14 -0500
Received: by mail-wm1-f68.google.com with SMTP id j125so17442264wmj.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:55:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ddAyRPKZEQFhmI/PbM/tQUe91aCAWIcm8aqi3kaSxGQ=;
        b=n+2pKn/3f9iugvdnYQeAooKqSO+qZw5JkQQNAtzm7Eiw1n2AumWzAcQQKBvuJ6p07D
         QVVM6Wt1Wfex/i9aNcLJlZ1i4lHHOUMHMWDzSDZ3+WJ54gQkN6qoD5oHAL8nb5IHTrP4
         GZNKO6DLl6zMHVsy8gVdFdQS9xoFp7FL8EOL4mW4eTCx3rIOhC3fkQ7kmQx5RW9Fxbiz
         nJFKfMVa8XGdaw0LiwTs0QbteWHv7AUzO98JUH7PJqTaCc9z5QhKBgexv/YKZWhveGfr
         jg2oxVGOwpLgIe7ZSf0j+oOiHRaxzHd6xz+zO2okniRaMorS9SxnD5pt8dL+CcEWPgNW
         T77Q==
X-Gm-Message-State: AHQUAuaSf3XBCtBrU7c8p6aMiTxTejicoVeE8lPdMl7Jq599triqSe+e
        6/K5GL1xXgUkaHmMnubRXK/oiLc=
X-Google-Smtp-Source: AHgI3IbBWzSebuzuRN9VwQMefCNUzWReDHYt88N9cK/lrJbNddWHxkaEurWXu9IGNON0k3Nc0tRkSA==
X-Received: by 2002:a1c:4155:: with SMTP id o82mr15606339wma.122.1550501712464;
        Mon, 18 Feb 2019 06:55:12 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id n11sm10172528wrw.60.2019.02.18.06.55.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 06:55:11 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@vmware.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v7 11/13] trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM config
Date:   Mon, 18 Feb 2019 16:54:47 +0200
Message-Id: <20190218145449.13360-12-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190218145449.13360-1-kaslevs@vmware.com>
References: <20190218145449.13360-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch adds a flag for attaching the newly created FIFOs for guest tracing
as virtio serial devices to libvirt managed guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-setup-guest.c | 54 ++++++++++++++++++++++++++++++++++--
 tracecmd/trace-usage.c       |  3 +-
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
index 789dc65..043bca2 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -109,7 +109,45 @@ static int get_guest_cpu_count(const char *guest)
 	return nr_cpus;
 }
 
-static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gid)
+static int attach_guest_fifos(const char *guest, int nr_cpus)
+{
+	const char *cmd_fmt =
+		"virsh attach-device --config '%s' '%s' >/dev/null 2>/dev/null";
+	const char *xml_fmt =
+		"<channel type='pipe'>\n"
+		"  <source path='%s'/>\n"
+		"  <target type='virtio' name='%s%d'/>\n"
+		"</channel>";
+	char tmp_path[PATH_MAX], path[PATH_MAX];
+	char cmd[PATH_MAX], xml[PATH_MAX];
+	int i, fd, ret = 0;
+
+	strcpy(tmp_path, "/tmp/pipexmlXXXXXX");
+	fd = mkstemp(tmp_path);
+	if (fd < 0)
+		return fd;
+
+	for (i = 0; i < nr_cpus; i++) {
+		snprintf(path, sizeof(path), GUEST_FIFO_FMT, guest, i);
+		snprintf(xml, sizeof(xml), xml_fmt, path, GUEST_PIPE_NAME, i);
+		pwrite(fd, xml, strlen(xml), 0);
+
+		snprintf(cmd, sizeof(cmd), cmd_fmt, guest, tmp_path);
+		errno = 0;
+		if (system(cmd) != 0) {
+			ret = -errno;
+			break;
+		}
+	}
+
+	close(fd);
+	unlink(tmp_path);
+
+	return ret;
+}
+
+static void do_setup_guest(const char *guest, int nr_cpus,
+			   mode_t mode, gid_t gid, bool attach)
 {
 	gid_t save_egid;
 	int ret;
@@ -129,6 +167,12 @@ static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gi
 	if (ret < 0)
 		pdie("failed to create FIFOs for %s", guest);
 
+	if (attach) {
+		ret = attach_guest_fifos(guest, nr_cpus);
+		if (ret < 0)
+			pdie("failed to attach FIFOs to %s", guest);
+	}
+
 	if (gid != -1) {
 		ret = setegid(save_egid);
 		if (ret < 0)
@@ -138,6 +182,7 @@ static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gi
 
 void trace_setup_guest(int argc, char **argv)
 {
+	bool attach = false;
 	struct group *group;
 	mode_t mode = 0660;
 	int nr_cpus = -1;
@@ -157,7 +202,7 @@ void trace_setup_guest(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc-1, argv+1, "+hc:p:g:",
+		c = getopt_long(argc-1, argv+1, "+hc:p:g:a",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -177,6 +222,9 @@ void trace_setup_guest(int argc, char **argv)
 				pdie("group %s does not exist", optarg);
 			gid = group->gr_gid;
 			break;
+		case 'a':
+			attach = true;
+			break;
 		default:
 			usage(argv);
 		}
@@ -193,5 +241,5 @@ void trace_setup_guest(int argc, char **argv)
 	if (nr_cpus <= 0)
 		pdie("invalid number of cpus for guest %s", guest);
 
-	do_setup_guest(guest, nr_cpus, mode, gid);
+	do_setup_guest(guest, nr_cpus, mode, gid, attach);
 }
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 9a13d93..bcfd3dc 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -249,10 +249,11 @@ static struct usage_help usage_help[] = {
 	{
 		"setup-guest",
 		"create FIFOs for tracing guest VMs",
-		" %s setup-guest [-c cpus][-p perm][-g group] guest\n"
+		" %s setup-guest [-c cpus][-p perm][-g group][-a] guest\n"
 		"          -c number of guest virtual CPUs\n"
 		"          -p FIFOs permissions (default: 0660)\n"
 		"          -g FIFOs group owner\n"
+		"          -a Attach FIFOs to guest VM config\n"
 	},
 #endif
 	{
-- 
2.19.1

