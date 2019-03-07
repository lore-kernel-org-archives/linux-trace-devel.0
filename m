Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321DAC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 14:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D61B72081B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 14:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="qHoQiRpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbfCGOyT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 09:54:19 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42414 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfCGOyT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 09:54:19 -0500
Received: by mail-qt1-f196.google.com with SMTP id u7so17352240qtg.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 06:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M6HvInDavGe0ag1TbP/XOq2WKRPH7jqDQfs+41no3Mk=;
        b=qHoQiRpEUw+UrgNzwZLgWhhvfZ8AJ4tiw7dYJ+NXiwZJTWzJym9QRY+01LnX0WerQu
         poKG/Bs5dzFw6FPj+tneVCaY4Dztfr/CQqdvg5X6JPDJwroI34T3MVONVhbokuQt8XaT
         ELeydFistbN7rJ1xtRYZXHrTzJnmUxb0irUJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M6HvInDavGe0ag1TbP/XOq2WKRPH7jqDQfs+41no3Mk=;
        b=IKWwbhQYsWWy0o/+0lHjKEu6+LhIXOUIx4d75PtW/3eriG9WW0yP6ZdoKLs21j/+PR
         VLo0xbsuk02By6UR9jdFtrWBuyVJ6dVW3QdKAG6JBMuEVyLpxyngt5BsbO5/yNR2dM3S
         XyNxJXqSXJ/tGxCoocbd9y+p0e0WVP1Qjj0Z0Xx2qgu58q+ZJgCzIhuvY5CiDtsVqv9i
         L4aRPcAawhEH2b7YQLrzK0jBZk59S6ehto4x7ihpmyVC+0zwsimiLi7BUa7E1y90ejK1
         M0bf1hfa6P6ddcnc7Lf1UYeLrQkea82IF49QP3uPHuWR4aHlv0SyDWEAf+cn3FjILWBs
         2ARA==
X-Gm-Message-State: APjAAAUZ78AvTrOauuRsQ3avZRHN3H8LQJ1j9ciMPjBvs++68thZpPmf
        bUMvGLaTHR2OW0xcvbsHRgOD7g==
X-Google-Smtp-Source: APXvYqzikqhBzdCQwkRFWgcuGlS7yjJ9uQ2zdr0KvVf0HnETz4tX0ZkPlSQmaGptQUsoufyQY/Sbpw==
X-Received: by 2002:aed:21c2:: with SMTP id m2mr10982454qtc.107.1551970457345;
        Thu, 07 Mar 2019 06:54:17 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id h8sm3188551qtc.29.2019.03.07.06.54.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Mar 2019 06:54:16 -0800 (PST)
Date:   Thu, 7 Mar 2019 09:54:15 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190307145415.GA258852@google.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <201903030526.3AuYFiuN%fengguang.wu@intel.com>
 <CAJWu+op541tQ_TBJs-kOyRRBYDWiN0Znpb=cUQFxuLg-SmjO_g@mail.gmail.com>
 <CAK7LNARGQE9y6hr7ZoTbn5-GkPBN2Gk-4=3=Cfnr7Oy-+q69kg@mail.gmail.com>
 <20190306174904.GA34256@google.com>
 <CAK7LNARe2AT+LNGh6Xqvd=iW2HmdMcmH-rJqzvPw0Fnumu88SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNARe2AT+LNGh6Xqvd=iW2HmdMcmH-rJqzvPw0Fnumu88SA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 07, 2019 at 01:59:12PM +0900, Masahiro Yamada wrote:
[snip]
> > > [2]
> > >
> > > The shell script keeps running
> > > even when an error occurs.
> > >
> > > If any line in a shell script fails,
> > > probably it went already wrong.
> > >
> > > I highly recommend to add 'set -e'
> > > at the very beginning of your shell script.
> > >
> > > It will propagate the error to Make.
> >
> > Ok I will consider making it -e. But please note that, the script itself does
> > not have any bugs.
> 
> Heh.
> I do not know why you are so confident with your code, though.
> 
> OK, let's say this script has no bug.
> 
> But, the script may fail for a different reason.
> For example, what if cpio is not installed on the user's machine.
> 
> In such a situation, this script will produce empty
> kernel/kheaders_data.tar.xz, but the build system
> will continue running, and succeed.
> 
> Don't you think it will better to let the build immediately fail
> than letting the user debug a wrongly created image ?

Yes, I do think it is better and I am doing that in the next revision
already. It is appended below.

> > > [5]
> > > strip-comments.pl is short enough,
> > > and I do not assume any other user.
> > >
> > >
> > > IMHO, it would be cleaner to embed the one-liner perl
> > > into the shell script, for example, like follows:
> > >
> > > find  $cpio_dir -type f -print0 |
> > >  xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'
> >
> > This does not work. I already tried it. But I guess I could generate the
> > script on the fly.
> 
> 
> I tested my code, and it worked for me.
> 
> perl -e <command_line>
> 
> is useful to run short code directly.
> 

Sorry, previous attempts to use perl -pie didn't work but I tried your one
liner and it does work. Below is the updated patch with this and all the
other nits addressed including the module.lds one.

About module.lds for ia64 architecture, sorry to miss that - I did not test
all architectures, just arm64 and x86 which I have hardware for.
Interestingly kbuild robot didn't catch it either. Anyway it is addressed below.

Thanks a lot for all the great review.

---8<-----------------------

From 22cfd523f14c3b7e13fa05fc1c483a4d368e00d1 Mon Sep 17 00:00:00 2001
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Date: Fri, 18 Jan 2019 15:52:41 -0500
Subject: [PATCH v4.1] Provide in-kernel headers for making it easy to extend the
 kernel

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
(1) external modules must be built on the same arch as the host that
built vmlinux. This can be done either in a qemu emulated chroot on the
target, or natively. This is due to host arch dependency of kernel
scripts.

(2)
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

(3) I have left IKHD_ST and IKHD_ED markers as is to facilitate
future patches that would extract the headers from a kernel or module
image.

Tested-by: qais.yousef@arm.com
Tested-by: dietmar.eggemann@arm.com
Tested-by: linux@manojrajarao.com
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
diff-note-start

    Changes since v4:
    - added module.lds if ia64 otherwise ia64 may fail to build.
    - added clean-files rule to Makefile
    - removed strip-comments script and doing it inline
    - added set -e to header generated to die on errorsr
    - fixed a minor issue where find command was noisy.
    - added Tested-by tags from ARM folks.
    - TODO: several more Masahiro comments.

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
---
 Documentation/dontdiff  |  1 +
 init/Kconfig            | 11 ++++++
 kernel/.gitignore       |  3 ++
 kernel/Makefile         | 36 ++++++++++++++++++
 kernel/kheaders.c       | 72 ++++++++++++++++++++++++++++++++++++
 scripts/gen_ikh_data.sh | 81 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 204 insertions(+)
 create mode 100644 kernel/kheaders.c
 create mode 100755 scripts/gen_ikh_data.sh

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
index 6aa7543bcdb2..2c7f5e9a2e9f 100644
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
+$(obj)/kheaders.o: $(obj)/kheaders_data.h
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
+$(obj)/kheaders_data.h: $(obj)/kheaders_data.tar.xz FORCE
+	$(call filechk,ikheadersxz)
+
+clean-files := kheaders_data.tar.xz kheaders_data.h kheaders.md5
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
index 000000000000..bcd694e9a105
--- /dev/null
+++ b/scripts/gen_ikh_data.sh
@@ -0,0 +1,81 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
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
2.21.0.352.gf09ad66450-goog

