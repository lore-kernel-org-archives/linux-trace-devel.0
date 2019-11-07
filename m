Return-Path: <SRS0=IVdt=Y7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE44C5DF61
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Nov 2019 10:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2175A21882
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Nov 2019 10:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbfKGKvO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Nov 2019 05:51:14 -0500
Received: from foss.arm.com ([217.140.110.172]:54068 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfKGKvO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 05:51:14 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB80631B;
        Thu,  7 Nov 2019 02:51:13 -0800 (PST)
Received: from e120877-lin.cambridge.arm.com (unknown [10.1.195.69])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6ABB53F6C4;
        Thu,  7 Nov 2019 02:51:13 -0800 (PST)
From:   vincent.donnefort@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH 1/2] trace-cmd: Enable kptr_restrict
Date:   Thu,  7 Nov 2019 10:51:05 +0000
Message-Id: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

kptr_restrict might prevent trace-cmd from accessing /proc/kallsyms,
leading to a trace without the kernel function names resolved.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 41932ee..3c4f306 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -674,6 +674,39 @@ static int read_event_files(struct tracecmd_output *handle,
 	return ret;
 }
 
+static void set_proc_kptr_restrict(int reset)
+{
+	char *path = "/proc/sys/kernel/kptr_restrict";
+	static char saved = 'X';
+	int fd, ret = -1;
+	char buf;
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
@@ -698,12 +731,16 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
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

