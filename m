Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE20126A1C9
	for <linux-trace-devel@vger.kernel.org>; Tue, 19 Aug 2025 19:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755633383; cv=none; b=VyyUU1KoVD5sX0z6gcdgg9Gbin4XGzF+SA70I5NvrEGxJN+Ud5dHM+BnsXZhf1BM9UcaVJ4RtgOSUO0DrWVt1r6bjEJXMEJENiipJesKIxT0tNkDrwO0fW8usJemcO0BVVgCTo0ogdp2ApFsQhk1ljisgBFvjuHqStXEmzmhrBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755633383; c=relaxed/simple;
	bh=12w184TzzqnJEG2zHT1XyG64fDuY4FKBI0WOHKba8Es=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7ECJflesSTFsuhngyklVsH38XN1z2qVGMsXheJy96370fow4xQgF4OGkAa5O8srOd2FftsmSqjyBqUgsF3tfH26BatBg0zkcyW9NJZqtJNVJhG3CFr7EvfjHDiLMQy2/JUDWFFQSJUk818dC+uXk0SGzHc3oNnhcFD+wRXssvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94EF01DB758;
	Tue, 19 Aug 2025 19:56:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 19DB020018;
	Tue, 19 Aug 2025 19:56:17 +0000 (UTC)
Date: Tue, 19 Aug 2025 15:56:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Douglas Raillard
 <douglas.raillard@arm.com>
Subject: Re: [RFC][PATCH] libtraceevent: Fix static library to hide hidden
 functions
Message-ID: <20250819155617.73f91fd6@gandalf.local.home>
In-Reply-To: <b6a51783-7867-46a7-90ab-7be69c7112a0@arm.com>
References: <20250814144710.6c3458d4@gandalf.local.home>
	<c0d09a7e-c3a2-468d-a81d-cdef37f4c575@arm.com>
	<20250815132603.6b347952@gandalf.local.home>
	<b6a51783-7867-46a7-90ab-7be69c7112a0@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j1x5gw4rwmscm4xtnbdh9g736yyo4bgr
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 19DB020018
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX195uJ4KB7mlaCr08HvZ7dZRw3fpgi4DIOo=
X-HE-Tag: 1755633377-801150
X-HE-Meta: U2FsdGVkX19YkB7qvNy1tAoaV/2c10GW34a42yFyYTOMp6SqF6W0Lh23iWzkXSoXL/3c031sivIzBL/BvIjH1cKGEI5LvjTSMSjeHXwwSAgYz0w/UTcC+MZ3E8LK5Wzrh4G+WUleerzPC+vb/uYBABI837y1ZnV1QHsPqsAsyUkj+fhREVH7+TckgUe5BliscB6GptrrgVjFlIKErtZHORk4XOlJ3CcvilWob6xfaZVE0d3+DlCfX07UAXzywLhAunjnqu0wvWPBPEppNsTKbgfDWVeaFtncSCITHA1lW6wsLZxF+QmBm9BFEC+qfogM/OTgkHyI8UPWso3dwM7fjktb6EEOtI7acIokF5KbP2w+MuVqg4OAsvMP1UfVHgQb

On Tue, 19 Aug 2025 15:04:32 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> Now this is what I get when I try to build trace-cmd:
> 
>    BUILD                  trace-cmd
> /usr/bin/ld: /out/lib64/libtraceevent.a(libtraceevent.o): in function 
> `load_plugin':
> /libtraceevent/src/event-plugin.c:459:(.text+0x1458c): warning: Using 
> 'dlopen' in statically linked applications requires at runtime the 
> shared libraries from the glibc version used for linking
> /usr/bin/ld: /trace-cmd/tracecmd/trace-setup-guest.o: in function 
> `trace_setup_guest':
> trace-setup-guest.c:(.text+0x5c8): warning: Using 'getgrnam' in 
> statically linked applications requires at runtime the shared libraries 
> from the glibc version used for linking
> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
> `record_trace.isra.0':
> trace-record.c:(.text+0xe705): warning: Using 'initgroups' in statically 
> linked applications requires at runtime the shared libraries from the 
> glibc version used for linking
> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
> `do_getaddrinfo':
> trace-record.c:(.text+0x865): warning: Using 'getaddrinfo' in statically 
> linked applications requires at runtime the shared libraries from the 
> glibc version used for linking
> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
> `record_trace.isra.0':
> trace-record.c:(.text+0xe6ee): warning: Using 'getpwnam' in statically 
> linked applications requires at runtime the shared libraries from the 
> glibc version used for linking

Do you get the above warnings regardless?


> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
> `tracecmd_stat_cpu_instance':
> trace-record.c:(.text+0x12ec): undefined reference to `trace_seq_printf'
> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function `record_stats':
> trace-record.c:(.text+0x1419): undefined reference to `trace_seq_init'


> /usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
> function `update_page_info':
> trace-input.c:(.text+0x15d7): undefined reference to 
> `kbuffer_load_subbuffer'
> /usr/bin/ld: trace-input.c:(.text+0x15df): undefined reference to 
> `kbuffer_subbuffer_size'

Oops, I forgot that trace_seq* and kbuffer_* are also supplied. I made
everything that didn't start with 'tep_*' "static". I could add kbuffer_*
and trace_seq_* to that list (the easy way out), or I can parse
`nm libtraceevent.so` and convert everything that's static in it to static
in the static library.

-- Steve
