Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E534C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 16:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDE65206B6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 16:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bNr3ipc+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfDPQqs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:46:48 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42658 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfDPQqs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 12:46:48 -0400
Received: by mail-pl1-f193.google.com with SMTP id cv12so10629845plb.9;
        Tue, 16 Apr 2019 09:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tsRRbr6q8xRXitr55R13RaRnWMNI10aBLSKNBEpEchc=;
        b=bNr3ipc+CTaD4tGwxY593FZ31O0Q+j30oQunL6fN8Vg0xCvAYTGAxMwgcM1dx/yFiQ
         oTEP218jHO8Bh/SJrnsLp+RLHMFHpGDZ2sAhk4s5lrnEFd4bEhOdzK9BBEsC00gTv/uK
         f0UPbPgI8yfgcdY2frZaz3Da+5lJrbMl1s9/ipTk2kUPr/2ACbJKu6S591w4v7cVg+/G
         FqmZDUWsBY4E0rsIV81PUtAlklcD/JPtgIDebrWF6VDuxB3L4aJC1JqFoFkS+DeeZpU+
         nbtDmpZqvNOKIE1c0PrkvwxSncnbgoH46Q+rQXjeq8XF8E+m24vWux1IvBhBoDM05yCw
         2DYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tsRRbr6q8xRXitr55R13RaRnWMNI10aBLSKNBEpEchc=;
        b=YPlQop5wzVUcD7iE7ODAT1NX9MlfF8PxLb2YhuGu8yLvxHumLA1ujesF9ri1OcSwXr
         NkAdefbh0tXUfIVK94lpPGsfIoSwyMJEc1wmddzvRPa8Ct2Mb4snaCNIhWEpgCxIbOgP
         wdtAGZPC0UVeExSHjm/cDyiSncEaQTh1bvFTFasYwuNPYoBnAbgaaQIJBXy8SOJjicER
         h9/T1s21XEvXZ8G3XZ0RoULcy1T2c8BHJuVE5SxEYIJ7kpcQGhz9R3d4nRXh1DyyIXJL
         WJ3TSMuHzfFmfokzAYB4Ua/0Jmj3UwaVr8zKTuxdpYDf2iZn3fRIW4fEwZj72UIGrBdZ
         jkDg==
X-Gm-Message-State: APjAAAX5ZgcXOi+8xT0G+PMVz/oUV1/gtV/hm2TnR+aAGO3wwzdsLbkc
        8cdjm9OtjRK+gqOITi4bEx8=
X-Google-Smtp-Source: APXvYqycLPTnCJjorVt5WrPnSxjhN+rl+70wG9AE7X9KBWwv+DIFsTHVGERTLukm36AlWNbl9Fwlmg==
X-Received: by 2002:a17:902:2965:: with SMTP id g92mr66980230plb.267.1555433206864;
        Tue, 16 Apr 2019 09:46:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:601e])
        by smtp.gmail.com with ESMTPSA id x16sm121234803pge.27.2019.04.16.09.46.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 09:46:45 -0700 (PDT)
Date:   Tue, 16 Apr 2019 09:46:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Kees Cook <keescook@chromium.org>,
        Olof Johansson <olof@lixom.net>,
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
Message-ID: <20190416164642.krptlz32zusr4pgn@ast-mbp.dhcp.thefacebook.com>
References: <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
 <20190415104109.64d914f3@gandalf.local.home>
 <CAGXu5j+KPVRcOJ3Ue9ZQF93GyaDhvCnFCvJ_C3WKCx2=SNdDyg@mail.gmail.com>
 <20190416083306.5646a687@gandalf.local.home>
 <20190416124939.GB6027@kroah.com>
 <20190416130440.GA7944@localhost>
 <f8b15e31-1aab-ab2c-d44d-47325faab67d@opersys.com>
 <20190416094509.1af6326b@gandalf.local.home>
 <20190416142240.GA31920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416142240.GA31920@kroah.com>
User-Agent: NeoMutt/20180223
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 04:22:40PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 16, 2019 at 09:45:09AM -0400, Steven Rostedt wrote:
> > On Tue, 16 Apr 2019 09:32:37 -0400
> > Karim Yaghmour <karim.yaghmour@opersys.com> wrote:
> > 
> > > >>> Then we should perhaps make a new file system call tarballs ;-)
> > > >>>
> > > >>>   /sys/kernel/tarballs/
> > > >>>
> > > >>> and place everything there. That way it removes it from /proc (which is
> > > >>> the worse place for that) and also makes it something other than debug.
> > > >>> That's what I did for tracefs.  
> > > >>
> > > >> As horrible as that suggestion is, it does kind of make sense :)
> > > >>
> > > >> We can't put this in debugfs as that's only for debugging and systems
> > > >> should never have that mounted for normal operations (users want to
> > > >> build ebpf programs), and /proc really should be for processes but that
> > > >> horse is long left the barn.
> > > >>
> > > >> But, I'm willing to consider putting this either in a system-fs-like
> > > >> filesystem, or just in sysfs itself, we do have /sys/kernel/ to play
> > > >> around in if the main objection is that we should not be cluttering up
> > > >> /proc with stuff like this.
> > > >>  
> > > > 
> > > > I am ok with the suggestion of /sys/kernel for the archive. That also seems
> > > > to fit well with the idea that the headers are kernel related and probably
> > > > belong here more strictly speaking, than /proc.  
> > > 
> > > This makes sense. And if it alleviates concerns regarding extending 
> > > /proc ABIs then might as well switch to this.
> > > 
> > > Olof, what do you think of this?
> > 
> > BTW, the name "tarballs" was kind of a joke. Probably should come up
> > with a better name. Although, I'm fine with tarballsfs ;-)
> 
> No need to have this be a separate filesystem, we can use a binary sysfs
> file in /sys/kernel/ for this as the kernel is not doing any "parsing"
> of the data, it is just dumping it out to userspace.

What folks keep saying that an fs of header files is easier to use
than tarball from bcc and cleaner from architectural pov.
That's not the case.
From bcc side I'd rather have a single precompiled headers blob
that I can feed into clang and improve bpf program compilation time.
Having a set of headers is a step to generate such .pch file,
but once generated the headers can be removed from fs and kheaders
module unloaded.
The sequence is: bcc checks standard /lib/module location,
if not there loads kheader mod, extracts into known location, and unloads.
The extraced headers are in plain fs cache and will be evicted from memory
when bcc is done compiling progs.
imo much cleaner than kernel maintaining headers-fs and wasting memory.

Where kheaders.tar.xz is placed doesn't really matter.
/proc or /sys/kernel makes no real difference.

