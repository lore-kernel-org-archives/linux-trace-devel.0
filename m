Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CBDC10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 17:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C401D20872
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 17:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LmPPIoBY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfDPRaN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 13:30:13 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43465 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfDPRaN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 13:30:13 -0400
Received: by mail-pl1-f196.google.com with SMTP id n8so10651709plp.10;
        Tue, 16 Apr 2019 10:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Iqpnc2s0Tfc8ZsBxvcd2S8uzbG2y1NeocyHqqI+5Vo8=;
        b=LmPPIoBYP2bFDkPWYAe8/d4KZPs2EzW83H8SN5RLxDeBpLcld2WFCmiyyl2UfQ4udK
         0huYvobi96QdeOphncLz2i8MdmTpsyBs+zz05NZp4BQ0Z/rbjnTQXG8pOSJ6iyZf76y8
         J+dwrGhypz/gSGQq1d6lLktJbG+Qt7f7eZ6+n3XVvN82za8bnQUWWa1rwcQX5ijoQ4/B
         3HH+n5+2UTd4RR0uC8GdhlGCfZI8ofpB4VxnnL1V2+uKo3b0TE+E83foftL7ckWRaI2N
         naVBPxLNUuErL37ELpwmsEjAEUU/3QoI2a4NPX3rQK4zLYH12XW4bQE6mjQnBM8FrGCj
         8wRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Iqpnc2s0Tfc8ZsBxvcd2S8uzbG2y1NeocyHqqI+5Vo8=;
        b=KqoVVDI+0s0qVBiaj3iF745UXlwiVKQYGc2Kv5TCSRoauFLm8ALnvoEHQqeJj6e9WD
         gAggfTlrtwjfZ0h4hF2nnwcmbJubhjilx1g+kuDOMtn4SEJdh5bhhKpznTkRmVEH1B+E
         59+UlnDuk3EkaSxtVRFCvW6YBIzgY09cHwCoNfD5NgbQ6v5Dz5D3W1zgLdLgP4b2ir2u
         8Z9y7Vch0LyyCmQUOE7pWGv+DeIC5WW678lyhfKaHfRnqPoqNzLLsWVohIabyCGuyImJ
         TiIf+v+TU/O/k/v8ilOVnHvUj9RzmKr+QBpsOgBlfYPFyvUAeS8Q0Qf1QBygsLF+OvRV
         rtBw==
X-Gm-Message-State: APjAAAWTS/AxwGHf5y+eV7S/ACYa8PZsqZE9Q+Aa8SuNZ+HTcVnvng8D
        OuGQhylsjMUxiGirIOBD/TA=
X-Google-Smtp-Source: APXvYqwtjHGgB+NHR2aRjLiwHLGjFTxWg+DjjTJbzFzfqAMVGpHql1gxjnFv4Ergc+JivpfX9Q2buQ==
X-Received: by 2002:a17:902:d24:: with SMTP id 33mr85470888plu.246.1555435811811;
        Tue, 16 Apr 2019 10:30:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:601e])
        by smtp.gmail.com with ESMTPSA id t64sm117503682pfa.86.2019.04.16.10.30.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 10:30:10 -0700 (PDT)
Date:   Tue, 16 Apr 2019 10:30:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Olof Johansson <olof@lixom.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Kees Cook <keescook@chromium.org>,
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
Message-ID: <20190416173006.qtssiekedr7jhcqq@ast-mbp.dhcp.thefacebook.com>
References: <20190415104109.64d914f3@gandalf.local.home>
 <CAGXu5j+KPVRcOJ3Ue9ZQF93GyaDhvCnFCvJ_C3WKCx2=SNdDyg@mail.gmail.com>
 <20190416083306.5646a687@gandalf.local.home>
 <20190416124939.GB6027@kroah.com>
 <20190416130440.GA7944@localhost>
 <f8b15e31-1aab-ab2c-d44d-47325faab67d@opersys.com>
 <20190416094509.1af6326b@gandalf.local.home>
 <20190416142240.GA31920@kroah.com>
 <20190416164642.krptlz32zusr4pgn@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgGEZ8o-e2uAYLSGeO+RHcXAEzEoKcsjpveOLJZ5pX=4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgGEZ8o-e2uAYLSGeO+RHcXAEzEoKcsjpveOLJZ5pX=4w@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 09:57:08AM -0700, Olof Johansson wrote:
> On Tue, Apr 16, 2019 at 9:46 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Apr 16, 2019 at 04:22:40PM +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Apr 16, 2019 at 09:45:09AM -0400, Steven Rostedt wrote:
> > > > On Tue, 16 Apr 2019 09:32:37 -0400
> > > > Karim Yaghmour <karim.yaghmour@opersys.com> wrote:
> > > >
> > > > > >>> Then we should perhaps make a new file system call tarballs ;-)
> > > > > >>>
> > > > > >>>   /sys/kernel/tarballs/
> > > > > >>>
> > > > > >>> and place everything there. That way it removes it from /proc (which is
> > > > > >>> the worse place for that) and also makes it something other than debug.
> > > > > >>> That's what I did for tracefs.
> > > > > >>
> > > > > >> As horrible as that suggestion is, it does kind of make sense :)
> > > > > >>
> > > > > >> We can't put this in debugfs as that's only for debugging and systems
> > > > > >> should never have that mounted for normal operations (users want to
> > > > > >> build ebpf programs), and /proc really should be for processes but that
> > > > > >> horse is long left the barn.
> > > > > >>
> > > > > >> But, I'm willing to consider putting this either in a system-fs-like
> > > > > >> filesystem, or just in sysfs itself, we do have /sys/kernel/ to play
> > > > > >> around in if the main objection is that we should not be cluttering up
> > > > > >> /proc with stuff like this.
> > > > > >>
> > > > > >
> > > > > > I am ok with the suggestion of /sys/kernel for the archive. That also seems
> > > > > > to fit well with the idea that the headers are kernel related and probably
> > > > > > belong here more strictly speaking, than /proc.
> > > > >
> > > > > This makes sense. And if it alleviates concerns regarding extending
> > > > > /proc ABIs then might as well switch to this.
> > > > >
> > > > > Olof, what do you think of this?
> > > >
> > > > BTW, the name "tarballs" was kind of a joke. Probably should come up
> > > > with a better name. Although, I'm fine with tarballsfs ;-)
> > >
> > > No need to have this be a separate filesystem, we can use a binary sysfs
> > > file in /sys/kernel/ for this as the kernel is not doing any "parsing"
> > > of the data, it is just dumping it out to userspace.
> >
> > What folks keep saying that an fs of header files is easier to use
> > than tarball from bcc and cleaner from architectural pov.
> > That's not the case.
> > From bcc side I'd rather have a single precompiled headers blob
> > that I can feed into clang and improve bpf program compilation time.
> > Having a set of headers is a step to generate such .pch file,
> > but once generated the headers can be removed from fs and kheaders
> > module unloaded.
> > The sequence is: bcc checks standard /lib/module location,
> > if not there loads kheader mod, extracts into known location, and unloads.
> 
> May I suggest keeping the bcc-populated headers somewhere else?

what do you mean by bcc-populated?
bcc keeps its own headers inside libbcc.so .data section and provides
them to clang as 'memory buffer' in clang's virtual file system.

> Ideally something cleaned out on every reboot in case kernel changes
> without version string doing it.
> 
> That way you can by default prefer the module-exported tarball, and
> fall back to /lib/module/$(uname -r)/ if not available, instead of the
> other way around and instead of having to check creation times on the
> dir vs boot time of the kernel, etc.

the order of checks is bcc implementation detail. we can change that later.
we've seen issues with /lib/modules/`uname -r` being corrupted by chef,
so we might actually extract from kheaders.tar.xz all the time and more
than once.
Like try-compiling a simple prog and if it doesn't work, do the extract.

> Anyway, that's just an implementation detail. But it's the kind of
> detail that all tools that use this would need to get right, instead
> of doing it right once by exporting it in a way that it can be
> directly used.

Today bcc is the only tool that interacts with clang this way.
There is enough complexity and plenty of complex issues with
on-the-fly recompile approach.
I strongly suggest anyone considering new on-the-fly recompile to work
with us on BTF instead.

The set of headers is not an ultimate goal. See the example with pch. 
bpf tracing needs three components:
- all types and layout of datastructures;
  including all function prototypes with arg names
- all macros
- all inline functions

The first one is solved by BTF based solution,
but macroses and infline functions have no substitute, but C header files.
That is today.
Eventually we might find a way to reduce dependency on headers and have
macroses and infline functions represented some other way.
Like mini-pch where only relevant bits of headers are represented as
clang's syntax tree or mini C code.
The key point is that having headers is not a goal.
Making kernel maintain an fs of headers is imo a waste of kernel code.
The most minimal approach of compressed tarball is preferred.

> 
> > The extraced headers are in plain fs cache and will be evicted from memory
> > when bcc is done compiling progs.
> > imo much cleaner than kernel maintaining headers-fs and wasting memory.
> 
> So, in my original proposal I recommended unmounting when not needing
> it, which would remove the memory usage as well.

and such header-fs would uncompress internal tarball, create inodes, dentries
and to make sure all that stuff is cleanly refcnted and freed.
imo that is plenty of kernel code for no good reason.

> > Where kheaders.tar.xz is placed doesn't really matter.
> > /proc or /sys/kernel makes no real difference.
> 
> If done in a location that isn't a perpetual ABI commitment, a tarball
> solution is something we can work with.

Fair enough. My guess that kheaders.tar.xz in this shape we would
need for at least 5 years. After that we'll come up with better approach.

