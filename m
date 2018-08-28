Return-Path: <SRS0=NWCu=LL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbeH2CMN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Aug 2018 22:12:13 -0400
Date: Tue, 28 Aug 2018 18:18:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3.5 21/24] tools lib traceevent: Rename various pevent
 get/set/is APIs
Message-ID: <20180828181828.3cc5baf0@gandalf.local.home>
In-Reply-To: <20180828090910.15665-1-tz.stoyanov@gmail.com>
References: <20180827081759.17297-22-tz.stoyanov@gmail.com>
        <20180828090910.15665-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 28 Aug 2018 12:09:10 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to make libtraceevent into a proper library, variables, data
> structures and functions require a unique prefix to prevent name space
> conflicts. That prefix will be "tep_" and not "pevent_". This changes
> APIs: pevent_pid_is_registered, pevent_get_cpus, pevent_set_cpus,
> pevent_is_file_bigendian, pevent_is_host_bigendian, pevent_is_latency_format,
> pevent_set_latency_format
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> Cc: linux-trace-devel@vger.kernel.org
> Link: http://lkml.kernel.org/r/20180808180703.114110715@goodmis.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>

Thanks, I pulled the entire series with the two updated patches.

-- Steve
