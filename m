Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF436C48BD6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8654E20656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ji40882G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfFZKwa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:52:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35257 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfFZKwa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:52:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id f15so2207495wrp.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2019 03:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J+ylt+OKjbJrHHMIMjGr3A00GffwZoBUOeiMNg5RitA=;
        b=ji40882GgxNccuej65TjILof7yt+N0JyLhfC47ppitbCWPTqEpFum89qj0EskwvX1g
         WYeuwWosJi5YETJdUffdMvwo4NRj85j7iCzy8d7kjCcW9y8wgTDxFMC2QWDmq/BCTEuy
         dFqcARkdRmKCxJoPGGu0c3dx8/cn3Yg6vTXHDRSv0Kef3pveS6oFh8MfORtGF9gHwZTI
         Z0qZ+pZZ256OeVulmq9YeozBWEvGVgOxf6xRDjBgKLEVDi0PXDO4Lkyf4CseeN5ItEME
         JsJMFAS7Gd+P5fRGhBdAlcazFp5le0dlYH0b5bClq5Cz1oFNNZ87jdRzqLMmZINbIpZ+
         dpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+ylt+OKjbJrHHMIMjGr3A00GffwZoBUOeiMNg5RitA=;
        b=fKhWilVJ+5qFtiw3w+ruH11dlg0DCXp+mQjI3zOlC7lAgpy6ijc4KNCa4MXBWLFLIX
         bL3Vj6/9n8WtkPEMA3kcl2S3bYjJrH3jWhWOXpYVOofwi7XqVEGqtPSqVod4qZE7/lT6
         hIXvsg1318vZte6M1oxx4Vkf/DZgzu+qSxwME1HXyPl6i4AlBOcf6bU+mNa80TwXPUNY
         2FQ2KVD7PVQ9XK5KbmaUcMifM2Qf/AAkHekKTjFi2nCMTxgp3SKtcdVXRnwEG9oaAoJm
         yWM7KIxisq2JzSGtQUeapnZWt8fJpnnz2E/9A9oOjS8WXdhbim4wLzAayQhOmFjbd8UF
         kRvw==
X-Gm-Message-State: APjAAAUX4+uzv8kWRMV33o3Q6Dx42m2DRM/IMmVKDS8ql6pO4HM/I7yx
        50B+ciFTFPydZ/oTuxVQuw==
X-Google-Smtp-Source: APXvYqwZ7hRUWv5Fz1W9AzBTf4YkRiHlMn2jx+Sv/9UpbSWzkvHJpQ3lWxToitvwX0tNm6a57UeJyg==
X-Received: by 2002:a5d:6583:: with SMTP id q3mr3454505wru.184.1561546347847;
        Wed, 26 Jun 2019 03:52:27 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm15456929wrt.49.2019.06.26.03.52.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:52:27 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v13 11/13] trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM config
Date:   Wed, 26 Jun 2019 13:52:07 +0300
Message-Id: <20190626105209.13200-12-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
References: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
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

