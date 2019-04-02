Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A55C10F0B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC5A82133D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732164AbfDBNp7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:45:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34437 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732153AbfDBNp6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:45:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id p10so16772673wrq.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:45:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pxYwJJ/c4gx2Oqft03DWAiHzqfYE94rfBi9yDVz2OW8=;
        b=EB6/DA6mdbYcC7KpGXUs+fO4djuCXA4NRbTCOtw0SbLFUqF4M3cm6sKarvYNCjVjUr
         a2fAAL1/haFa2PlZpCvhH1oiKBEwe8ahPGy5qI77yZ7efHAK3l95rYQ+TPh4Pmz8M4Gz
         Q3GZcbM9SBmyTqp0eJislRLQGjN2be5WkDQ2bXDogmllgJR3BbTacpsoCv/3EEX6C21S
         vcN8z/Yu6EfyhhXlOTKD72HgFyx/d67QWKYSpgeFmNDslVUCrwm6/W722fSDg/JojQ+l
         0DrU2f7QzOdev9fQ+mX0Q5eLuSb8rF/dpfxoyVvyB8zpysCVjI5tbVHULT80yH2M3OhE
         IV6g==
X-Gm-Message-State: APjAAAWP02dyE/GXvggnhzUHvgxkbpvx5pJuPjKdE4KCLX9ivPa/hvAK
        pGByHnfDAQFNJLHoJT2LHe31Fcvgig==
X-Google-Smtp-Source: APXvYqwwU7wOAbM783mubJxLxeM6i/h2muRFLqRoOA5uTRU8HncMU4g1vbY2qiI6JlhYtsY2iGyZeQ==
X-Received: by 2002:adf:fc0b:: with SMTP id i11mr45933933wrr.145.1554212756716;
        Tue, 02 Apr 2019 06:45:56 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 17sm1765336wmk.39.2019.04.02.06.45.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:45:56 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v9 10/11] trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM config
Date:   Tue,  2 Apr 2019 16:45:39 +0300
Message-Id: <20190402134540.32321-11-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134540.32321-1-kaslevs@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
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
index a55a37d..ae2fecb 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -111,7 +111,45 @@ static int get_guest_cpu_count(const char *guest)
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
@@ -131,6 +169,12 @@ static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gi
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
@@ -140,6 +184,7 @@ static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gi
 
 void trace_setup_guest(int argc, char **argv)
 {
+	bool attach = false;
 	struct group *group;
 	mode_t mode = 0660;
 	int nr_cpus = -1;
@@ -159,7 +204,7 @@ void trace_setup_guest(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc-1, argv+1, "+hc:p:g:",
+		c = getopt_long(argc-1, argv+1, "+hc:p:g:a",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -179,6 +224,9 @@ void trace_setup_guest(int argc, char **argv)
 				pdie("group %s does not exist", optarg);
 			gid = group->gr_gid;
 			break;
+		case 'a':
+			attach = true;
+			break;
 		default:
 			usage(argv);
 		}
@@ -195,5 +243,5 @@ void trace_setup_guest(int argc, char **argv)
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

