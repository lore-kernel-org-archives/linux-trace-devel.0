Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC41FC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 23:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F3382081B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 23:24:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDfPjtJS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfCGXYI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:24:08 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42229 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfCGXYI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 18:24:08 -0500
Received: by mail-oi1-f194.google.com with SMTP id s16so14407292oih.9;
        Thu, 07 Mar 2019 15:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7VBSHA+WxXPkvH5992iKN87Ve5ZMjfwqdkC0IRGIpAI=;
        b=JDfPjtJS7c5Cf4fiHicFPpwy8VqKuUlNiqU0y0QZ3WZ3LZbU0UQHJqKOuEsjRevVd9
         RZIpdUf0HglWHXmiSDNJx4cGa/RrXIQBq1FQnzZ+A+m9ilKo8/KliHeWRJUWBouoyy2X
         2vW+a+Ny7bU9PrBnh6ahAVrvaxUA9/m4PWs7qu6bR2F6fIe1hL5BPMcSBETdjIRoDEaw
         YC7ydEoWOOO1nPjixPRqnUCDUMYqnNOBDK3ZHz7p1QwHXvvN0Rza2J+UsGJzv/oC+oqZ
         2Hvjeq2j0oIsnAFB07ZnF8P4shPwJs08es2tnrqPwi8tdGEx8D0rVMRyvNLWg0ZKueIU
         zU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7VBSHA+WxXPkvH5992iKN87Ve5ZMjfwqdkC0IRGIpAI=;
        b=U/FiKtE8lE8kjpBpZadmnSJiS5Ynth5DF++0kFIuz7luNm1/5uqRf33WAlZpYh68v1
         aT3Jr135/hztG29LHtiIIIGT7NOV0kdOUDr8VBIS/oICDFvf5Rn5KNg/bvp8hPXzHIgw
         hbqBW1aX6sfjYJYxDNFqlMWUmtnITlzWqvpHpt5M9t/hgdjGF+NHVs9/fepOxf3KBUL6
         rPNDXYx/s2mrWm8AA+eAgsmNt3fAbR8gCRy6/QAUbGnJI/6jNCdKhO4UJRfMG+Pw5dr2
         Oh9Gn9QNi58obuElcCSiuv3h07UANdtnInQ6zvSkjNMf655ABIgcOI/By/E4+nWAAUOX
         M1MQ==
X-Gm-Message-State: APjAAAVpV2Q3Z2PL58h2j4fSBybjFjLOsQrjvjJMbmorPz7qIICmRU50
        nWjqOsHVeIkO2IxIpCJMDOlT2ttAdXtbJgx8sj4=
X-Google-Smtp-Source: APXvYqyaDviuw7AaOm4vDIQljhJAzaSqVlluEefSCC8JIPcACD+kustCRNLQRZyJYWYfTwf44GTjdvpXL1J5j512+OY=
X-Received: by 2002:aca:5e8b:: with SMTP id s133mr6669769oib.2.1552001046561;
 Thu, 07 Mar 2019 15:24:06 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <201903030526.3AuYFiuN%fengguang.wu@intel.com> <CAJWu+op541tQ_TBJs-kOyRRBYDWiN0Znpb=cUQFxuLg-SmjO_g@mail.gmail.com>
 <CAK7LNARGQE9y6hr7ZoTbn5-GkPBN2Gk-4=3=Cfnr7Oy-+q69kg@mail.gmail.com>
In-Reply-To: <CAK7LNARGQE9y6hr7ZoTbn5-GkPBN2Gk-4=3=Cfnr7Oy-+q69kg@mail.gmail.com>
From:   Justin Capella <justincapella@gmail.com>
Date:   Thu, 7 Mar 2019 15:23:54 -0800
Message-ID: <CAMrEMU-SXOmHgxtoMRV+g_uHGBfkQs514RTbEmQDpZo07CvACg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Joel Fernandes <joelaf@google.com>,
        kbuild test robot <lkp@intel.com>,
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

Would you consider this more reliable than the make install_headers,
and am curious about DKMS applications / whether this should be
preferable to the /lib/modules/kernver/biuld symlinks

On Wed, Mar 6, 2019 at 6:48 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Mon, Mar 4, 2019 at 1:15 AM Joel Fernandes <joelaf@google.com> wrote:
> >
> > This report is for an older version of the patch so ignore it. The
> > issue is already resolved.
> >
> > On Sat, Mar 2, 2019 at 2:00 PM kbuild test robot <lkp@intel.com> wrote:
> > >
> > > Hi Joel,
> > >
> > > Thank you for the patch! Yet something to improve:
> > >
> > > [auto build test ERROR on linus/master]
> > > [also build test ERROR on v5.0-rc8]
> > > [cannot apply to next-20190301]
> > > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> > >
> > > url:    https://github.com/0day-ci/linux/commits/Joel-Fernandes-Google/Provide-in-kernel-headers-for-making-it-easy-to-extend-the-kernel/20190303-014850
> > > config: sh-allmodconfig (attached as .config)
> > > compiler: sh4-linux-gnu-gcc (Debian 8.2.0-11) 8.2.0
> > > reproduce:
> > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         # save the attached .config to linux build tree
> > >         GCC_VERSION=8.2.0 make.cross ARCH=sh
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > > >> find: 'arch/sh/kernel/module.lds': No such file or directory
> > > >> find: 'arch/sh/kernel/module.lds': No such file or directory
> > >
> > > ---
> > > 0-DAY kernel test infrastructure                Open Source Technology Center
> > > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> > >
> > > --
> > > You received this message because you are subscribed to the Google Groups "kernel-team" group.
> > > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
>
>
> Honestly speaking, I am worried about some flaws
> in this feature, but anyway I read your code.
>
> Here are just comments from the build system point of view
> in case something might be useful.
>
> Please feel free to adopt some of them if you think they are good.
>
> (I do not think you need to re-post a patch just for
> adding Reviewed-by/Tested-by tags, but anyway looks like you are
> planning to post a new version.)
>
>
>
> [1]
>
> Please do not ignore kbuild test robot.
>
> It never makes such a mistake like
> replying to a new patch about the test result from old version.
>
> The reports are really addressing this version (v4).
>
> I see the error message even on x86.
>
>
> [2]
>
> The shell script keeps running
> even when an error occurs.
>
> If any line in a shell script fails,
> probably it went already wrong.
>
> I highly recommend to add 'set -e'
> at the very beginning of your shell script.
>
> It will propagate the error to Make.
>
>
>
> [3]
>
> targets += kheaders_data.tar.xz
> targets += kheaders_data.h
> targets += kheaders.md5
>
> These three lines are unneeded because
> 'targets' is necessary just for if_changed or if_changed_rule.
>
> Instead, please add
>
> clean-files := kheaders_data.tar.xz kheaders_data.h kheaders.md5
>
>
> [4]
>
> It is pointless to pass 'ikh_file_list'
> from Makefile to the shell script.
>
>
> You can directly describe the following in gen_ikh_data.sh
>
> You do not need to use sed.
>
>
> src_file_list="
> include/
> arch/$SRCARCH/Makefile
> arch/$SRCARCH/include/
> arch/$SRCARCH/kernel/module.lds
> scripts/
> Makefile
> "
>
> obj_file_list="
> scripts/
> include/
> arch/$SRCARCH/include/
> "
>
> if grep -q "^CONFIG_STACK_VALIDATION=y" $KCONFIG_CONFIG; then
>         obj_file_list="$obj_file_list tools/objtool/objtool"
> fi
>
>
>
> Be careful about module.lds
> so that it will work for all architectures.
>
>
>
>
> [5]
> strip-comments.pl is short enough,
> and I do not assume any other user.
>
>
> IMHO, it would be cleaner to embed the one-liner perl
> into the shell script, for example, like follows:
>
> find  $cpio_dir -type f -print0 |
>  xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'
>
>
>
> [6]
> It might be better to move
> scripts/gen_ikh_data.sh to kernel/gen_ikh_data.sh
>
> It will make this feature self-contained in kernel/.
> And (more importantly to me), it would reduce my maintenance field.
>
>
>
> [7]
> I do not understand for what 'tarfile_md5' is used.
> Is it necessary?
>
>
>
> [8]
> Is it more efficient to pipe the header files
> to perl script like this?
>
>
>  cat (header) | perl 'do something' > (tmp directory)
>
>
> Actually, I am not sure if it is more efficient than
> stripping comments in-line. I could be wrong...
>
>
> [9]
>
> I'd prefer avoiding 'pushd && popd' if possible.
>
> Hint: Kbuild already runs at the top directory
> of objtree.
>
>
> It is OK if the change would mess up the script.
>
>
> [10]
>
> You can embed a binary directly into C file
> without producing a giant header file.
>
> I refactored kernel/configs.c
> https://lore.kernel.org/patchwork/patch/1042013/
>
> Be careful; my patch has not been merged yet into the mainline.
>
> It has been a while in linux-next,
> and I have not received any problem report.
>
> So, I am guessing it will probably be merged
> in the current MW.
>
>
>
>
> That's all from me.
>
>
> --
> Best Regards
> Masahiro Yamada
