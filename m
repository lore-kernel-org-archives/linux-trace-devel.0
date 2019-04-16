Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1019C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 14:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F9E0223F9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 14:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="lZrx6GQE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfDPOVW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 10:21:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42056 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfDPOVW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 10:21:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id p6so10418569pgh.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Apr 2019 07:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LVdPZJkQVDllMF50IUu8Zl8hYPJEkcJ8Yp+H+NoV2BE=;
        b=lZrx6GQEAmPLDKQ/ogoeRAuiQ8Y4B37jy+lkkRSOqVOiGaCsDn0zoLKmZdvUHhxEoG
         5Nl9Bv4I1Hk2Z07EKKP5fPaR013/+30LeBv9+5Y1IbEad/rFq8xiXdF9KvhDpKpGCqkn
         5yyKY8y6T6ez6mee03RElRXVMRWR5zSaHIp+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LVdPZJkQVDllMF50IUu8Zl8hYPJEkcJ8Yp+H+NoV2BE=;
        b=X18uRWZnHPl8RMax0gSTO7qZ/gr47xqRDiPqCjyNXIj2xYES7GUzexColNEAEVXbaG
         2BgUmWtEYshYWWa2Al4vfNowBBMXcHct+kobSVb006zJ+nHiReQyokHatHniHqWh2u5i
         sKssY3KDAO656M3+PaBcPV/36msZLEVFnoPH+Jr76EbvpyjFUZ9azFfDb1tGjwI3k6Ua
         V95x5/3ol1aVbXPaIGUT26tIeF3YGGKl8NdtR8H5sOUKPEFO7rcg/eRoL8zUQ1WgbAB/
         IHchbiNHBUhuuBWDtEFSnnAqfzg1Oj8lmv0hnGiNqnWaslfakZFGBBlqiGJf1OXvCpVQ
         omvQ==
X-Gm-Message-State: APjAAAXeHwQg5aU7S3FAav3fs4i4bDvDOaWJZf7/Wa8tauMbATJCl6zu
        KkRNn+u531t7BcH8oxtMMXJ6Uw==
X-Google-Smtp-Source: APXvYqxQjjwfNZOEEl8zypiPUyzGoXHuwYCAmTnShfmPuTsZQ3PQdyhi2DOTgc9COsjfRGWijp0cLA==
X-Received: by 2002:a62:ac08:: with SMTP id v8mr81903615pfe.42.1555424480839;
        Tue, 16 Apr 2019 07:21:20 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id h4sm67948873pfo.119.2019.04.16.07.21.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 07:21:17 -0700 (PDT)
Date:   Tue, 16 Apr 2019 10:21:16 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Karim Yaghmour <karim.yaghmour@opersys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190416142116.GA183794@google.com>
References: <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
 <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
 <20190415104109.64d914f3@gandalf.local.home>
 <CAGXu5j+KPVRcOJ3Ue9ZQF93GyaDhvCnFCvJ_C3WKCx2=SNdDyg@mail.gmail.com>
 <20190416083306.5646a687@gandalf.local.home>
 <20190416124939.GB6027@kroah.com>
 <20190416130440.GA7944@localhost>
 <f8b15e31-1aab-ab2c-d44d-47325faab67d@opersys.com>
 <20190416094509.1af6326b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416094509.1af6326b@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 09:45:09AM -0400, Steven Rostedt wrote:
> On Tue, 16 Apr 2019 09:32:37 -0400
> Karim Yaghmour <karim.yaghmour@opersys.com> wrote:
> 
> > >>> Then we should perhaps make a new file system call tarballs ;-)
> > >>>
> > >>>   /sys/kernel/tarballs/
> > >>>
> > >>> and place everything there. That way it removes it from /proc (which is
> > >>> the worse place for that) and also makes it something other than debug.
> > >>> That's what I did for tracefs.  
> > >>
> > >> As horrible as that suggestion is, it does kind of make sense :)
> > >>
> > >> We can't put this in debugfs as that's only for debugging and systems
> > >> should never have that mounted for normal operations (users want to
> > >> build ebpf programs), and /proc really should be for processes but that
> > >> horse is long left the barn.
> > >>
> > >> But, I'm willing to consider putting this either in a system-fs-like
> > >> filesystem, or just in sysfs itself, we do have /sys/kernel/ to play
> > >> around in if the main objection is that we should not be cluttering up
> > >> /proc with stuff like this.
> > >>  
> > > 
> > > I am ok with the suggestion of /sys/kernel for the archive. That also seems
> > > to fit well with the idea that the headers are kernel related and probably
> > > belong here more strictly speaking, than /proc.  
> > 
> > This makes sense. And if it alleviates concerns regarding extending 
> > /proc ABIs then might as well switch to this.
> > 
> > Olof, what do you think of this?
> 
> BTW, the name "tarballs" was kind of a joke. Probably should come up
> with a better name. Although, I'm fine with tarballsfs ;-)

:-)
In theory, the headers could also be hosted in tracefs since the scope of the
patch right now is to help tracing tools (BCC / eBPF). Although /sys/kernel
might be better in case the scope is expanded to other things.

thanks,

 - Joel

