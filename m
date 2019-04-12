Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F7AC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 18:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8502C218A3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 18:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="FHWlcCqj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfDLSAS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 14:00:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38049 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfDLSAS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 14:00:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id d13so12265701qth.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 11:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pcqEvnfiSYPkT/mj7bYus8CJmyilyNSuU0D2x0yO75Y=;
        b=FHWlcCqjkx1QGkTeyPOOJvRBX277d2n6NiEapTXFS5ehs7Bc/+GGq27qABbgBrZIah
         Ae3tOaeemVMthzPtDxCG5RUxqnZROfRbqQu3uYzdGhBjMsYzsEZo4UMWrLK9MTveOnsv
         8kre+LGO0hynfw7xvy1/bH9yqURl3RBfQnUjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pcqEvnfiSYPkT/mj7bYus8CJmyilyNSuU0D2x0yO75Y=;
        b=arn3CcKyRbWE9p88ZFdnD5lFMyKksYF5EgilbjKNnZCsckWaCvCGV+XLrlqbd2iVH5
         O6zHaATVyfsC4oj80wC+VoVxoVk8+KdgsoS+VJCAr/hzBidHczfjZxmOuyLjp5BQmrYT
         fA4W46voDIK0MPncyG1+gdKilq8G13hDFCBtdAtMo1HeHflFZPpXNmU0hO/4hrY9BNYG
         UdiHXhLfTNEG7ZR1QWdOiIqqrm8Wf+VRr1cbXwsNbaYSUsPTbhbsZYceMI1Z0fAMJvWB
         e4/j1e4WPpM/nNe94hda/5Nc8PBl5z6gMu8sOGogBox/TvBuOiI/qlgt0xlMIj9xpCeT
         y8Fw==
X-Gm-Message-State: APjAAAX7Eje+IVqHb0Md2Husc//89j+5i69e6qrHONozSCdWUUFUlnSz
        I3dNmMW33KmhO4I943PbRzJ2RQ==
X-Google-Smtp-Source: APXvYqydqFZmR6hrK7qqkBX83Bv9OLNpFZnY2icv9kkAEvdYaSYBrPqYWJaW34PUJX/gh7iexJs7qQ==
X-Received: by 2002:aed:3eea:: with SMTP id o39mr47382421qtf.25.1555092016785;
        Fri, 12 Apr 2019 11:00:16 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id n201sm23711917qka.10.2019.04.12.11.00.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 11:00:15 -0700 (PDT)
Date:   Fri, 12 Apr 2019 14:00:14 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
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
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v6 1/2] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190412180014.GA175945@google.com>
References: <20190408212855.233198-1-joel@joelfernandes.org>
 <CAK7LNAQgvhozubW9b2yqnxHAVE17VHHZiq6N4Py_TzFCHN0YUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQgvhozubW9b2yqnxHAVE17VHHZiq6N4Py_TzFCHN0YUQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 11, 2019 at 10:47:23AM +0900, Masahiro Yamada wrote:
> Hi Joel,
> 
> I have no objection to this patch.
> I checked though it once again,
> please let me point out a little more.
> 
> They are all nits.
> 
> 
> 
> On Tue, Apr 9, 2019 at 6:37 AM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
> >
> > Introduce in-kernel headers which are made available as an archive
> > through proc (/proc/kheaders.tar.xz file). This archive makes it
> > possible to run eBPF and other tracing programs tracing programs that
> 
> Just one "tracing programs" is enough.

fixed.

> > need to extend the kernel for tracing purposes without any dependency on
> > the file system having headers.
> >
> > On Android and embedded systems, it is common to switch kernels but not
> > have kernel headers available on the file system. Further once a
> > different kernel is booted, any headers stored on the file system will
> > no longer be useful. By storing the headers as a compressed archive
> > within the kernel, we can avoid these issues that have been a hindrance
> > for a long time.
> >
> > The best way to use this feature is by building it in. Several users
> > have a need for this, when they switch debug kernels, they donot want to
> 
> 'donot' -> 'do not' ?

fixed

[snip]
> >
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 4592bf7997c0..ea75bfbf7dfa 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -580,6 +580,17 @@ config IKCONFIG_PROC
> >           This option enables access to the kernel configuration file
> >           through /proc/config.gz.
> >
> > +config IKHEADERS_PROC
> > +       tristate "Enable kernel header artifacts through /proc/kheaders.tar.xz"
> > +       depends on PROC_FS
> > +       help
> > +         This option enables access to the kernel header and other artifacts that
> 
> This line is indented by a TAB, which is correct.
> 
> 
> > +          are generated during the build process. These can be used to build kernel
> > +          modules or by other in-kernel programs such as those generated by eBPF
> 
> Now that you have dropped the ability to "build kernel modules",
> I'd like you to update this help message.

Sorry, will fix.

> > +          and systemtap tools. If you build the headers as a module, a module
> > +          called kheaders.ko is built which can be loaded on-demand to get access
> > +          to the headers.
> 
> These lines are indented by 8-spaces instead of one TAB.
> Please use TAB-indentation consistently.
> 
> 
> [snip]
> 
> 
> > +rm -rf $cpio_dir
> > +mkdir $cpio_dir
> > +
> > +pushd $kroot > /dev/null
> > +for f in $src_file_list;
> > +       do find "$f" ! -name "*.cmd" ! -name ".*";
> > +done | cpio --quiet -pd $cpio_dir
> > +popd > /dev/null
> > +
> > +# The second CPIO can complain if files already exist which can
> > +# happen with out of tree builds. Just silence CPIO for now.
> > +for f in $obj_file_list;
> > +       do find "$f" ! -name "*.cmd" ! -name ".*";
> > +done | cpio --quiet -pd $cpio_dir >/dev/null 2>&1
> > +
> 
> Could you add a simple comment about what the following code is doing?
> "Remove comments except SPDX" etc.

Ok.

> > +find  $cpio_dir -type f -print0 |
> 
> Please replace two spaces after 'find' with one.

fixed

> > +       xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'
> > +
> > +tar -Jcf $tarfile -C $cpio_dir/ . > /dev/null
> > +
> > +echo "$src_files_md5" > kernel/kheaders.md5
> > +echo "$obj_files_md5" >> kernel/kheaders.md5
> > +echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
> > +
> > +rm -rf $cpio_dir
> > diff --git a/kernel/kheaders.c b/kernel/kheaders.c
> > new file mode 100644
> > index 000000000000..d072a958a8f1
> > --- /dev/null
> > +++ b/kernel/kheaders.c
> > @@ -0,0 +1,73 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * kernel/kheaders.c
> > + * Provide headers and artifacts needed to build kernel modules.
> 
> Ditto. Could you update this comment ?

fixed.

> > + * (Borrowed code from kernel/configs.c)
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/proc_fs.h>
> > +#include <linux/init.h>
> > +#include <linux/uaccess.h>
> > +
> > +/*
> > + * Define kernel_headers_data and kernel_headers_data_end, within which the the
> > + * compressed kernel headers are stpred. The file is first compressed with xz.
> > + */
> > +
> > +asm (
> > +"      .pushsection .rodata, \"a\"             \n"
> > +"      .global kernel_headers_data             \n"
> > +"kernel_headers_data:                          \n"
> > +"      .incbin \"kernel/kheaders_data.tar.xz\" \n"
> > +"      .global kernel_headers_data_end         \n"
> > +"kernel_headers_data_end:                      \n"
> > +"      .popsection                             \n"
> > +);
> 
> You mentioned "IKHD_ST and IKHD_ED markers..." in the commit description,
> but I do not see them in the code.

fixed

> If you plan to work on a tool to extract the headers,
> I think it is OK to have the markers here.
> 
> Anyway, please make the code and the commit-log consistent.

yes, will do. thanks

> > +extern char kernel_headers_data;
> > +extern char kernel_headers_data_end;
> > +
> > +static ssize_t
> > +ikheaders_read_current(struct file *file, char __user *buf,
> 
> Could you stretch this line ?
> It will still fit in 80-cols.
> 
> (This is a coding style error in kernel/configs.c)

It takes 87 cols if I expand, so I'll leave it as is.

> Last thing, when CONFIG_IKHEADERS_PROC=y,
> I always see:
>   GEN     kernel/kheaders_data.tar.xz
> 
> which I think misleading because
> the script is just checking the md5sum.
> 
> 
> 
> What I like to see is:
>   CHK     kernel/kheaders_data.tar.xz
> for checking md5sum.
> 
> And,
>   GEN     kernel/kheaders_data.tar.xz
> for really (re-)generating the tarball.
> 
> 
> How about this code?

Yes this is better, I changed it to that.

Also looking forward to your tag on the v7 posting if it looks to you now.

thanks a lot for the review!

 - Joel


> index e3c581d8cde7..12399614c350 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -125,7 +125,7 @@ $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
> 
>  $(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz
> 
> -quiet_cmd_genikh = GEN     $(obj)/kheaders_data.tar.xz
> +quiet_cmd_genikh = CHK     $(obj)/kheaders_data.tar.xz
>  cmd_genikh = $(srctree)/kernel/gen_ikh_data.sh $@
>  $(obj)/kheaders_data.tar.xz: FORCE
>         $(call cmd,genikh)
> diff --git a/kernel/gen_ikh_data.sh b/kernel/gen_ikh_data.sh
> index ef72c2740d01..613960e18691 100755
> --- a/kernel/gen_ikh_data.sh
> +++ b/kernel/gen_ikh_data.sh
> @@ -57,6 +57,10 @@ if [ -f kernel/kheaders.md5 ] &&
>                 exit
>  fi
> 
> +if [ "${quiet}" != "silent_" ]; then
> +       echo "  GEN     $tarfile"
> +fi
> +
>  rm -rf $cpio_dir
>  mkdir $cpio_dir
> 
> 
> Thanks.
> 
> -- 
> Best Regards
> Masahiro Yamada
