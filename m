Return-Path: <SRS0=x7pb=ZF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F530C43331
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Nov 2019 12:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D895206BA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Nov 2019 12:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKMMO3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 07:14:29 -0500
Received: from foss.arm.com ([217.140.110.172]:51454 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfKMMO2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 07:14:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 721467A7;
        Wed, 13 Nov 2019 04:14:28 -0800 (PST)
Received: from e120877-lin.cambridge.arm.com (e120877-lin.cambridge.arm.com [10.1.194.81])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 018203F6C4;
        Wed, 13 Nov 2019 04:14:27 -0800 (PST)
From:   vincent.donnefort@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH v2 1/2] trace-cmd: Enable kptr_restrict
Date:   Wed, 13 Nov 2019 12:14:16 +0000
Message-Id: <1573647257-317361-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20191112140920.6bbed145@gandalf.local.home>
References: <20191112140920.6bbed145@gandalf.local.home>
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

