Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B7AC04AB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4196020989
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="qN8XmFJF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfEJVDB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 17:03:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34411 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728008AbfEJVDA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 17:03:00 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so3579730pgt.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 May 2019 14:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8oE2WIx1FMypb1Aghhf1J5CK0/OilbjCc9zGNHOFdrY=;
        b=qN8XmFJFg5CeG6nmVQBnY66XpOcCTdEO7rgJEGlUdYfvFd1rdTD6Hc1QvGQ1xQFgD3
         jr4b1FDKbfY/ead3bXxaplHHnpjColKhiPlaPIQJ8No6u3SRWNeJumjv5vqejgm/8Dr8
         sTVk+VErpT2tq96XJhiGZXfYfkTEbiKn2Rdtc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8oE2WIx1FMypb1Aghhf1J5CK0/OilbjCc9zGNHOFdrY=;
        b=subb0sEv4/xcw6VQhVJHmcyAJcf4OeDTqt0wdpDpRNg9wD3DuQa8ngmtalYGoJSD6U
         RdcfI7ZWEi4ZIM5wv8h8tP6U3mnwTzSwGdfvSz31wy2HEveTMKLpyknlEn+9DYuSuE8R
         WUIl2509iSgPV7a6XKZ9jMsA1bhfxk/tGxVOGTT4XkZPzuEooNR3WyjqZgbEYKyE4aL8
         lDL0X94F2JazbODLeJwssvNNfHzxzO0xRnp/uV1ibC1CZPPVHVemBDIk78aDGGrbdAuu
         WQxBE7FDkuge4NOORoCKQDm6QWCQQNsRvEP1CLFrcx4ZT3YMDGD0CFclrqOYb9bS1p1k
         WQPQ==
X-Gm-Message-State: APjAAAWuJXK9p0r3epVU7huImXFTNlGY7jMNnTRZVQdmSZnE+sqkgpz4
        akld5Wde+8MYBoRnlF//YGyLTg==
X-Google-Smtp-Source: APXvYqxSrzMIb0Y/+XoYVGH5E/Cc0vsqm+l72M1XDf8wH+gWz5Rpbnd4eYcgbpbP8LC12DDrKlYEEQ==
X-Received: by 2002:a62:1ec5:: with SMTP id e188mr17316804pfe.242.1557522179252;
        Fri, 10 May 2019 14:02:59 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id y8sm6523333pgk.20.2019.05.10.14.02.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 10 May 2019 14:02:57 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, atishp04@gmail.com,
        bpf@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, dancol@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, duyuchao <yuchao.du@unisoc.com>,
        gregkh@linuxfoundation.org, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        =?UTF-8?q?Micha=C5=82=20Gregorczyk?= <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>,
        Olof Johansson <olof@lixom.net>, qais.yousef@arm.com,
        rdunlap@infradead.org, Shuah Khan <shuah@kernel.org>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>, yhs@fb.com
Subject: [PATCH 1/3] kheaders: Move from proc to sysfs
Date:   Fri, 10 May 2019 17:02:41 -0400
Message-Id: <20190510210243.152808-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190510210243.152808-1-joel@joelfernandes.org>
References: <20190510210243.152808-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The kheaders archive consisting of the kernel headers used for compiling
bpf programs is in /proc. However there is concern that moving it here
will make it permanent. Let us move it to /sys/kernel as discussed [1].

[1] https://lore.kernel.org/patchwork/patch/1067310/#1265969

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---

Changes to this patch since initial posting:
Fixed sysfs file mode nit (Greg).
Fixed some kconfig nits (Masami).

 init/Kconfig                                | 16 ++++-----
 kernel/Makefile                             |  4 +--
 kernel/{gen_ikh_data.sh => gen_kheaders.sh} |  2 +-
 kernel/kheaders.c                           | 40 +++++++++------------
 4 files changed, 26 insertions(+), 36 deletions(-)
 rename kernel/{gen_ikh_data.sh => gen_kheaders.sh} (98%)

diff --git a/init/Kconfig b/init/Kconfig
index 82b84e5ee30d..ce08adf0f637 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -579,15 +579,13 @@ config IKCONFIG_PROC
 	  This option enables access to the kernel configuration file
 	  through /proc/config.gz.
 
-config IKHEADERS_PROC
-	tristate "Enable kernel header artifacts through /proc/kheaders.tar.xz"
-	depends on PROC_FS
-	help
-	  This option enables access to the kernel header and other artifacts that
-	  are generated during the build process. These can be used to build eBPF
-	  tracing programs, or similar programs.  If you build the headers as a
-	  module, a module called kheaders.ko is built which can be loaded on-demand
-	  to get access to the headers.
+config IKHEADERS
+	tristate "Enable kernel headers through /sys/kernel/kheaders.tar.xz"
+	help
+	  This option enables access to the in-kernel headers that are generated during
+	  the build process. These can be used to build eBPF tracing programs,
+	  or similar programs.  If you build the headers as a module, a module called
+	  kheaders.ko is built which can be loaded on-demand to get access to headers.
 
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
diff --git a/kernel/Makefile b/kernel/Makefile
index 298437bb2c6a..60e3057c780e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -71,7 +71,7 @@ obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
-obj-$(CONFIG_IKHEADERS_PROC) += kheaders.o
+obj-$(CONFIG_IKHEADERS) += kheaders.o
 obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
@@ -127,7 +127,7 @@ $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 $(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz
 
 quiet_cmd_genikh = CHK     $(obj)/kheaders_data.tar.xz
-cmd_genikh = $(srctree)/kernel/gen_ikh_data.sh $@
+cmd_genikh = $(srctree)/kernel/gen_kheaders.sh $@
 $(obj)/kheaders_data.tar.xz: FORCE
 	$(call cmd,genikh)
 
diff --git a/kernel/gen_ikh_data.sh b/kernel/gen_kheaders.sh
similarity index 98%
rename from kernel/gen_ikh_data.sh
rename to kernel/gen_kheaders.sh
index 591a94f7b387..581b83534587 100755
--- a/kernel/gen_ikh_data.sh
+++ b/kernel/gen_kheaders.sh
@@ -2,7 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 # This script generates an archive consisting of kernel headers
-# for CONFIG_IKHEADERS_PROC.
+# for CONFIG_IKHEADERS.
 set -e
 spath="$(dirname "$(readlink -f "$0")")"
 kroot="$spath/.."
diff --git a/kernel/kheaders.c b/kernel/kheaders.c
index 70ae6052920d..8f69772af77b 100644
--- a/kernel/kheaders.c
+++ b/kernel/kheaders.c
@@ -8,9 +8,8 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/proc_fs.h>
+#include <linux/kobject.h>
 #include <linux/init.h>
-#include <linux/uaccess.h>
 
 /*
  * Define kernel_headers_data and kernel_headers_data_end, within which the
@@ -31,39 +30,32 @@ extern char kernel_headers_data;
 extern char kernel_headers_data_end;
 
 static ssize_t
-ikheaders_read_current(struct file *file, char __user *buf,
-		      size_t len, loff_t *offset)
+ikheaders_read(struct file *file,  struct kobject *kobj,
+	       struct bin_attribute *bin_attr,
+	       char *buf, loff_t off, size_t len)
 {
-	return simple_read_from_buffer(buf, len, offset,
-				       &kernel_headers_data,
-				       &kernel_headers_data_end -
-				       &kernel_headers_data);
+	memcpy(buf, &kernel_headers_data + off, len);
+	return len;
 }
 
-static const struct file_operations ikheaders_file_ops = {
-	.read = ikheaders_read_current,
-	.llseek = default_llseek,
+static struct bin_attribute kheaders_attr __ro_after_init = {
+	.attr = {
+		.name = "kheaders.tar.xz",
+		.mode = 0444,
+	},
+	.read = &ikheaders_read,
 };
 
 static int __init ikheaders_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	/* create the current headers file */
-	entry = proc_create("kheaders.tar.xz", S_IRUGO, NULL,
-			    &ikheaders_file_ops);
-	if (!entry)
-		return -ENOMEM;
-
-	proc_set_size(entry,
-		      &kernel_headers_data_end -
-		      &kernel_headers_data);
-	return 0;
+	kheaders_attr.size = (&kernel_headers_data_end -
+			      &kernel_headers_data);
+	return sysfs_create_bin_file(kernel_kobj, &kheaders_attr);
 }
 
 static void __exit ikheaders_cleanup(void)
 {
-	remove_proc_entry("kheaders.tar.xz", NULL);
+	sysfs_remove_bin_file(kernel_kobj, &kheaders_attr);
 }
 
 module_init(ikheaders_init);
-- 
2.21.0.1020.gf2820cf01a-goog
