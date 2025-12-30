Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5718E2AD3D
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Dec 2025 19:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767122226; cv=none; b=lA+k2xqNfOG+Y0aThCwHgmtXICCNc3Fg/92c9N24hGs1wHChp9E0ktDoRYSOsHZ+1jVVyJ9ximdGMngSxEqO8g92RBTed162i3zymfn3YrnIIJRW/8HkZHbTTaZWQTIyZZYKufvlXJ2WxnFcmVlS9AB5Ol75Bayg9MwG88AQcc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767122226; c=relaxed/simple;
	bh=PiG7EsZCt5HbSxRNNn7BW1how8G0s0NxlvTRlCRhrMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9hVFdBDWnG2t2nszHoCfePTr6Dz940zHl7gcw/m4lnoa+zCk6Y4xvSYd1kHrNYRyFr2jT/PEPNlBo6w4Jrn7Vufrc2JHrUI+4UnPCnvh5eQVAqPgjquhKejSnM5BUqHKlOts4rPx2yAgiKsACx52crkBwCB9VxgS100xgifogk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 79EC572C8CC;
	Tue, 30 Dec 2025 22:16:56 +0300 (MSK)
Received: from altlinux.org (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id 6A8FE36D019F;
	Tue, 30 Dec 2025 22:16:56 +0300 (MSK)
Date: Tue, 30 Dec 2025 22:16:56 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, 
	Douglas Raillard <douglas.raillard@arm.com>, Metin Kaya <metin.kaya@arm.com>
Subject: Re: i586: make test: event-parse.c:5643:(.text+0x16e6): undefined
 reference to `_tep_local___stack_chk_fail_local'
Message-ID: <aVQkyqclWaY5LHhi@altlinux.org>
References: <d3ozbooqkmvjf4rnyklwvdvc7h@altlinux.org>
 <20251230095143.072ba657@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20251230095143.072ba657@gandalf.local.home>

Steven,

On Tue, Dec 30, 2025 at 09:51:43AM -0500, Steven Rostedt wrote:
> On Fri, 14 Nov 2025 12:48:42 +0300
> Vitaly Chikunov <vt@altlinux.org> wrote:
> 
> > Hi,
> > 
> > libtraceevent-1.8.5 fails to build `make test` on i586 (which is 32-bit
> > x86) with
> 
> Sorry for the late reply, I just noticed this.
> 
> Is this still an issue?
> 

I fixed locally with

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 13ea12a..8152d26 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -183,5 +183,6 @@ endef

 # Make all global functions that do not start with "tep_" have a unique name.
 redefine_local = \
-       $(shell for f in a `nm $(1) 2>/dev/null | grep ' t ' | cut -d' ' -f3 | sort -u`;  do \
+       $(shell for f in a `nm $(1) 2>/dev/null | grep ' t ' | grep -Ewv '__udivmoddi4|__udivdi3|__umoddi3|__stack_chk_fail_local' \
+       | cut -d' ' -f3 | sort -u`;  do \
         if [ "$${f#tep_}" = "$$f" ]; then echo --redefine-sym $$f=_tep_local_$$f; fi; done)

Thanks,


> > 
> > [00:00:30] ( gcc /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest.o /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/traceevent-utest.o /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a -rdynamic -o /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest   -ldl -lcunit -ldl /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a)
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_ip6c_addr':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:5643:(.text+0x16e6): undefined reference to `_tep_local___stack_chk_fail_local'
> 
> This looks like the code that is used to hide internal global functions in
> the static library. I'll have to set up a x86_32 VM and see if I can
> reproduce it.
> 
> -- Steve
> 
> 
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `arg_num_eval':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2904:(.text+0x1c78): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `arg_eval':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2934:(.text+0x1d3b): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `consolidate_op_arg':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2302:(.text+0x20d8): undefined reference to `_tep_local___udivdi3'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2305:(.text+0x2186): undefined reference to `_tep_local___umoddi3'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `__read_token':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1383:(.text+0x2b50): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `__read_expected':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1528:(.text+0x2ced): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `process_bitmask':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:3452:(.text+0x2e40): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `parse_args':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:6761:(.text+0x37b1): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `parse_header_field':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7755:(.text+0x3bf6): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o):/usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1972: more undefined references to `_tep_local___stack_chk_fail_local' follow
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `eval_num_arg':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:4561:(.text+0xab5b): undefined reference to `_tep_local___udivdi3'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:4564:(.text+0xabdb): undefined reference to `_tep_local___umoddi3'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_parse_data':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:6795:(.text+0xba8a): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_event_info':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7118:(.text+0xca54): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_event':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7327:(.text+0xd809): undefined reference to `_tep_local___udivmoddi4'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_event_time':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7168:(.text+0xdb4c): undefined reference to `_tep_local___udivdi3'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_event':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7340:(.text+0xdb7f): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_parse_header_page':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7798:(.text+0xde45): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_get_field_raw':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8118:(.text+0xdfdf): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_num_field':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8226:(.text+0xe18e): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_func_field':
> > [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8269:(.text+0xe2f4): undefined reference to `_tep_local___stack_chk_fail_local'
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o):/usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8003: more undefined references to `_tep_local___stack_chk_fail_local' follow
> > [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest: hidden symbol `_tep_local___stack_chk_fail_local' isn't defined
> > [00:00:30] ld: final link failed: bad value
> > [00:00:30] collect2: error: ld returned 1 exit status
> > [00:00:30] make[1]: *** [Makefile:22: /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest] Error 1
> > [00:00:30] make: *** [Makefile:258: test] Error 2
> > 
> > Temporary build log: https://git.altlinux.org/tasks/400072/build/100/i586/log
> > 
> > Build on x86_64 and aarch64 is OK.
> > 
> > Thanks,
