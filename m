Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24336C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2B5A20811
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfBDG7K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:59:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52832 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfBDG7K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 01:59:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id m1so11917311wml.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 22:59:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lKtnP1A7c1Mnvfk3XOJyOhHm8nmBusLfYbVmELEmxE8=;
        b=igyi05MdUdyxNZkizm9bBtJyBbORQxG8Jt9orJC9N6shFAqsE03qV7GyrV4ClOPxii
         /sEnVeSTBmifm11B2zBu+MAlOBsXPltDssDwOEokta1bUHBoGNPbXjhF3BSgCRrCw//o
         4AL4oVignDRQV+ur6ZYeVZA6NAdFZnHgzqFAnh47AU8oQ6bKgx8ir78qRLHmc0GUmTdt
         q9/zIYUsPVCSfq79xFSjyZhdJBOAjJKxvfbtvRyekytbJk425o7JPvHwN3RlDYSVVwHa
         JWMwqMeJeb9QkPPXQwXiK7bR9ZIugNxCoUitzw3QkM7Z8sJcsczZTmvco93WWhxeutpc
         Wydg==
X-Gm-Message-State: AHQUAualcU5FNmgH7pm/pfsUFIxM31YRT3H+vMKG2ZrUMvaOyF1jtTR4
        KylvMY95E0Ky4576xgkp1DAh6ihsAQ==
X-Google-Smtp-Source: AHgI3IZSS+PHcsx+zXXK2NtxwdKR8qMricUdZI8YLaHCJ8MpvhHyr7YrhoZ4oeqaBtNhYO6XM0GC8g==
X-Received: by 2002:a1c:23cb:: with SMTP id j194mr11259043wmj.91.1549263547689;
        Sun, 03 Feb 2019 22:59:07 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id q12sm12596809wrx.31.2019.02.03.22.59.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:59:07 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [RFC PATCH v5 09/11] trace-cmd: Make setup-guest auto attach FIFOs to the guest VM config
Date:   Mon,  4 Feb 2019 08:58:46 +0200
Message-Id: <20190204065848.8248-10-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204065848.8248-1-kaslevs@vmware.com>
References: <20190204065848.8248-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch tries to attach the newly created FIFOs for guest tracing as virtio
serial devices to libvirt managed guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-setup-guest.c | 41 ++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
index bcd8f40..3176b7e 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -118,6 +118,43 @@ static int get_guest_cpu_count(const char *guest)
 	return nr_cpus;
 }
 
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
+			ret = -1;
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
 static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gid)
 {
 	gid_t save_egid;
@@ -136,6 +173,10 @@ static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gi
 	if (ret < 0)
 		pdie("failed to create FIFOs for %s", guest);
 
+	ret = attach_guest_fifos(guest, nr_cpus);
+	if (ret < 0)
+		warning("failed to attach FIFOs to %s", guest);
+
 	ret = setegid(save_egid);
 	if (ret < 0)
 		pdie("failed to restore effective group ID");
-- 
2.19.1

