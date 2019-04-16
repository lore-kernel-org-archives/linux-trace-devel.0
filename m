Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BA5C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 14:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73CE6223FA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 14:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555424569;
	bh=O+vn7j+KiALJmWv3qU2+sb65RbNFlWmoNmJneEGEbJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QPgdSWfrKj91Q2j2n26xnTkA42GZorjwxNYCK5jat7nje+cyuEZ5mlwgBGmvK40Nn
	 k7+UjgCoWcupraTKIQpHWzL9QPpN6G/9T0aglDIrvlm3Y8DUQQTUl/M9WLbhf6PPpb
	 q9gw3Bj/ouhsDBgnzlkwP65HqpeopV1psJ6i0yuw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfDPOWo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 10:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfDPOWo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 10:22:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C638223F9;
        Tue, 16 Apr 2019 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555424562;
        bh=O+vn7j+KiALJmWv3qU2+sb65RbNFlWmoNmJneEGEbJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ILMMSuOB2iYX3Tbs/6W2fD8W+t4uruHvlk1QVwFawihIWny38wHmn4MTHkYjRDpfi
         oGfDugQuvh38UIW6HESuSEDVKjguPBaja+dnb/reIV2Mu1lHIepaHO9rEwVdfLbI3a
         AxulaqysRv/AQZ1euj6z1r4Pfvl16iPTUY11AvCw=
Date:   Tue, 16 Apr 2019 16:22:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Karim Yaghmour <karim.yaghmour@opersys.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Kees Cook <keescook@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
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
Message-ID: <20190416142240.GA31920@kroah.com>
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
User-Agent: Mutt/1.11.4 (2019-03-13)
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

No need to have this be a separate filesystem, we can use a binary sysfs
file in /sys/kernel/ for this as the kernel is not doing any "parsing"
of the data, it is just dumping it out to userspace.

If I make /sys/kernel/config.gz be the same thing as /proc/config.gz
will you fix up 'make localmodconfig' to use it?  :)

thanks,

greg k-h
