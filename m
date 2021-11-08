Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E18C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 16:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C75A6162E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 16:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhKHRCE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 12:02:04 -0500
Received: from linux.microsoft.com ([13.77.154.182]:35466 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbhKHRCE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 12:02:04 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5476920B40A1;
        Mon,  8 Nov 2021 08:59:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5476920B40A1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636390759;
        bh=WVTJvvr3+Aa5VSsagTe6Vvn15jGQuhknNKGRDu2iVEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D6xgmIZ5GWOvrLMTTNigkttYx7AgZIiSAUFl1s07B0zSwUWrqlziSbEsIH84rp1VI
         5jCRkySv1e4VjpQr+tuNFa53M4XPz0b7InvIubkWUnSe2QCNPYgjwG3zEJLig+VhcW
         mkdWWcxBE5HfK1H8hBkhEGoll1re7UcSS8widzjA=
Date:   Mon, 8 Nov 2021 08:59:16 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, rostedt@goodmis.org,
        kbuild-all@lists.01.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211108165916.GA1607@kbox>
References: <20211104170433.2206-3-beaub@linux.microsoft.com>
 <202111050558.mLGUj5jg-lkp@intel.com>
 <20211108113225.664c0594e0ca100e458de92b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108113225.664c0594e0ca100e458de92b@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 08, 2021 at 11:32:25AM +0900, Masami Hiramatsu wrote:
> On Fri, 5 Nov 2021 05:34:31 +0800
> kernel test robot <lkp@intel.com> wrote:
> 
> > Hi Beau,
> > 
> > Thank you for the patch! Yet something to improve:
> > 
> > [auto build test ERROR on rostedt-trace/for-next]
> > [also build test ERROR on shuah-kselftest/next linux/master linus/master v5.15 next-20211104]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Beau-Belgrave/user_events-Enable-user-processes-to-create-and-write-to-trace-events/20211105-010650
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git for-next
> > config: powerpc-allmodconfig (attached as .config)
> > compiler: powerpc-linux-gcc (GCC) 11.2.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/0day-ci/linux/commit/da0961ad45aa1192b47b8a80de6b17437434ae4a
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Beau-Belgrave/user_events-Enable-user-processes-to-create-and-write-to-trace-events/20211105-010650
> >         git checkout da0961ad45aa1192b47b8a80de6b17437434ae4a
> >         # save the attached .config to linux build tree
> >         mkdir build_dir
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash kernel/trace/
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    kernel/trace/trace_events_user.c: In function 'user_event_parse':
> > >> kernel/trace/trace_events_user.c:665:9: error: too few arguments to function 'dyn_event_add'
> >      665 |         dyn_event_add(&user->devent);
> >          |         ^~~~~~~~~~~~~
> >    In file included from kernel/trace/trace_events_user.c:23:
> >    kernel/trace/trace_dynevent.h:79:19: note: declared here
> >       79 | static inline int dyn_event_add(struct dyn_event *ev,
> >          |                   ^~~~~~~~~~~~~
> 
> You need to pass &user->call too :)
> 
> Thank you,
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>

:)

Yep, these so far have been based on perf/core branch of tip, I've moved the
next iteration over to for-next branch off of linux-trace to ensure alignment.

Thanks,
-Beau
