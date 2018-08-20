Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mga01.intel.com ([192.55.52.88]:38244 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbeHTTJk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 15:09:40 -0400
From: Thiago Macieira <thiago.macieira@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtracevent build warnings on Clear Linux (gcc 8.2.0)
Date: Mon, 20 Aug 2018 08:53:05 -0700
Message-ID: <1800559.mKxvYeAo7o@tjmaciei-mobl1>
In-Reply-To: <20180820133943.GB21100@kernel.org>
References: <20180820133943.GB21100@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Monday, 20 August 2018 06:39:43 PDT Arnaldo Carvalho de Melo wrote:
> Hi guys,

Hello

> Makefile.config:318: No libelf found. Disables 'probe' tool, jvmti and BPF
> support in 'perf record'. Please install libelf-dev, libelf-devel or
> elfutils-libelf-devel

You may want to install the user-basic-dev bundle.

> Makefile.config:518: Disabling post unwind, no support found.

Also present in user-basic-dev.

> Makefile.config:598: slang not found, disables TUI support. Please install
> slang-devel, libslang-dev or libslang2-dev

Ditto.

> Makefile.config:612: GTK2 not found, disables GTK2 support. Please install
> gtk2-devel or libgtk2.0-dev

This one is in desktop-dev. We don't have that enabled in our own build of 
perf, though.

> Makefile.config:666: No python interpreter was found: disables Python
> support - please install python-devel/python-dev

user-basic-dev too. We're almost rid of Python 2, do you need it?

> Makefile.config:750: No liblzma found, disables xz kernel module
> decompression, please install xz-devel/liblzma-dev

Assuming xz is sufficient for this, user-basic-dev.

> Makefile.config:814: No libbabeltrace found, disables 'perf data' CTF format
> support, please install libbabeltrace-dev[el]/libbabeltrace-ctf-dev

user-basic-dev too.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center
