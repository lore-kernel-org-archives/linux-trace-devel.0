Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FBEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 02:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB7B61378
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 02:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbhKHCfP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 7 Nov 2021 21:35:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhKHCfN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 7 Nov 2021 21:35:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D42AA61351;
        Mon,  8 Nov 2021 02:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636338749;
        bh=su0Sq15YSjL8ZwZ0+H4mENx5nb1xtOkyE6FZKEdn/1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OHtaWHCVknDE8UkUmQvjbvLFhlZrxdIrUP7ii4wqTz9gnL1dH+Rn0w6wCK7E1/6x/
         Mkx8zpadxnrg3RAxySVKC+lF6i9OkgwFKIbv6A4kKfqL7caAZe87tJ0hoRvc9w4yJM
         JjUmom2EWwys42jYLkPcd304l/2/kTRmkhSkxi2xBLEhCW6JO8Bf3XSZ2jSqQ3Ju0n
         fAi1Ox30InxZMbCN6LVjNX4bkUzbYo7JeNgSudFSHPaP68XbA9DS6tD2UqZfIY0yls
         6cXDQ19QIHOn43rXpnLXPcOKKIkSpi8y0XtyQkd9BMGFbYBMJE8KUtgxdvwu1T1TGv
         rdfhhW+I+Zbww==
Date:   Mon, 8 Nov 2021 11:32:25 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>, rostedt@goodmis.org,
        mhiramat@kernel.org, kbuild-all@lists.01.org,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-Id: <20211108113225.664c0594e0ca100e458de92b@kernel.org>
In-Reply-To: <202111050558.mLGUj5jg-lkp@intel.com>
References: <20211104170433.2206-3-beaub@linux.microsoft.com>
        <202111050558.mLGUj5jg-lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 5 Nov 2021 05:34:31 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Beau,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on rostedt-trace/for-next]
> [also build test ERROR on shuah-kselftest/next linux/master linus/master v5.15 next-20211104]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Beau-Belgrave/user_events-Enable-user-processes-to-create-and-write-to-trace-events/20211105-010650
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git for-next
> config: powerpc-allmodconfig (attached as .config)
> compiler: powerpc-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/da0961ad45aa1192b47b8a80de6b17437434ae4a
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Beau-Belgrave/user_events-Enable-user-processes-to-create-and-write-to-trace-events/20211105-010650
>         git checkout da0961ad45aa1192b47b8a80de6b17437434ae4a
>         # save the attached .config to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash kernel/trace/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    kernel/trace/trace_events_user.c: In function 'user_event_parse':
> >> kernel/trace/trace_events_user.c:665:9: error: too few arguments to function 'dyn_event_add'
>      665 |         dyn_event_add(&user->devent);
>          |         ^~~~~~~~~~~~~
>    In file included from kernel/trace/trace_events_user.c:23:
>    kernel/trace/trace_dynevent.h:79:19: note: declared here
>       79 | static inline int dyn_event_add(struct dyn_event *ev,
>          |                   ^~~~~~~~~~~~~

You need to pass &user->call too :)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
