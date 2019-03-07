Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423DAC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 04:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A8520835
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 04:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="tpugztEe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfCGEzw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Mar 2019 23:55:52 -0500
Received: from conssluserg-05.nifty.com ([210.131.2.90]:22334 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfCGEzw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Mar 2019 23:55:52 -0500
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x274tSK2032053;
        Thu, 7 Mar 2019 13:55:29 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x274tSK2032053
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1551934529;
        bh=PpW95JxYtdXbkqbQPk1bd6lORF0vm9jJx2XfKgLDnqo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tpugztEe1nq7dtPn1N1FCpeE92dIkmohpjUQAt8DhTVp5s4rUA2dER9qm9otL8DG8
         QWvBnmSVzzy75+kbjN8zl3yDngu2ZUhinrdC1E6G87FqHcAQpPpmGPvNIASV+WgfIh
         t6kAx0auiZre2pnSl+ER7tsYblLc4KqwSsZODIGX/rt92JG351KRVQ0tcDktBcp5zH
         dLb5adi4SGacS1zyfXnrA32q5wgXx95tf71lHvb35zRD76tpLeDFBukG183in4liy7
         fAIua0Lm1PgTFj1iqGgPTbxWtauSvPutZDg/K2cXnOmxHwpOD6iByeRlt2heBZVVZ5
         cWs/bcI/NqcOg==
X-Nifty-SrcIP: [209.85.222.42]
Received: by mail-ua1-f42.google.com with SMTP id d4so9786001uap.5;
        Wed, 06 Mar 2019 20:55:29 -0800 (PST)
X-Gm-Message-State: APjAAAWdz51iQ3DOOCM/ggSf00UN6Igne5FJS2LwHXwtu8gDvWig3V/n
        4Aqxrf66YMS2ILx66H2bat/e5QfHVXBlhqu671Y=
X-Google-Smtp-Source: APXvYqw9PPb0RIg2L2+ex+hnNFItuZuyY5MWfWnwi4RQJ60YtE7MiYjPQf1Wsv2u1NXK1saCKpRUdz7tLnMm79mNaTY=
X-Received: by 2002:ab0:c07:: with SMTP id a7mr5861604uak.55.1551934528072;
 Wed, 06 Mar 2019 20:55:28 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <201903030526.3AuYFiuN%fengguang.wu@intel.com> <CAJWu+op541tQ_TBJs-kOyRRBYDWiN0Znpb=cUQFxuLg-SmjO_g@mail.gmail.com>
 <20190306181653.GB34256@google.com>
In-Reply-To: <20190306181653.GB34256@google.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 7 Mar 2019 13:54:51 +0900
X-Gmail-Original-Message-ID: <CAK7LNARA0_C2a8sRCfAr3EV4xF-z5vEq4KkwUcyr7jCKhRpKFg@mail.gmail.com>
Message-ID: <CAK7LNARA0_C2a8sRCfAr3EV4xF-z5vEq4KkwUcyr7jCKhRpKFg@mail.gmail.com>
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

On Thu, Mar 7, 2019 at 5:31 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
>
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
> On Sun, Mar 03, 2019 at 08:11:59AM -0800, Joel Fernandes wrote:
> > This report is for an older version of the patch so ignore it. The
> > issue is already resolved.
> >
>
> Apologies, this issue is real. However it does not cause any failure. It is
> only causing find command to be a bit noisy.
>
> The below diff fixes it and I'll update the patch for v5:



Let's take a look a little bit closer.


$ find  arch  -name module.lds
arch/ia64/module.lds
arch/powerpc/kernel/module.lds
arch/riscv/kernel/module.lds
arch/arm/kernel/module.lds
arch/m68k/kernel/module.lds
arch/arm64/kernel/module.lds



(1) module.lds may not exist for some architectures
(2) module.lds may be located in a different directory (ia64)

Your fix-up missed (2).







> diff --git a/scripts/gen_ikh_data.sh b/scripts/gen_ikh_data.sh
> index 1fa5628fcc30..9a7ea856acbc 100755
> --- a/scripts/gen_ikh_data.sh
> +++ b/scripts/gen_ikh_data.sh
> @@ -1,5 +1,6 @@
>  #!/bin/bash
>  # SPDX-License-Identifier: GPL-2.0
> +set -e
>
>  spath="$(dirname "$(readlink -f "$0")")"
>  kroot="$spath/.."
> @@ -11,12 +12,14 @@ file_list=${@:2}
>
>  src_file_list=""
>  for f in $file_list; do
> +       if [ ! -f "$kroot/$f" ] && [ ! -d "$kroot/$f" ]; then continue; fi
>         src_file_list="$src_file_list $(echo $f | grep -v OBJDIR)"
>  done
>
>  obj_file_list=""
>  for f in $file_list; do
>         f=$(echo $f | grep OBJDIR | sed -e 's/OBJDIR\///g')
> +       if [ ! -f $f ] && [ ! -d $f ]; then continue; fi
>         obj_file_list="$obj_file_list $f";
>  done
>
> --
> 2.21.0.352.gf09ad66450-goog
>

--
Best Regards
Masahiro Yamada
