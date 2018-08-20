Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbeHTTa1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 15:30:27 -0400
Date: Mon, 20 Aug 2018 13:14:10 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Thiago Macieira <thiago.macieira@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtracevent build warnings on Clear Linux (gcc 8.2.0)
Message-ID: <20180820161410.GD21100@kernel.org>
References: <20180820133943.GB21100@kernel.org>
 <1800559.mKxvYeAo7o@tjmaciei-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1800559.mKxvYeAo7o@tjmaciei-mobl1>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Em Mon, Aug 20, 2018 at 08:53:05AM -0700, Thiago Macieira escreveu:
> On Monday, 20 August 2018 06:39:43 PDT Arnaldo Carvalho de Melo wrote:
> > Hi guys,
> 
> Hello
> 
> > Makefile.config:318: No libelf found. Disables 'probe' tool, jvmti and BPF
> > support in 'perf record'. Please install libelf-dev, libelf-devel or
> > elfutils-libelf-devel
> 
> You may want to install the user-basic-dev bundle.

Thanks, I'll add that one
 
> > Makefile.config:518: Disabling post unwind, no support found.
> 
> Also present in user-basic-dev.
> 
> > Makefile.config:598: slang not found, disables TUI support. Please install
> > slang-devel, libslang-dev or libslang2-dev
> 
> Ditto.
> 
> > Makefile.config:612: GTK2 not found, disables GTK2 support. Please install
> > gtk2-devel or libgtk2.0-dev
> 
> This one is in desktop-dev. We don't have that enabled in our own build of 
> perf, though.
> 
> > Makefile.config:666: No python interpreter was found: disables Python
> > support - please install python-devel/python-dev
> 
> user-basic-dev too. We're almost rid of Python 2, do you need it?

Nope, patches to make perf build with python3 (while still building with
python2, if that is what is available) were already merged, IIRC.
 
> > Makefile.config:750: No liblzma found, disables xz kernel module
> > decompression, please install xz-devel/liblzma-dev
> 
> Assuming xz is sufficient for this, user-basic-dev.

ok
 
> > Makefile.config:814: No libbabeltrace found, disables 'perf data' CTF format
> > support, please install libbabeltrace-dev[el]/libbabeltrace-ctf-dev
> 
> user-basic-dev too.

Cool, now the avx2 thingy.

- Arnaldo
