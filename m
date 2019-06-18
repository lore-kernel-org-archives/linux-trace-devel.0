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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9ABAC31E5F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A022621479
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8Fyj5ay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfFROpP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39957 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbfFROpP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so3558896wmj.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J+ylt+OKjbJrHHMIMjGr3A00GffwZoBUOeiMNg5RitA=;
        b=H8Fyj5aynwD9wanpeTaoRD/Fy28/rpk0N3A/kVZ11GQQjKSrW6BcxRlcZTGVLNthDO
         si0g92Iq89ft3qT/Q30hcwuEiTaZchoB3VlTf9qKdSxJW8L1jbqDX1dNpbsdyfm8dAZ3
         54TMHinThPqyucwYRERofw3fOJpGgYhtkHjxZ6pbLp9ysbyeWnttosfJHvRgVGFobDEd
         ZdudsL32K0UC7BeHkM80t++K8/kzoq5iObkmc8znj75HbYoE7r6XcLZ9nC6cnPnczyhX
         t8jNUIeSUQrf1XiAmKEVHIMfWO1fmtB+eZhn7E6N/Tvzyq5TICJRADqBrqDmK+p5Jp7v
         i+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+ylt+OKjbJrHHMIMjGr3A00GffwZoBUOeiMNg5RitA=;
        b=fFbnsrkvSQBI2ogL4POWLYbHnYmr2pMtTAjdQAcgO4RGZsX2a4+A1N9WD6TT2HoQQz
         XCmW7RHaOHHVkQq/YIsde/hUXeu55/wKa1u7lZj8TqoPtkgGa8gcwUM3uwsHeS67iWOc
         yZatrqPGTaGS07OAnctlVq9UPmIud8CMbqRqcuDQ7d6h3KyN1X0arQCAJLpRTGZUEI/e
         iBtPOcJPyij9MhXELWa4pUky26COu3rDMKhJkn+TSiHC90BYBd7FIBRBz3jTcc53wQoa
         OnGhS68e3PKCmoml/YOBQ/KCHKbbwas49wGDR5AhYRNmbRkXY9Rdr1YlKJhVpIobKkEp
         G8RA==
X-Gm-Message-State: APjAAAVM0nX4KdChch4kSS4PJ48nX0YDz7Xen3BxPZ/eMjmei7HXL499
        QKGsbkcIN7wsEiqply2C5Q==
X-Google-Smtp-Source: APXvYqxIi0V4GPRjYdXyEChsYUqJGEXLMnRybSRI7z8mf/NWL33gDm512LvsOllQWkacCTPtk14JPw==
X-Received: by 2002:a1c:618a:: with SMTP id v132mr3945504wmb.17.1560869113375;
        Tue, 18 Jun 2019 07:45:13 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:12 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 11/13] trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM config
Date:   Tue, 18 Jun 2019 17:44:53 +0300
Message-Id: <20190618144455.3954-12-slavomir.kaslev@gmail.com>
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
index a2a520c..ef709cf 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -251,10 +251,11 @@ static struct usage_help usage_help[] = {
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
2.20.1

