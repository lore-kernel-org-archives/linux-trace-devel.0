Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB19C10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 488AC21473
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="Nm9mQTON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfDHV3d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:29:33 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34433 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbfDHV3W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 17:29:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id v12so8030541pgq.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 14:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gl0SlEnL+KJFDIfHk/FSVAiUfxGybfMdWXH9CTtaGZE=;
        b=Nm9mQTONqvyqQ6ojPiQuOD1Izz+wr7i5402ipEUt0oKI0HIV1wiRqSHQkC9ZRmTZ5Y
         32FCIo+2f3aS2qK0NhF9D7DWQS+0WsuHX/uYyRmDu5zS4BMZDNbwGX3fVO7xv8FBJgN/
         veHJjSDGd9vqbDegK8liJU7/zo+Lpv0/i8LzE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gl0SlEnL+KJFDIfHk/FSVAiUfxGybfMdWXH9CTtaGZE=;
        b=KbNRrIrAGsazAMXldVQcqPBeWhriklVR1IX+82LlVEMlk2jbmq1G8GkCGNj2n5g2+g
         UsFWoWBxcVcGVdP25ezQki37Sz200o0bFKQnLeWG2ci3UudxYJHfhglkYYuhIc5J9uYb
         cMZ6+HYv+czW+NrpjqK6sgk50CDTXAYGZncEvmutOpOV3Vyt2vysiAZAEjFHmYZ1fD43
         wifVc47a7z/tohX5hKzaCzza4N1cbGgHd0ECuYyfmRDgkb8POIm0z6+C2DSeX+COSaMk
         Pc8D9QCkDNJ6flncuGmGQBNhzquwfmNkjxS9zVxd1SqjceQ76jed/iifImYLaunLAZLl
         0uvw==
X-Gm-Message-State: APjAAAW6Cod37xhcOJopSDRuJa/PUu716JSejX6QVUoRutXEmashdas3
        lyVM3+RVWlddoDfkKdPCJu7XAg==
X-Google-Smtp-Source: APXvYqymw9XOAvDdEXgSkWoffRXWdESMTcvxaGpcELvBt3Tq0UevGe0uUPGQKbXwtlZQliqxzzQECA==
X-Received: by 2002:a63:d444:: with SMTP id i4mr31344260pgj.149.1554758960525;
        Mon, 08 Apr 2019 14:29:20 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id t12sm68073407pfl.59.2019.04.08.14.29.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 14:29:19 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, gregkh@linuxfoundation.org,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, qais.yousef@arm.com, rdunlap@infradead.org,
        rostedt@goodmis.org, Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: [PATCH v6 1/2] Provide in-kernel headers to make extending kernel easier
Date:   Mon,  8 Apr 2019 17:28:54 -0400
Message-Id: <20190408212855.233198-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce in-kernel headers which are made available as an archive
through proc (/proc/kheaders.tar.xz file). This archive makes it
possible to run eBPF and other tracing programs tracing programs that
need to extend the kernel for tracing purposes without any dependency on
the file system having headers.

On Android and embedded systems, it is common to switch kernels but not
have kernel headers available on the file system. Further once a
different kernel is booted, any headers stored on the file system will
no longer be useful. By storing the headers as a compressed archive
within the kernel, we can avoid these issues that have been a hindrance
for a long time.

The best way to use this feature is by building it in. Several users
have a need for this, when they switch debug kernels, they donot want to
update the filesystem or worry about it where to store the headers on
it. However, the feature is also buildable as a module in case the user
desires it not being part of the kernel image. This makes it possible to
load and unload the headers from memory on demand. A tracing program, or
a kernel module builder can load the module, do its operations, and then
unload the module to save kernel memory. The total memory needed is 3.8MB.

By having the archive available at a fixed location independent of
filesystem dependencies and conventions, all debugging tools can
directly refer to the fixed location for the archive, without concerning
with where the headers on a typical filesystem which significantly
simplifies tooling that needs kernel headers.

The code to read the headers is based on /proc/config.gz code and uses
the same technique to embed the headers.

IKHD_ST and IKHD_ED markers as is to facilitate future patches that
would extract the headers from a kernel or module image.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---

    v5 -> v6: (Masahiro Yamada suggestions mostly)
    - Dropped support for module building.
    - Rebuild archive if script changes.
    - Move archive file list to script.
    - Move build script to kernel directory.

    v4 -> v5:
    (v4 was Tested-by the following folks)
        Tested-by: qais.yousef@arm.com
        Tested-by: dietmar.eggemann@arm.com
        Tested-by: linux@manojrajarao.com
    (Thanks to Masahiro Yamada for several excellent suggestions)
    - used incbin instead of bin2c (Masahiro did similar idea)
    - added module.lds if ia64 otherwise ia64 may fail to build.
    - added clean-files rule to Makefile
    - removed strip-comments script and doing it inline
    - added set -e to header generated to die on errorsr
    - fixed a minor issue where find command was noisy.
    - removed unneeded tar.xz rule from kernel/.gitignore
    - added Tested-by tags from ARM folks.

    Changes since v3:
    - Blank tar was being generated because of a one line I
      forgot to push. It is updated now.
    - Added module.lds since arm64 needs it to build modules.

    Changes since v2:
    (Thanks to Masahiro Yamada for several excellent suggestions)
    - Added support for out of tree builds.
    - Added incremental build support bringing down build time of
      incremental builds from 50 seconds to 5 seconds.
    - Fixed various small nits / cleanups.
    - clean ups to kheaders.c pointed by Alexey Dobriyan.
    - Fixed MODULE_LICENSE in test module and kheaders.c
    - Dropped Module.symvers from archive due to circular dependency.

    Changes since v1:
    - removed IKH_EXTRA variable, not needed (Masahiro Yamada)
    - small fix ups to selftest
       - added target to main Makefile etc
       - added MODULE_LICENSE to test module
       - made selftest more quiet

    Changes since RFC:
    Both changes bring size down to 3.8MB:
    - use xz for compression
    - strip comments except SPDX lines
    - Call out the module name in Kconfig
    - Also added selftests in second patch to ensure headers are always
    working.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

 init/Kconfig           | 11 ++++++
 kernel/.gitignore      |  1 +
 kernel/Makefile        | 10 +++++
 kernel/gen_ikh_data.sh | 84 ++++++++++++++++++++++++++++++++++++++++++
 kernel/kheaders.c      | 73 ++++++++++++++++++++++++++++++++++++
 5 files changed, 179 insertions(+)
 create mode 100755 kernel/gen_ikh_data.sh
 create mode 100644 kernel/kheaders.c

diff --git a/init/Kconfig b/init/Kconfig
index 4592bf7997c0..ea75bfbf7dfa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -580,6 +580,17 @@ config IKCONFIG_PROC
 	  This option enables access to the kernel configuration file
 	  through /proc/config.gz.
 
+config IKHEADERS_PROC
+	tristate "Enable kernel header artifacts through /proc/kheaders.tar.xz"
+	depends on PROC_FS
+	help
+	  This option enables access to the kernel header and other artifacts that
+          are generated during the build process. These can be used to build kernel
+          modules or by other in-kernel programs such as those generated by eBPF
+          and systemtap tools. If you build the headers as a module, a module
+          called kheaders.ko is built which can be loaded on-demand to get access
+          to the headers.
+
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
 	range 12 25
diff --git a/kernel/.gitignore b/kernel/.gitignore
index 6e699100872f..34d1e77ee9df 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -1,5 +1,6 @@
 #
 # Generated files
 #
+kheaders.md5
 timeconst.h
 hz.bc
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c57e78817da..e3c581d8cde7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
+obj-$(CONFIG_IKHEADERS_PROC) += kheaders.o
 obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
@@ -121,3 +122,12 @@ $(obj)/configs.o: $(obj)/config_data.gz
 targets += config_data.gz
 $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 	$(call if_changed,gzip)
+
+$(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz
+
+quiet_cmd_genikh = GEN     $(obj)/kheaders_data.tar.xz
+cmd_genikh = $(srctree)/kernel/gen_ikh_data.sh $@
+$(obj)/kheaders_data.tar.xz: FORCE
+	$(call cmd,genikh)
+
+clean-files := kheaders_data.tar.xz kheaders.md5
diff --git a/kernel/gen_ikh_data.sh b/kernel/gen_ikh_data.sh
new file mode 100755
index 000000000000..ef72c2740d01
--- /dev/null
+++ b/kernel/gen_ikh_data.sh
@@ -0,0 +1,84 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This script generates an archive consisting of kernel headers
+# for CONFIG_IKHEADERS_PROC.
+set -e
+spath="$(dirname "$(readlink -f "$0")")"
+kroot="$spath/.."
+outdir="$(pwd)"
+tarfile=$1
+cpio_dir=$outdir/$tarfile.tmp
+
+# Script filename relative to the kernel source root
+# We add it to the archive because it is small and any changes
+# to this script will also cause a rebuild of the archive.
+sfile="$(realpath --relative-to $kroot "$(readlink -f "$0")")"
+
+src_file_list="
+include/
+arch/$SRCARCH/include/
+$sfile
+"
+
+obj_file_list="
+include/
+arch/$SRCARCH/include/
+"
+
+# Support incremental builds by skipping archive generation
+# if timestamps of files being archived are not changed.
+
+# This block is useful for debugging the incremental builds.
+# Uncomment it for debugging.
+# iter=1
+# if [ ! -f /tmp/iter ]; then echo 1 > /tmp/iter;
+# else; 	iter=$(($(cat /tmp/iter) + 1)); fi
+# find $src_file_list -type f | xargs ls -lR > /tmp/src-ls-$iter
+# find $obj_file_list -type f | xargs ls -lR > /tmp/obj-ls-$iter
+
+# include/generated/compile.h is ignored because it is touched even when none
+# of the source files changed. This causes pointless regeneration, so let us
+# ignore them for md5 calculation.
+pushd $kroot > /dev/null
+src_files_md5="$(find $src_file_list -type f                       |
+		grep -v "include/generated/compile.h"		   |
+		xargs ls -lR | md5sum | cut -d ' ' -f1)"
+popd > /dev/null
+obj_files_md5="$(find $obj_file_list -type f                       |
+		grep -v "include/generated/compile.h"		   |
+		xargs ls -lR | md5sum | cut -d ' ' -f1)"
+
+if [ -f $tarfile ]; then tarfile_md5="$(md5sum $tarfile | cut -d ' ' -f1)"; fi
+if [ -f kernel/kheaders.md5 ] &&
+	[ "$(cat kernel/kheaders.md5|head -1)" == "$src_files_md5" ] &&
+	[ "$(cat kernel/kheaders.md5|head -2|tail -1)" == "$obj_files_md5" ] &&
+	[ "$(cat kernel/kheaders.md5|tail -1)" == "$tarfile_md5" ]; then
+		exit
+fi
+
+rm -rf $cpio_dir
+mkdir $cpio_dir
+
+pushd $kroot > /dev/null
+for f in $src_file_list;
+	do find "$f" ! -name "*.cmd" ! -name ".*";
+done | cpio --quiet -pd $cpio_dir
+popd > /dev/null
+
+# The second CPIO can complain if files already exist which can
+# happen with out of tree builds. Just silence CPIO for now.
+for f in $obj_file_list;
+	do find "$f" ! -name "*.cmd" ! -name ".*";
+done | cpio --quiet -pd $cpio_dir >/dev/null 2>&1
+
+find  $cpio_dir -type f -print0 |
+	xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'
+
+tar -Jcf $tarfile -C $cpio_dir/ . > /dev/null
+
+echo "$src_files_md5" > kernel/kheaders.md5
+echo "$obj_files_md5" >> kernel/kheaders.md5
+echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
+
+rm -rf $cpio_dir
diff --git a/kernel/kheaders.c b/kernel/kheaders.c
new file mode 100644
index 000000000000..d072a958a8f1
--- /dev/null
+++ b/kernel/kheaders.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * kernel/kheaders.c
+ * Provide headers and artifacts needed to build kernel modules.
+ * (Borrowed code from kernel/configs.c)
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+
+/*
+ * Define kernel_headers_data and kernel_headers_data_end, within which the the
+ * compressed kernel headers are stpred. The file is first compressed with xz.
+ */
+
+asm (
+"	.pushsection .rodata, \"a\"		\n"
+"	.global kernel_headers_data		\n"
+"kernel_headers_data:				\n"
+"	.incbin \"kernel/kheaders_data.tar.xz\"	\n"
+"	.global kernel_headers_data_end		\n"
+"kernel_headers_data_end:			\n"
+"	.popsection				\n"
+);
+
+extern char kernel_headers_data;
+extern char kernel_headers_data_end;
+
+static ssize_t
+ikheaders_read_current(struct file *file, char __user *buf,
+		      size_t len, loff_t *offset)
+{
+	return simple_read_from_buffer(buf, len, offset,
+				       &kernel_headers_data,
+				       &kernel_headers_data_end -
+				       &kernel_headers_data);
+}
+
+static const struct file_operations ikheaders_file_ops = {
+	.read = ikheaders_read_current,
+	.llseek = default_llseek,
+};
+
+static int __init ikheaders_init(void)
+{
+	struct proc_dir_entry *entry;
+
+	/* create the current headers file */
+	entry = proc_create("kheaders.tar.xz", S_IRUGO, NULL,
+			    &ikheaders_file_ops);
+	if (!entry)
+		return -ENOMEM;
+
+	proc_set_size(entry,
+		      &kernel_headers_data_end -
+		      &kernel_headers_data);
+	return 0;
+}
+
+static void __exit ikheaders_cleanup(void)
+{
+	remove_proc_entry("kheaders.tar.xz", NULL);
+}
+
+module_init(ikheaders_init);
+module_exit(ikheaders_cleanup);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Joel Fernandes");
+MODULE_DESCRIPTION("Echo the kernel header artifacts used to build the kernel");
-- 
2.21.0.392.gf8f6787159e-goog
