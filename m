Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F81C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 05:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D61E20840
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 05:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="Y9Aqhn0k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbfCGFAK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 00:00:10 -0500
Received: from conssluserg-03.nifty.com ([210.131.2.82]:46146 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfCGFAJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 00:00:09 -0500
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id x274xmsP003673;
        Thu, 7 Mar 2019 13:59:49 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x274xmsP003673
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1551934789;
        bh=EhslO5mW2tJvOiZPDEwlUauDtM5OB51SHkG98AZ1Ay4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y9Aqhn0kQESTTEMWphSBeR0j70mvISayDrniv1RfGZvbIA7YveCIaerXT1H2WtXnq
         6+PICfsyBdid7YRvrKFkk/6mhDixwQIw0Tcj1t5Z64tiITDNBUCK8L7fWW9Up3T1pc
         zcCiNnJRqzjhEM5WVOzuYNpLkMahxAPuEDR7DuObaR5TzVlgrgzPl0DRKcF5pPmVW/
         666amDMmrnSlYEbUgcF2KBmK1uvLhBeDclfhs07v0ovUqoaR+ooFx8rXNwOBw4z9Ri
         Q6eaZsuQ/0ZxmU5rmVoAnuUPM2hdzPst0t4ECOAvNpFIDvM77CYr0kiBeoCxjw25r6
         /1/d6tckRhVmA==
X-Nifty-SrcIP: [209.85.221.172]
Received: by mail-vk1-f172.google.com with SMTP id v131so3410173vkd.3;
        Wed, 06 Mar 2019 20:59:49 -0800 (PST)
X-Gm-Message-State: APjAAAWMIAdbU1NUJZhc/efY+DhffFuWsCOX9guJ3OrhySniSRyonwhA
        E6vUpNX421uRpacE1tgRYHQyNMeMvcf+4kl3erg=
X-Google-Smtp-Source: APXvYqwgVadxJTWQr9yPUtRUxPsGO1lU+FNu08vSz8dcwdIqlMA7cTm7tG99M0hhZBp0tIEQLRVSdCIOKi4UPodoVcY=
X-Received: by 2002:a1f:9350:: with SMTP id v77mr5008152vkd.84.1551934788070;
 Wed, 06 Mar 2019 20:59:48 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <201903030526.3AuYFiuN%fengguang.wu@intel.com> <CAJWu+op541tQ_TBJs-kOyRRBYDWiN0Znpb=cUQFxuLg-SmjO_g@mail.gmail.com>
 <CAK7LNARGQE9y6hr7ZoTbn5-GkPBN2Gk-4=3=Cfnr7Oy-+q69kg@mail.gmail.com> <20190306174904.GA34256@google.com>
In-Reply-To: <20190306174904.GA34256@google.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 7 Mar 2019 13:59:12 +0900
X-Gmail-Original-Message-ID: <CAK7LNARe2AT+LNGh6Xqvd=iW2HmdMcmH-rJqzvPw0Fnumu88SA@mail.gmail.com>
Message-ID: <CAK7LNARe2AT+LNGh6Xqvd=iW2HmdMcmH-rJqzvPw0Fnumu88SA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Joel Fernandes <joel@joelfernandes.org>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 7, 2019 at 5:13 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> Hi Masahiro,
> Thanks for review, my replies are inline:
>
> On Wed, Mar 06, 2019 at 09:26:14PM +0900, Masahiro Yamada wrote:
> > On Mon, Mar 4, 2019 at 1:15 AM Joel Fernandes <joelaf@google.com> wrote:
> > >
> > > This report is for an older version of the patch so ignore it. The
> > > issue is already resolved.
> > >
> > > On Sat, Mar 2, 2019 at 2:00 PM kbuild test robot <lkp@intel.com> wrote:
> > > >
> > > > Hi Joel,
> > > >
> > > > Thank you for the patch! Yet something to improve:
> > > >
> > > > [auto build test ERROR on linus/master]
> > > > [also build test ERROR on v5.0-rc8]
> > > > [cannot apply to next-20190301]
> > > > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> > > >
> > > > url:    https://github.com/0day-ci/linux/commits/Joel-Fernandes-Google/Provide-in-kernel-headers-for-making-it-easy-to-extend-the-kernel/20190303-014850
> > > > config: sh-allmodconfig (attached as .config)
> > > > compiler: sh4-linux-gnu-gcc (Debian 8.2.0-11) 8.2.0
> > > > reproduce:
> > > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > > >         chmod +x ~/bin/make.cross
> > > >         # save the attached .config to linux build tree
> > > >         GCC_VERSION=8.2.0 make.cross ARCH=sh
> > > >
> > > > All errors (new ones prefixed by >>):
> > > >
> > > > >> find: 'arch/sh/kernel/module.lds': No such file or directory
> > > > >> find: 'arch/sh/kernel/module.lds': No such file or directory
> > > >
> > > > ---
> > > > 0-DAY kernel test infrastructure                Open Source Technology Center
> > > > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> > > >
> > > > --
> > > > You received this message because you are subscribed to the Google Groups "kernel-team" group.
> > > > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> >
> >
> >
> > Honestly speaking, I am worried about some flaws
> > in this feature, but anyway I read your code.
>
> I am not sure what you mean by that :-(. All the previous series's comments
> were addressed and it has been well tested by me and others. This looks quite
> solid to me. Sorry it took so many revisions, this was not that easy to get right.
>
> > Here are just comments from the build system point of view
> > in case something might be useful.
> >
> > Please feel free to adopt some of them if you think they are good.
> >> [1]
> >
> > Please do not ignore kbuild test robot.
> >
> > It never makes such a mistake like
> > replying to a new patch about the test result from old version.
> >
> > The reports are really addressing this version (v4).
> >
> > I see the error message even on x86.
>
> I did not mean to. By the way - the error does not cause any issues. It is
> just find being noisy. You are right I missed this, and I will correct this
> in v5. However, it does not cause any issues to the feature/functionality at all.
>
> > [2]
> >
> > The shell script keeps running
> > even when an error occurs.
> >
> > If any line in a shell script fails,
> > probably it went already wrong.
> >
> > I highly recommend to add 'set -e'
> > at the very beginning of your shell script.
> >
> > It will propagate the error to Make.
>
> Ok I will consider making it -e. But please note that, the script itself does
> not have any bugs.

Heh.
I do not know why you are so confident with your code, though.

OK, let's say this script has no bug.

But, the script may fail for a different reason.
For example, what if cpio is not installed on the user's machine.

In such a situation, this script will produce empty
kernel/kheaders_data.tar.xz, but the build system
will continue running, and succeed.

Don't you think it will better to let the build immediately fail
than letting the user debug a wrongly created image ?



> When you say it this way, it looks a bit bad to the
> onlooker as if there is bugs in the code, but there aren't any that I know
> off. All the comments in this round of review from view are just cosmetic
> changes.
>
> > [3]
> >
> > targets += kheaders_data.tar.xz
> > targets += kheaders_data.h
> > targets += kheaders.md5
> >
> > These three lines are unneeded because
> > 'targets' is necessary just for if_changed or if_changed_rule.
> >
> > Instead, please add
> >
> > clean-files := kheaders_data.tar.xz kheaders_data.h kheaders.md5
>
> Ok.
>
> > [4]
> >
> > It is pointless to pass 'ikh_file_list'
> > from Makefile to the shell script.
> >
> >
> > You can directly describe the following in gen_ikh_data.sh
> >
> > You do not need to use sed.
> >
> >
> > src_file_list="
> > include/
> > arch/$SRCARCH/Makefile
> > arch/$SRCARCH/include/
> > arch/$SRCARCH/kernel/module.lds
> > scripts/
> > Makefile
> > "
> >
> > obj_file_list="
> > scripts/
> > include/
> > arch/$SRCARCH/include/
> > "
>
> Honestly, I prefer to keep it in Makefile.
>
> > if grep -q "^CONFIG_STACK_VALIDATION=y" $KCONFIG_CONFIG; then
> >         obj_file_list="$obj_file_list tools/objtool/objtool"
> > fi
> >
> >
> >
> > Be careful about module.lds
> > so that it will work for all architectures.
>
> Yes.
>
> > [5]
> > strip-comments.pl is short enough,
> > and I do not assume any other user.
> >
> >
> > IMHO, it would be cleaner to embed the one-liner perl
> > into the shell script, for example, like follows:
> >
> > find  $cpio_dir -type f -print0 |
> >  xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'
>
> This does not work. I already tried it. But I guess I could generate the
> script on the fly.


I tested my code, and it worked for me.

perl -e <command_line>

is useful to run short code directly.

I do not know why you say it does not work.



Masahiro


> > [6]
> > It might be better to move
> > scripts/gen_ikh_data.sh to kernel/gen_ikh_data.sh
> >
> > It will make this feature self-contained in kernel/.
> > And (more importantly to me), it would reduce my maintenance field.
>
> Sure.
>
> > [7]
> > I do not understand for what 'tarfile_md5' is used.
> > Is it necessary?
>
> It is just precaution, incase tar got corrupted and needs to be regenerated.
>
> > [8]
> > Is it more efficient to pipe the header files
> > to perl script like this?
> >
> >
> >  cat (header) | perl 'do something' > (tmp directory)
>
> I don't think so.
>
> > [9]
> >
> > I'd prefer avoiding 'pushd && popd' if possible.
> >
> > Hint: Kbuild already runs at the top directory
> > of objtree.
> >
> >
> > It is OK if the change would mess up the script.
>
> This is needed to make out of tree builds work.
>
> > [10]
> >
> > You can embed a binary directly into C file
> > without producing a giant header file.
> >
> > I refactored kernel/configs.c
> > https://lore.kernel.org/patchwork/patch/1042013/
> >
> > Be careful; my patch has not been merged yet into the mainline.
> >
> > It has been a while in linux-next,
> > and I have not received any problem report.
> >
> > So, I am guessing it will probably be merged
> > in the current MW.
>
> Ok I will consider doing this.
>
> Thanks for the review!
>
>  - Joel
>
