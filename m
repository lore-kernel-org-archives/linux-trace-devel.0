Return-Path: <SRS0=0SC1=RX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB16C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 16:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9EE521873
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Mar 2019 16:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="QRcm4tP+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfCTQbu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:31:50 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45413 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfCTQbt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 12:31:49 -0400
Received: by mail-qt1-f195.google.com with SMTP id v20so3204669qtv.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Mar 2019 09:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LbC4O+lqsCgqEq+cPcOZJmN4kXYnAdUN6w0nHgZSrF0=;
        b=QRcm4tP+z+O8Hh+KcSigDNkPVvUF8aJU4UbkUTeMAN+vO9r39r4Yt793IH3t9xNfYA
         AR0oORjVIlvFBhKnGidzfFkzn8ErIm+DHwtmmksorbZRxjR/GnMkQHoAY4ZdBG+jCjQf
         aZ/NzIBwUq3lYtZIEYYEcr7U9uPcGy2AKYWr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LbC4O+lqsCgqEq+cPcOZJmN4kXYnAdUN6w0nHgZSrF0=;
        b=SLTrBTPE9z5w9CjTbBlmVSm2VAQpIDD8Bso5oag5YHz/wHO8hXYC0Cka47fn1y8Z1W
         5RkhT0qvOsWQTSqDK+6FvhfqC4H9eRB7cvAeFrfzX4M9vReKr1tWMJDUXT3hBmmDUW0t
         2PzzEbRPcJetRPOFVdunCG7hqA1LgTfz7QBgqS11eiN9npeV0pqjsbY/2iEN25mrH8zK
         gw7pDuye0r5Q8IMg4Idp7XOy5S3S9fOxcPTStQclfYoTIgj8J7epSDHrdc6VTvnFeruy
         vI7A8hplwR1dlLHU/foc/AVXfCsxBkh7Fr8ctYuV4IDgqO29qpFML5nml0mTL799USNA
         gB9g==
X-Gm-Message-State: APjAAAXm4O0KOzZnVlmqO7m0UjPVZTDw2sYUR+3/9ZoLUqYNXNaEjFJp
        f8lS/Nb2CepcxyeXbdtRblT4ng==
X-Google-Smtp-Source: APXvYqywMhN1qagBxSizuYR5RnwQbK+5kQ0kuU3fztS+JcvCx0NS4osWeEfm9elb7SaLV0MIoKLvIg==
X-Received: by 2002:aed:3b14:: with SMTP id p20mr7844127qte.240.1553099507884;
        Wed, 20 Mar 2019 09:31:47 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id h10sm2289721qta.3.2019.03.20.09.31.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Mar 2019 09:31:46 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        qais.yousef@arm.com, dietmar.eggemann@arm.com,
        linux@manojrajarao.com, Andrew Morton <akpm@linux-foundation.org>,
        ast@kernel.org, atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        gregkh@linuxfoundation.org, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
Date:   Wed, 20 Mar 2019 12:31:14 -0400
Message-Id: <20190320163116.39275-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
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

To build a module, the below steps have been tested on an x86 machine:
modprobe kheaders
rm -rf $HOME/headers
mkdir -p $HOME/headers
tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
cd my-kernel-module
make -C $HOME/headers M=$(pwd) modules
rmmod kheaders

Additional notes:
(1) external modules must be built on the same arch as the host that
built vmlinux. This can be done either in a qemu emulated chroot on the
target, or natively. This is due to host arch dependency of kernel
scripts.

(2)
If module building is used, since Module.symvers is not available in the
archive due to a cyclic dependency with building of the archive into the
kernel or module binaries, the modules built using the archive will not
contain symbol versioning (modversion). This is usually not an issue
since the idea of this patch is to build a kernel module on the fly and
load it into the same kernel. An appropriate warning is already printed
by the kernel to alert the user of modules not having modversions when
built using the archive. For building with modversions, the user can use
traditional header packages. For our tracing usecases, we build modules
on the fly with this so it is not a concern.

(3) I have left IKHD_ST and IKHD_ED markers as is to facilitate
future patches that would extract the headers from a kernel or module
image.

(v4 was Tested-by the following folks,
 v5 only has minor changes and has passed my testing).
Tested-by: qais.yousef@arm.com
Tested-by: dietmar.eggemann@arm.com
Tested-by: linux@manojrajarao.com
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---

    v4 -> v5:
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

 init/Kconfig            | 11 ++++++
 kernel/.gitignore       |  1 +
 kernel/Makefile         | 28 ++++++++++++++
 kernel/kheaders.c       | 73 +++++++++++++++++++++++++++++++++++
 scripts/gen_ikh_data.sh | 84 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 197 insertions(+)
 create mode 100644 kernel/kheaders.c
 create mode 100755 scripts/gen_ikh_data.sh

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
index 6c57e78817da..7c486bc25fd7 100644
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
@@ -121,3 +122,30 @@ $(obj)/configs.o: $(obj)/config_data.gz
 targets += config_data.gz
 $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 	$(call if_changed,gzip)
+
+# Build a list of in-kernel headers for building kernel modules
+ikh_file_list := include/
+ikh_file_list += arch/$(SRCARCH)/Makefile
+ikh_file_list += arch/$(SRCARCH)/include/
+ikh_file_list += arch/$(SRCARCH)/module.lds
+ikh_file_list += arch/$(SRCARCH)/kernel/module.lds
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
+$(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz
+
+quiet_cmd_genikh = GEN     $(obj)/kheaders_data.tar.xz
+cmd_genikh = $(srctree)/scripts/gen_ikh_data.sh $@ $(ikh_file_list)
+$(obj)/kheaders_data.tar.xz: FORCE
+	$(call cmd,genikh)
+
+clean-files := kheaders_data.tar.xz kheaders.md5
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
diff --git a/scripts/gen_ikh_data.sh b/scripts/gen_ikh_data.sh
new file mode 100755
index 000000000000..3f9cae72c2a4
--- /dev/null
+++ b/scripts/gen_ikh_data.sh
@@ -0,0 +1,84 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This script generates an archive consisting of kernel headers
+# for CONFIG_IKHEADERS_PROC.
+set -e
+
+spath="$(dirname "$(readlink -f "$0")")"
+kroot="$spath/.."
+outdir="$(pwd)"
+tarfile=$1
+cpio_dir=$outdir/$tarfile.tmp
+
+file_list=${@:2}
+
+src_file_list=""
+for f in $file_list; do
+	if [ ! -f "$kroot/$f" ] && [ ! -d "$kroot/$f" ]; then continue; fi
+	src_file_list="$src_file_list $(echo $f | grep -v OBJDIR)"
+done
+
+obj_file_list=""
+for f in $file_list; do
+	f=$(echo $f | grep OBJDIR | sed -e 's/OBJDIR\///g')
+	if [ ! -f $f ] && [ ! -d $f ]; then continue; fi
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
+	xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'
+
+tar -Jcf $tarfile -C $cpio_dir/ . > /dev/null
+
+echo "$src_files_md5" > kernel/kheaders.md5
+echo "$obj_files_md5" >> kernel/kheaders.md5
+echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
+
+rm -rf $cpio_dir
-- 
2.21.0.225.g810b269d1ac-goog
