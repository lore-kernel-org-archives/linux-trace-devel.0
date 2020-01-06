Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF4FC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 16:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C9D206E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 16:26:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lsqGs8Ee"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgAFQ01 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:26:27 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33668 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgAFQ01 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 11:26:27 -0500
Received: by mail-qk1-f196.google.com with SMTP id d71so32070008qkc.0;
        Mon, 06 Jan 2020 08:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JQtEouoO14ibFdu5R0ExtR9RU4wVGRzBfAmbFruyaUA=;
        b=lsqGs8EeesC12VRJVQx6YbN9hunSXuCn1drlRK4CMOlEpjymNwTXoZPhVtdAu9W68a
         g/6D0I0VDQbU0+0cBscdlRHLYxX1GiES5hDJl9A7NI4DuRjE5joFsdCh3kmBZJDLa6qv
         eqmoz5OJEPgtMBXpWZxhpzMP3b/Pb6mHJ1Qeg4Drzpxs3kfddkhGXTJPYU637rkXcIHC
         gMtiLP52kppQjBrGoQCXSWPZW2xxC5hYczQ+btKqZpdjzvdGCuJ3Ok/xtaQVa7xvCw03
         +HCuY0b/rE0w5nA87S2l8EXtTIx25o3tCpge8IDI9DpdU4yyjZZYjvCb4QXEhe1M5c2/
         V1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JQtEouoO14ibFdu5R0ExtR9RU4wVGRzBfAmbFruyaUA=;
        b=dTZ4zIrUg21sq/9AY3Vqo6sNELprk6mtiRH9/qk8FtxQLqt9CNh5kx4x//DGk829qz
         HEL5QWeGDKbUKUJikvwPSUjtaXLfzN2vyzTvyYgyJrOMahv6vy63oIqwIfYwJPSozgOh
         vJIqQJROUoLJwWelQ8qZotEJRmvbyCiVBYKyyI3WYegNMvVQtAYxX8qYvxXr2ERQ7XMQ
         K7U/Auiqzm/GY8OHnGEe54yDDXwT/HefZKTj+nZxMKraTSdDmMRuNerD65HIeXMmlXwG
         l9uGyxp6XxFYUuPpBuganJYz6oSm0qffOUu7k47NFfMDo/OGsZR4oXKi74RyacGopihq
         Dodg==
X-Gm-Message-State: APjAAAV8BRhwVI39Hwp69/9AY5DS0liBXkOjNIWa+eznZPspqDEwBYa1
        BzKa6ZPVCay6ePC2JaVuSYM=
X-Google-Smtp-Source: APXvYqwRYizllbxOp6iQxO2ykkiYb6oLHdpU3gYtOdzJqv+FHGnhZsdGq11wpHk/jKTPveEV4k1jug==
X-Received: by 2002:a37:ad0e:: with SMTP id f14mr72323328qkm.213.1578327986104;
        Mon, 06 Jan 2020 08:26:26 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id s26sm15805987qtc.43.2020.01.06.08.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 08:26:25 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 56B3F40DFD; Mon,  6 Jan 2020 13:26:23 -0300 (-03)
Date:   Mon, 6 Jan 2020 13:26:23 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        users@linux.kernel.org
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200106162623.GA11285@kernel.org>
References: <20200102122004.216c85da@gandalf.local.home>
 <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
 <20200103133640.GD9715@krava>
 <20200103181614.7aa37f6d@gandalf.local.home>
 <20200106151902.GB236146@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106151902.GB236146@krava>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Mon, Jan 06, 2020 at 04:19:02PM +0100, Jiri Olsa escreveu:
> On Fri, Jan 03, 2020 at 06:16:14PM -0500, Steven Rostedt wrote:
> > 
> > [ Added Konstantin and kernel.org users mailing list ]
> > 
> > On Fri, 3 Jan 2020 14:36:40 +0100
> > Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > On Thu, Jan 02, 2020 at 06:58:53PM -0500, Steven Rostedt wrote:
> > > > On Fri, 3 Jan 2020 00:49:50 +0100
> > > > Jiri Olsa <jolsa@redhat.com> wrote:
> > > >   
> > > > > > Should we move libtraceevent into a stand alone git repo (on
> > > > > > kernel.org), that can have tags and branches specifically for it? We
> > > > > > can keep a copy in the Linux source tree for perf to use till it    
> > > > > 
> > > > > so libbpf 'moved' for this reason to github repo,
> > > > > but keeping the kernel as the true/first source,
> > > > > and updating github repo when release is ready
> > > > > 
> > > > > libbpf github repo is then source for fedora (and others)
> > > > > package  
> > > > 
> > > > Ah, so perhaps I should follow this? I could keep it a kernel.org repo
> > > > (as I rather have it there anyway).  
> > > 
> > > sounds good, and if it works out, we'll follow you with libperf :-)
> > > 
> > > if you want to check on the libbpf:
> > >   https://github.com/libbpf/libbpf
> > > 
> > > there might be some syncs scripts worth checking
> > 
> > I wonder if there should be a:
> > 
> >   git://git.kernel.org/pub/scm/utils/lib/
> > 
> > directory to have:
> > 
> >   git://git.kernel.org/pub/scm/utils/lib/traceevent/
> >   git://git.kernel.org/pub/scm/utils/lib/libbpf/
> >   git://git.kernel.org/pub/scm/utils/lib/libperf/
> 
> we could loose the 'lib' and just have:
> 
>     git://git.kernel.org/pub/scm/utils/lib/perf/

So, we have:

https://www.kernel.org/pub/linux/kernel/tools/perf/

trying to mimic the kernel sources tree structure, so perhaps we could
have:

https://www.kernel.org/pub/linux/kernel/tools/lib/{perf,traceevent}/

To continue that directory tree mirror?

> > That could hold the libraries that are tight to the kernel?

> I don't think libbpf will change now after they are settled in github,
> but we could consider this for libperf
> 
> jirka

-- 

- Arnaldo
