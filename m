Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088A3C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 12:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCB2D20868
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 12:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555419467;
	bh=rVFCT/7z1dzUEfDYIvNbTwLF1jFDrW1MAhnZvh3Jdeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Q239vQ1ojM5GXq/qtqCaqIGK6MNz8NXasc6W+vwK23fnx/1ChvZAsV8Pj/E+rZudC
	 jnsUAWycn9GJkLi0qyno8ksXGEaz8y6lPRNr29bEq99UBxNyyu0gihO7y5zGR1ITB/
	 r9v2H0xBksVldAl91RNtBotPY70CbO9HP/K6KuFc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfDPM5r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 08:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbfDPM5r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 08:57:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC8D20693;
        Tue, 16 Apr 2019 12:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555419466;
        bh=rVFCT/7z1dzUEfDYIvNbTwLF1jFDrW1MAhnZvh3Jdeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZLyDtCiZ6BkEYojHRFqfEzInZTRtGs37eozEhc8I8nLzYa089ssVXIbH8pwU1B0H
         JOgmy8sCFg+Euy4yxfqVtb0nRPnw0jZ4PN/QqGdoITe07d9MtLTLXaVh2+FbQSiCqh
         i1f3Tf1eD6D+tis/myQY7bzSZFKMymIachlO94HE=
Date:   Tue, 16 Apr 2019 14:49:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Kees Cook <keescook@chromium.org>, Olof Johansson <olof@lixom.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
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
        Karim Yaghmour <karim.yaghmour@opersys.com>,
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
Message-ID: <20190416124939.GB6027@kroah.com>
References: <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com>
 <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
 <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
 <20190415104109.64d914f3@gandalf.local.home>
 <CAGXu5j+KPVRcOJ3Ue9ZQF93GyaDhvCnFCvJ_C3WKCx2=SNdDyg@mail.gmail.com>
 <20190416083306.5646a687@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416083306.5646a687@gandalf.local.home>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 08:33:06AM -0400, Steven Rostedt wrote:
> On Mon, 15 Apr 2019 22:50:10 -0500
> Kees Cook <keescook@chromium.org> wrote:
> 
> > On Mon, Apr 15, 2019 at 9:41 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > I agree with this assessment. We shouldn't use config.gz as precedence
> > > for this solution. config.gz should have been in debugfs to begin with,
> > > but I don't believe debugfs was around when config.gz was introduced.
> > > (Don't have time to look into the history of the two).  
> > 
> > I don't agree with this: /proc/config.gz is used by a lot of tools
> > that do sanity-check of running systems. This isn't _debugging_...
> > it's verifying correct kernel builds. It's a fancy version of checking
> > /proc/version.
> > 
> 
> Then we should perhaps make a new file system call tarballs ;-)
> 
>  /sys/kernel/tarballs/
> 
> and place everything there. That way it removes it from /proc (which is
> the worse place for that) and also makes it something other than debug.
> That's what I did for tracefs.

As horrible as that suggestion is, it does kind of make sense :)

We can't put this in debugfs as that's only for debugging and systems
should never have that mounted for normal operations (users want to
build ebpf programs), and /proc really should be for processes but that
horse is long left the barn.

But, I'm willing to consider putting this either in a system-fs-like
filesystem, or just in sysfs itself, we do have /sys/kernel/ to play
around in if the main objection is that we should not be cluttering up
/proc with stuff like this.

thanks,

greg k-h
