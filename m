Return-Path: <SRS0=aTlZ=RJ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40208C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Mar 2019 12:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3D5020684
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Mar 2019 12:27:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="xWAGuuFX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbfCFM07 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Mar 2019 07:26:59 -0500
Received: from conssluserg-03.nifty.com ([210.131.2.82]:32979 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfCFM06 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Mar 2019 07:26:58 -0500
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id x26CQpg4002356;
        Wed, 6 Mar 2019 21:26:52 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x26CQpg4002356
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1551875212;
        bh=4Xv1H+Zj6i1W+ilWTSvJEfS0gmCIi4GCEjoHtRx3Yt8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xWAGuuFXT1rrYsrsCicokNerJUGqlHlb6XOC7GIvjL2yC//W/qLbzCgiY+WuUdhxR
         RIG705blC05xPHbxAt6Rf8OhkPQFG7WMtEhwFfP9RygDt+417awoBUEkUP0Z9ljJfD
         dBHQmn1NlSyCX3/aN+fGgyXWjVy+5C6mXlJOn/QSMWkfQwG6/GmSYBHGI0GKZW8dfH
         oINrPngu1T4WHoBwlIyPktt3kXF8qJVIjaLjr2ykzYtvEXDZzMbJaFDuWXYxadCIJM
         63lsZ/qVo/nXSxkU87PRlwKVc44qdVqfb8KDrFU0H3q3/thqcN3wQM7r7LCzv0Kzna
         lGiu7j8/y+b6w==
X-Nifty-SrcIP: [209.85.221.171]
Received: by mail-vk1-f171.google.com with SMTP id i68so2761836vke.6;
        Wed, 06 Mar 2019 04:26:51 -0800 (PST)
X-Gm-Message-State: APjAAAVeZ161T9ArYu/eBeFXhZMc9AzzKX40t7R28sOWB3PB1W5d9xLr
        eBAXgP3Zw+h/sgNDJHzqZZn7U3pL0pP1/6pjJGk=
X-Google-Smtp-Source: APXvYqxzOL94o4BToMag0LNlf7SNHkOmde2zwl3rU++3Ssim6ndvo7Zb3ew2c196YSoRiS2pYq6O91IK6yHuul+r3Bo=
X-Received: by 2002:a1f:b754:: with SMTP id h81mr2953428vkf.64.1551875210686;
 Wed, 06 Mar 2019 04:26:50 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <201903030526.3AuYFiuN%fengguang.wu@intel.com> <CAJWu+op541tQ_TBJs-kOyRRBYDWiN0Znpb=cUQFxuLg-SmjO_g@mail.gmail.com>
In-Reply-To: <CAJWu+op541tQ_TBJs-kOyRRBYDWiN0Znpb=cUQFxuLg-SmjO_g@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 6 Mar 2019 21:26:14 +0900
X-Gmail-Original-Message-ID: <CAK7LNARGQE9y6hr7ZoTbn5-GkPBN2Gk-4=3=Cfnr7Oy-+q69kg@mail.gmail.com>
Message-ID: <CAK7LNARGQE9y6hr7ZoTbn5-GkPBN2Gk-4=3=Cfnr7Oy-+q69kg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Joel Fernandes <joelaf@google.com>
Cc:     kbuild test robot <lkp@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 4, 2019 at 1:15 AM Joel Fernandes <joelaf@google.com> wrote:
>
> This report is for an older version of the patch so ignore it. The
> issue is already resolved.
>
> On Sat, Mar 2, 2019 at 2:00 PM kbuild test robot <lkp@intel.com> wrote:
> >
> > Hi Joel,
> >
> > Thank you for the patch! Yet something to improve:
> >
> > [auto build test ERROR on linus/master]
> > [also build test ERROR on v5.0-rc8]
> > [cannot apply to next-20190301]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> >
> > url:    https://github.com/0day-ci/linux/commits/Joel-Fernandes-Google/Provide-in-kernel-headers-for-making-it-easy-to-extend-the-kernel/20190303-014850
> > config: sh-allmodconfig (attached as .config)
> > compiler: sh4-linux-gnu-gcc (Debian 8.2.0-11) 8.2.0
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # save the attached .config to linux build tree
> >         GCC_VERSION=8.2.0 make.cross ARCH=sh
> >
> > All errors (new ones prefixed by >>):
> >
> > >> find: 'arch/sh/kernel/module.lds': No such file or directory
> > >> find: 'arch/sh/kernel/module.lds': No such file or directory
> >
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> >
> > --
> > You received this message because you are subscribed to the Google Groups "kernel-team" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.



Honestly speaking, I am worried about some flaws
in this feature, but anyway I read your code.

Here are just comments from the build system point of view
in case something might be useful.

Please feel free to adopt some of them if you think they are good.

(I do not think you need to re-post a patch just for
adding Reviewed-by/Tested-by tags, but anyway looks like you are
planning to post a new version.)



[1]

Please do not ignore kbuild test robot.

It never makes such a mistake like
replying to a new patch about the test result from old version.

The reports are really addressing this version (v4).

I see the error message even on x86.


[2]

The shell script keeps running
even when an error occurs.

If any line in a shell script fails,
probably it went already wrong.

I highly recommend to add 'set -e'
at the very beginning of your shell script.

It will propagate the error to Make.



[3]

targets += kheaders_data.tar.xz
targets += kheaders_data.h
targets += kheaders.md5

These three lines are unneeded because
'targets' is necessary just for if_changed or if_changed_rule.

Instead, please add

clean-files := kheaders_data.tar.xz kheaders_data.h kheaders.md5


[4]

It is pointless to pass 'ikh_file_list'
from Makefile to the shell script.


You can directly describe the following in gen_ikh_data.sh

You do not need to use sed.


src_file_list="
include/
arch/$SRCARCH/Makefile
arch/$SRCARCH/include/
arch/$SRCARCH/kernel/module.lds
scripts/
Makefile
"

obj_file_list="
scripts/
include/
arch/$SRCARCH/include/
"

if grep -q "^CONFIG_STACK_VALIDATION=y" $KCONFIG_CONFIG; then
        obj_file_list="$obj_file_list tools/objtool/objtool"
fi



Be careful about module.lds
so that it will work for all architectures.




[5]
strip-comments.pl is short enough,
and I do not assume any other user.


IMHO, it would be cleaner to embed the one-liner perl
into the shell script, for example, like follows:

find  $cpio_dir -type f -print0 |
 xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'



[6]
It might be better to move
scripts/gen_ikh_data.sh to kernel/gen_ikh_data.sh

It will make this feature self-contained in kernel/.
And (more importantly to me), it would reduce my maintenance field.



[7]
I do not understand for what 'tarfile_md5' is used.
Is it necessary?



[8]
Is it more efficient to pipe the header files
to perl script like this?


 cat (header) | perl 'do something' > (tmp directory)


Actually, I am not sure if it is more efficient than
stripping comments in-line. I could be wrong...


[9]

I'd prefer avoiding 'pushd && popd' if possible.

Hint: Kbuild already runs at the top directory
of objtree.


It is OK if the change would mess up the script.


[10]

You can embed a binary directly into C file
without producing a giant header file.

I refactored kernel/configs.c
https://lore.kernel.org/patchwork/patch/1042013/

Be careful; my patch has not been merged yet into the mainline.

It has been a while in linux-next,
and I have not received any problem report.

So, I am guessing it will probably be merged
in the current MW.




That's all from me.


-- 
Best Regards
Masahiro Yamada
