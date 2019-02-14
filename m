Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D3AC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41AA92080A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404732AbfBNOOF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:14:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39246 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404718AbfBNOOE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:14:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id f16so6241124wmh.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:14:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aXE53MOcOtsZGP1NAEWxJ+PN06aqBljmiF5yHsoLsDM=;
        b=b3ppaVJT6kIjdxUxQTitOOJqzmFdpwik4k4W4GXrmvMi3DQuq9NxxPbZfyc6egk1Ns
         kwB5a5w+SO8VCT3+JuBuGyqs877awWKhzAgUf8wJRbnIvhZlh/NUO/wsinIekwdvLyo5
         NfvG8AeAhgs5m+IZesSuXqpfjMGBQ9oIUaHPSGsZ88V/Jt+EkjTwKe+zJa8RvmSozc2q
         IrVK/EvIub+6zzSoUh5+9m4Xhp/1gTmui5tVxEULlMy7Cysj34wrayEhRNxaM9a2GTxm
         kfjOdICq2bqQKnEVWpgeeCNJ+X1aNY9vv/e1xQZJTGUpSUrXXAhjfxB+hSoI+sAR61+i
         7B3Q==
X-Gm-Message-State: AHQUAuY3SEB53eHjjA4tXLVSH8V3gslBufOm01EC7Dalbo2NOhI8YlLY
        FlosYygQ0zEmqFR6wgqhUg==
X-Google-Smtp-Source: AHgI3IZG9MGAuC6RQwISmdUG7L6pKn4ifthBFPm/99hsVRjh817sclJoEDW/ocHBZjNp6UYoSa1C7g==
X-Received: by 2002:a1c:9acd:: with SMTP id c196mr3037140wme.145.1550153642351;
        Thu, 14 Feb 2019 06:14:02 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id m4sm1844840wml.2.2019.02.14.06.14.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:14:01 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v6 09/11] trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM config
Date:   Thu, 14 Feb 2019 16:13:33 +0200
Message-Id: <20190214141335.28144-10-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214141335.28144-1-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
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
index 7ee6f06..7898c66 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -119,7 +119,45 @@ static int get_guest_cpu_count(const char *guest)
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
@@ -139,6 +177,12 @@ static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gi
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
@@ -148,6 +192,7 @@ static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gi
 
 void trace_setup_guest(int argc, char **argv)
 {
+	bool attach = false;
 	struct group *group;
 	mode_t mode = 0660;
 	int nr_cpus = -1;
@@ -167,7 +212,7 @@ void trace_setup_guest(int argc, char **argv)
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc-1, argv+1, "+hc:p:g:",
+		c = getopt_long(argc-1, argv+1, "+hc:p:g:a",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -187,6 +232,9 @@ void trace_setup_guest(int argc, char **argv)
 				pdie("group %s does not exist", optarg);
 			gid = group->gr_gid;
 			break;
+		case 'a':
+			attach = true;
+			break;
 		default:
 			usage(argv);
 		}
@@ -203,5 +251,5 @@ void trace_setup_guest(int argc, char **argv)
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

