Return-Path: <SRS0=7Tf5=RC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB36C00319
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Feb 2019 19:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A377021850
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Feb 2019 19:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="L54L9hlJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbfB0TiN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 14:38:13 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42597 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbfB0TiM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 14:38:12 -0500
Received: by mail-qt1-f194.google.com with SMTP id u7so11457065qtg.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Feb 2019 11:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qFAKRQ8vClS4s4ySPKi/pIAWQBnHRbTX867MdCXMSL0=;
        b=L54L9hlJn4IfaQ2ltIMcObrIqSGFBItLfoBEO4k26yvzTqhe2NfMC/27N0J52i/CMX
         46XfgQfZXLpOcXV7ujXDczsqOGoMTGfNnC8POAlgxxf5Z4OHAgFW/klXYvr0nuVVg3TC
         yi3+ZNsER28UhLm96DVMtA2UMSJZefyaOEltI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qFAKRQ8vClS4s4ySPKi/pIAWQBnHRbTX867MdCXMSL0=;
        b=gTRBaOuBAqr+1xe0Fi4RHN6ilPWllCykCl6tfv3NZUyO61sGA9nj5nIdHQMjxbnREd
         8S56keAEyUGabIl9nl/goig5GKR3Cno7nohQZMXoBobom7RHEf1/cf+fbFBUsE9pxSPc
         gyppU5WDxkc+ErSkjNf7g8plCK8AMSalu4UMShqgVsRVvhOjfZ1Z0U+I4FD6wqKZ9lB+
         oQNOpIJGHchRQibgw0f0fZaxHJ3G6g2BfbB2zW9LpNMRzY+/5W8ZWwFfIu/7ZN0YgyRh
         5rjENWWKhoaHVYOTSEku9wcq+vFVMEjQG820Rmtqls64Z7kKOfoBKza9VYqU4qhix774
         A/GA==
X-Gm-Message-State: APjAAAXUzJVwjatIbQ6yJJp0Bl5Mg86cwnVy8duu9qN3U34P1p2/j3AB
        Vi2N0WY1hEkpC3UxmNSnJYvH4rFOAB8=
X-Google-Smtp-Source: APXvYqxTGV1ToPrNa8l4g6W4T2H1vsLfWNRP5w+Eburo0VnfO2Wtrrd4YqQY2x1N4QdR52NaWqiOuQ==
X-Received: by 2002:aed:21cb:: with SMTP id m11mr2997316qtc.257.1551296290822;
        Wed, 27 Feb 2019 11:38:10 -0800 (PST)
Received: from joelaf.cam.corp.google.com ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id w8sm16087141qkw.80.2019.02.27.11.38.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 11:38:09 -0800 (PST)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        gregkh@linuxfoundation.org, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        qais.yousef@arm.com, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
Subject: [PATCH v3 1/2] Provide in-kernel headers for making it easy to extend the kernel
Date:   Wed, 27 Feb 2019 14:37:47 -0500
Message-Id: <20190227193748.132301-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.rc2.261.ga7da99ff1b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce in-kernel headers and other artifacts which are made available
as an archive through proc (/proc/kheaders.tar.xz file). This archive makes
it possible to build kernel modules, run eBPF programs, and other
tracing programs that need to extend the kernel for tracing purposes
without any dependency on the file system having headers and build
artifacts.

On Android and embedded systems, it is common to switch kernels but not
have kernel headers available on the file system. Raw kernel headers
also cannot be copied into the filesystem like they can be on other
distros, due to licensing and other issues. There's no linux-headers
package on Android. Further once a different kernel is booted, any
headers stored on the file system will no longer be useful. By storing
the headers as a compressed archive within the kernel, we can avoid these
issues that have been a hindrance for a long time.

The feature is also buildable as a module just in case the user desires
it not being part of the kernel image. This makes it possible to load
and unload the headers on demand. A tracing program, or a kernel module
builder can load the module, do its operations, and then unload the
module to save kernel memory. The total memory needed is 3.8MB.

The code to read the headers is based on /proc/config.gz code and uses
the same technique to embed the headers.

To build a module, the below steps have been tested on an x86 machine:
modprobe kheaders
rm -rf $HOME/headers
mkdir -p $HOME/headers
tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
cd my-kernel-module
make -C $HOME/headers M=$(pwd) modules
rmmod kheaders

Additional notes:
(1)
A limitation of module building with this is, since Module.symvers is
not available in the archive due to a cyclic dependency with building of
the archive into the kernel or module binaries, the modules built using
the archive will not contain symbol versioning (modversion). This is
usually not an issue since the idea of this patch is to build a kernel
module on the fly and load it into the same kernel. An appropriate
warning is already printed by the kernel to alert the user of modules
not having modversions when built using the archive. For building with
modversions, the user can use traditional header packages. For our
tracing usecases, we build modules on the fly with this so it is not a
concern.

(2) I have left IKHD_ST and IKHD_ED markers as is to facilitate
future patches that would extract the headers from a kernel or module
image.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---

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

Other notes:
By the way I still see this error (without the patch) when doing a clean
build: Makefile:594: include/config/auto.conf: No such file or directory

It appears to be because of commit 0a16d2e8cb7e ("kbuild: use 'include'
directive to load auto.conf from top Makefile")

 Documentation/dontdiff    |  1 +
 init/Kconfig              | 11 ++++++
 kernel/.gitignore         |  3 ++
 kernel/Makefile           | 36 +++++++++++++++++++
 kernel/kheaders.c         | 72 +++++++++++++++++++++++++++++++++++++
 scripts/gen_ikh_data.sh   | 76 +++++++++++++++++++++++++++++++++++++++
 scripts/strip-comments.pl |  8 +++++
 7 files changed, 207 insertions(+)
 create mode 100644 kernel/kheaders.c
 create mode 100755 scripts/gen_ikh_data.sh
 create mode 100755 scripts/strip-comments.pl

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 2228fcc8e29f..05a2319ee2a2 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -151,6 +151,7 @@ int8.c
 kallsyms
 kconfig
 keywords.c
+kheaders_data.h*
 ksym.c*
 ksym.h*
 kxgettext
diff --git a/init/Kconfig b/init/Kconfig
index c9386a365eea..63ff0990ae55 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -563,6 +563,17 @@ config IKCONFIG_PROC
 	  This option enables access to the kernel configuration file
 	  through /proc/config.gz.
 
+config IKHEADERS_PROC
+	tristate "Enable kernel header artifacts through /proc/kheaders.tar.xz"
+	select BUILD_BIN2C
+	depends on PROC_FS
+	help
+	  This option enables access to the kernel header and other artifacts that
+          are generated during the build process. These can be used to build kernel
+          modules, and other in-kernel programs such as those generated by eBPF
+          and systemtap tools. If you build the headers as a module, a module
+          called kheaders.ko is built which can be loaded to get access to them.
+
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
 	range 12 25
diff --git a/kernel/.gitignore b/kernel/.gitignore
index b3097bde4e9c..484018945e93 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -3,5 +3,8 @@
 #
 config_data.h
 config_data.gz
+kheaders.md5
+kheaders_data.h
+kheaders_data.tar.xz
 timeconst.h
 hz.bc
diff --git a/kernel/Makefile b/kernel/Makefile
index 6aa7543bcdb2..0bc7cacd7da6 100644
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
@@ -130,3 +131,38 @@ filechk_ikconfiggz = \
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call filechk,ikconfiggz)
+
+# Build a list of in-kernel headers for building kernel modules
+ikh_file_list := include/
+ikh_file_list += arch/$(SRCARCH)/Makefile
+ikh_file_list += arch/$(SRCARCH)/include/
+ikh_file_list += scripts/
+ikh_file_list += Makefile
+
+# Things we need from the $objtree. "OBJDIR" is for the gen_ikh_data.sh
+# script to identify that this comes from the $objtree directory
+ikh_file_list += OBJDIR/scripts/
+ikh_file_list += OBJDIR/include/
+ikh_file_list += OBJDIR/arch/$(SRCARCH)/include/
+ifeq ($(CONFIG_STACK_VALIDATION), y)
+ikh_file_list += OBJDIR/tools/objtool/objtool
+endif
+
+$(obj)/kheaders.o: $(obj)/kheaders_data.h
+
+targets += kheaders_data.tar.xz
+
+quiet_cmd_genikh = GEN     $(obj)/kheaders_data.tar.xz
+cmd_genikh = $(srctree)/scripts/gen_ikh_data.sh $@ $(ikh_file_list)
+$(obj)/kheaders_data.tar.xz: FORCE
+	$(call cmd,genikh)
+
+filechk_ikheadersxz = \
+	echo "static const char kernel_headers_data[] __used = KH_MAGIC_START"; \
+	cat $< | scripts/bin2c; \
+	echo "KH_MAGIC_END;"
+
+targets += kheaders_data.h
+targets += kheaders.md5
+$(obj)/kheaders_data.h: $(obj)/kheaders_data.tar.xz FORCE
+	$(call filechk,ikheadersxz)
diff --git a/kernel/kheaders.c b/kernel/kheaders.c
new file mode 100644
index 000000000000..46a6358301e5
--- /dev/null
+++ b/kernel/kheaders.c
@@ -0,0 +1,72 @@
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
+ * Define kernel_headers_data and kernel_headers_data_size, which contains the
+ * compressed kernel headers.  The file is first compressed with xz and then
+ * bounded by two eight byte magic numbers to allow extraction from a binary
+ * kernel image:
+ *
+ *   IKHD_ST
+ *   <image>
+ *   IKHD_ED
+ */
+#define KH_MAGIC_START	"IKHD_ST"
+#define KH_MAGIC_END	"IKHD_ED"
+#include "kheaders_data.h"
+
+
+#define KH_MAGIC_SIZE (sizeof(KH_MAGIC_START) - 1)
+#define kernel_headers_data_size \
+	(sizeof(kernel_headers_data) - 1 - KH_MAGIC_SIZE * 2)
+
+static ssize_t
+ikheaders_read_current(struct file *file, char __user *buf,
+		      size_t len, loff_t *offset)
+{
+	return simple_read_from_buffer(buf, len, offset,
+				       kernel_headers_data + KH_MAGIC_SIZE,
+				       kernel_headers_data_size);
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
+	proc_set_size(entry, kernel_headers_data_size);
+
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
diff --git a/scripts/gen_ikh_data.sh b/scripts/gen_ikh_data.sh
new file mode 100755
index 000000000000..7329262bed2f
--- /dev/null
+++ b/scripts/gen_ikh_data.sh
@@ -0,0 +1,76 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+spath="$(dirname "$(readlink -f "$0")")"
+kroot="$spath/.."
+outdir="$(pwd)"
+tarfile=$1
+cpio_dir=$outdir/$tarfile.tmp
+
+src_file_list=""
+for f in $file_list; do
+	src_file_list="$src_file_list $(echo $f | grep -v OBJDIR)"
+done
+
+obj_file_list=""
+for f in $file_list; do
+	f=$(echo $f | grep OBJDIR | sed -e 's/OBJDIR\///g')
+	obj_file_list="$obj_file_list $f";
+done
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
+# modules.order and include/generated/compile.h are ignored because these are
+# touched even when none of the source files changed. This causes pointless
+# regeneration, so let us ignore them for md5 calculation.
+pushd $kroot > /dev/null
+src_files_md5="$(find $src_file_list -type f ! -name modules.order |
+		grep -v "include/generated/compile.h"		   |
+		xargs ls -lR | md5sum | cut -d ' ' -f1)"
+popd > /dev/null
+obj_files_md5="$(find $obj_file_list -type f ! -name modules.order |
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
+	do find "$f" ! -name "*.c" ! -name "*.o" ! -name "*.cmd" ! -name ".*";
+done | cpio --quiet -pd $cpio_dir
+popd > /dev/null
+
+# The second CPIO can complain if files already exist which can
+# happen with out of tree builds. Just silence CPIO for now.
+for f in $obj_file_list;
+	do find "$f" ! -name "*.c" ! -name "*.o" ! -name "*.cmd" ! -name ".*";
+done | cpio --quiet -pd $cpio_dir >/dev/null 2>&1
+
+find  $cpio_dir -type f -print0 |
+	xargs -0 -P8 -n1 -I {} sh -c "$spath/strip-comments.pl {}"
+
+tar -Jcf $tarfile -C $cpio_dir/ . > /dev/null
+
+echo "$src_files_md5" > kernel/kheaders.md5
+echo "$obj_files_md5" >> kernel/kheaders.md5
+echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
+
+rm -rf $cpio_dir
diff --git a/scripts/strip-comments.pl b/scripts/strip-comments.pl
new file mode 100755
index 000000000000..f8ada87c5802
--- /dev/null
+++ b/scripts/strip-comments.pl
@@ -0,0 +1,8 @@
+#!/usr/bin/perl -pi
+# SPDX-License-Identifier: GPL-2.0
+
+# This script removes /**/ comments from a file, unless such comments
+# contain "SPDX". It is used when building compressed in-kernel headers.
+
+BEGIN {undef $/;}
+s/\/\*((?!SPDX).)*?\*\///smg;
-- 
2.21.0.rc2.261.ga7da99ff1b-goog
