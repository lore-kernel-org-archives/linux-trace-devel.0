Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619F5C10F11
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 01:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2461320850
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 01:48:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="26BUWuVZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfDKBsQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 21:48:16 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:55568 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfDKBsQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 21:48:16 -0400
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x3B1m0qu018655;
        Thu, 11 Apr 2019 10:48:01 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x3B1m0qu018655
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1554947281;
        bh=Y46XHKNhY8a5FCXxTFVeV1vpVkwmX9wKuuZ2wsIsUek=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=26BUWuVZZShMtLp2G5sJvtYLVrNGmbDQtlpxB3xu7p/Et4qn8OAx6aAthL+Q4ryuZ
         wsqy0T0Quq4rEsRDS3rmEZeRnLJIIgbRjJFHemvkUwoM4QjSwAaaO4MJTYinin+JVZ
         e27/pzuXKUkaG1Z2LaA2rucVKaWBBPSLU5BMLRaG6bfMVYfnYT5IfhbN4yK41czrL0
         iVYd3KSC4qP2GG8OK1S28znjdYpjyX9G16hUQMCIu36D1nNQlce7N7ah1SiJ8knCr9
         2z/xFnxe326xJyLTM4XW7pwlzq6jLagAkWcvLOHOYV1mnC3wpUfy7kz0rR0CjhI7sC
         rg+6NiFjXqAEA==
X-Nifty-SrcIP: [209.85.217.47]
Received: by mail-vs1-f47.google.com with SMTP id d8so2565311vsp.2;
        Wed, 10 Apr 2019 18:48:00 -0700 (PDT)
X-Gm-Message-State: APjAAAWmmlfVXuG7nUAvv02zC+lNZkTU3hE+aba12/ZLLIzllEv7H0Uw
        trfGak217MiNJuOMRe6ngdQ97lZLOiwKTSaErBo=
X-Google-Smtp-Source: APXvYqxAmxO5pZ2UKNcc9W3OOsNNeaquZgg58ZjVhDW7sBBGGQj2z+h8klcsxFYAMPdQXktq1U7T48L7CqegunhXUlk=
X-Received: by 2002:a67:818e:: with SMTP id c136mr26287981vsd.65.1554947279787;
 Wed, 10 Apr 2019 18:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190408212855.233198-1-joel@joelfernandes.org>
In-Reply-To: <20190408212855.233198-1-joel@joelfernandes.org>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 11 Apr 2019 10:47:23 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQgvhozubW9b2yqnxHAVE17VHHZiq6N4Py_TzFCHN0YUQ@mail.gmail.com>
Message-ID: <CAK7LNAQgvhozubW9b2yqnxHAVE17VHHZiq6N4Py_TzFCHN0YUQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] Provide in-kernel headers to make extending kernel easier
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Joel,

I have no objection to this patch.
I checked though it once again,
please let me point out a little more.

They are all nits.



On Tue, Apr 9, 2019 at 6:37 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> Introduce in-kernel headers which are made available as an archive
> through proc (/proc/kheaders.tar.xz file). This archive makes it
> possible to run eBPF and other tracing programs tracing programs that

Just one "tracing programs" is enough.


> need to extend the kernel for tracing purposes without any dependency on
> the file system having headers.
>
> On Android and embedded systems, it is common to switch kernels but not
> have kernel headers available on the file system. Further once a
> different kernel is booted, any headers stored on the file system will
> no longer be useful. By storing the headers as a compressed archive
> within the kernel, we can avoid these issues that have been a hindrance
> for a long time.
>
> The best way to use this feature is by building it in. Several users
> have a need for this, when they switch debug kernels, they donot want to

'donot' -> 'do not' ?


> update the filesystem or worry about it where to store the headers on
> it. However, the feature is also buildable as a module in case the user
> desires it not being part of the kernel image. This makes it possible to
> load and unload the headers from memory on demand. A tracing program, or
> a kernel module builder can load the module, do its operations, and then
> unload the module to save kernel memory. The total memory needed is 3.8MB.
>
> By having the archive available at a fixed location independent of
> filesystem dependencies and conventions, all debugging tools can
> directly refer to the fixed location for the archive, without concerning
> with where the headers on a typical filesystem which significantly
> simplifies tooling that needs kernel headers.
>
> The code to read the headers is based on /proc/config.gz code and uses
> the same technique to embed the headers.
>
> IKHD_ST and IKHD_ED markers as is to facilitate future patches that
> would extract the headers from a kernel or module image.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

[snip]

>
> diff --git a/init/Kconfig b/init/Kconfig
> index 4592bf7997c0..ea75bfbf7dfa 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -580,6 +580,17 @@ config IKCONFIG_PROC
>           This option enables access to the kernel configuration file
>           through /proc/config.gz.
>
> +config IKHEADERS_PROC
> +       tristate "Enable kernel header artifacts through /proc/kheaders.tar.xz"
> +       depends on PROC_FS
> +       help
> +         This option enables access to the kernel header and other artifacts that

This line is indented by a TAB, which is correct.


> +          are generated during the build process. These can be used to build kernel
> +          modules or by other in-kernel programs such as those generated by eBPF

Now that you have dropped the ability to "build kernel modules",
I'd like you to update this help message.

> +          and systemtap tools. If you build the headers as a module, a module
> +          called kheaders.ko is built which can be loaded on-demand to get access
> +          to the headers.

These lines are indented by 8-spaces instead of one TAB.
Please use TAB-indentation consistently.


[snip]


> +rm -rf $cpio_dir
> +mkdir $cpio_dir
> +
> +pushd $kroot > /dev/null
> +for f in $src_file_list;
> +       do find "$f" ! -name "*.cmd" ! -name ".*";
> +done | cpio --quiet -pd $cpio_dir
> +popd > /dev/null
> +
> +# The second CPIO can complain if files already exist which can
> +# happen with out of tree builds. Just silence CPIO for now.
> +for f in $obj_file_list;
> +       do find "$f" ! -name "*.cmd" ! -name ".*";
> +done | cpio --quiet -pd $cpio_dir >/dev/null 2>&1
> +

Could you add a simple comment about what the following code is doing?
"Remove comments except SPDX" etc.


> +find  $cpio_dir -type f -print0 |

Please replace two spaces after 'find' with one.


> +       xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'
> +
> +tar -Jcf $tarfile -C $cpio_dir/ . > /dev/null
> +
> +echo "$src_files_md5" > kernel/kheaders.md5
> +echo "$obj_files_md5" >> kernel/kheaders.md5
> +echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
> +
> +rm -rf $cpio_dir
> diff --git a/kernel/kheaders.c b/kernel/kheaders.c
> new file mode 100644
> index 000000000000..d072a958a8f1
> --- /dev/null
> +++ b/kernel/kheaders.c
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * kernel/kheaders.c
> + * Provide headers and artifacts needed to build kernel modules.

Ditto. Could you update this comment ?


> + * (Borrowed code from kernel/configs.c)
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/proc_fs.h>
> +#include <linux/init.h>
> +#include <linux/uaccess.h>
> +
> +/*
> + * Define kernel_headers_data and kernel_headers_data_end, within which the the
> + * compressed kernel headers are stpred. The file is first compressed with xz.
> + */
> +
> +asm (
> +"      .pushsection .rodata, \"a\"             \n"
> +"      .global kernel_headers_data             \n"
> +"kernel_headers_data:                          \n"
> +"      .incbin \"kernel/kheaders_data.tar.xz\" \n"
> +"      .global kernel_headers_data_end         \n"
> +"kernel_headers_data_end:                      \n"
> +"      .popsection                             \n"
> +);

You mentioned "IKHD_ST and IKHD_ED markers..." in the commit description,
but I do not see them in the code.

If you plan to work on a tool to extract the headers,
I think it is OK to have the markers here.

Anyway, please make the code and the commit-log consistent.


> +
> +extern char kernel_headers_data;
> +extern char kernel_headers_data_end;
> +
> +static ssize_t
> +ikheaders_read_current(struct file *file, char __user *buf,

Could you stretch this line ?
It will still fit in 80-cols.

(This is a coding style error in kernel/configs.c)



Last thing, when CONFIG_IKHEADERS_PROC=y,
I always see:
  GEN     kernel/kheaders_data.tar.xz

which I think misleading because
the script is just checking the md5sum.



What I like to see is:
  CHK     kernel/kheaders_data.tar.xz
for checking md5sum.

And,
  GEN     kernel/kheaders_data.tar.xz
for really (re-)generating the tarball.


How about this code?

index e3c581d8cde7..12399614c350 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -125,7 +125,7 @@ $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE

 $(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz

-quiet_cmd_genikh = GEN     $(obj)/kheaders_data.tar.xz
+quiet_cmd_genikh = CHK     $(obj)/kheaders_data.tar.xz
 cmd_genikh = $(srctree)/kernel/gen_ikh_data.sh $@
 $(obj)/kheaders_data.tar.xz: FORCE
        $(call cmd,genikh)
diff --git a/kernel/gen_ikh_data.sh b/kernel/gen_ikh_data.sh
index ef72c2740d01..613960e18691 100755
--- a/kernel/gen_ikh_data.sh
+++ b/kernel/gen_ikh_data.sh
@@ -57,6 +57,10 @@ if [ -f kernel/kheaders.md5 ] &&
                exit
 fi

+if [ "${quiet}" != "silent_" ]; then
+       echo "  GEN     $tarfile"
+fi
+
 rm -rf $cpio_dir
 mkdir $cpio_dir


Thanks.

-- 
Best Regards
Masahiro Yamada
