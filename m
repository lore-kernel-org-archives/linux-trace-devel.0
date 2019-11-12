Return-Path: <SRS0=qtAn=ZE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A651C43331
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 12:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F8A32084E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Nov 2019 12:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfKLMDg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 07:03:36 -0500
Received: from foss.arm.com ([217.140.110.172]:32788 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfKLMDg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 07:03:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9297231B;
        Tue, 12 Nov 2019 04:03:35 -0800 (PST)
Received: from e120877-lin.cambridge.arm.com (e120877-lin.cambridge.arm.com [10.1.194.81])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1B5143F6C4;
        Tue, 12 Nov 2019 04:03:34 -0800 (PST)
From:   vincent.donnefort@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH v2 1/2] trace-cmd: Enable kptr_restrict
Date:   Tue, 12 Nov 2019 12:03:26 +0000
Message-Id: <1573560207-52550-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20191111175203.252cc439@gandalf.local.home>
References: <20191111175203.252cc439@gandalf.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

kptr_restrict might prevent trace-cmd from accessing /proc/kallsyms,
leading to a trace without the kernel function names resolved.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 41932ee..be4d3f5 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -674,6 +674,46 @@ static int read_event_files(struct tracecmd_output *handle,
 	return ret;
 }
 
+#define KPTR_UNINITIALIZED 'X'
+
+static void set_proc_kptr_restrict(int reset)
+{
+	char *path = "/proc/sys/kernel/kptr_restrict";
+	static char saved = KPTR_UNINITIALIZED;
+	int fd, ret = -1;
+	struct stat st;
+	char buf;
+
+	if ((reset && saved == KPTR_UNINITIALIZED) ||
+	    (stat(path, &st) < 0))
+		return;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		goto err;
+
+	if (reset) {
+		buf = saved;
+	} else {
+		if (read(fd, &buf, 1) < 0)
+			goto err;
+		saved = buf;
+		buf = '0';
+	}
+	close(fd);
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		goto err;
+	if (write(fd, &buf, 1) > 0)
+		ret = 0;
+err:
+	if (fd > 0)
+		close(fd);
+	if (ret)
+		warning("can't set kptr_restrict");
+}
+
 static int read_proc_kallsyms(struct tracecmd_output *handle,
 			      const char *kallsyms)
 {
@@ -698,12 +738,16 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 	endian4 = convert_endian_4(handle, size);
 	if (do_write_check(handle, &endian4, 4))
 		return -1;
+
+	set_proc_kptr_restrict(0);
 	check_size = copy_file(handle, path);
 	if (size != check_size) {
 		errno = EINVAL;
 		warning("error in size of file '%s'", path);
+		set_proc_kptr_restrict(1);
 		return -1;
 	}
+	set_proc_kptr_restrict(1);
 
 	return 0;
 }
-- 
2.7.4

