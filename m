Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C575319617
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Dec 2025 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767106302; cv=none; b=Pj3KoEcfOrvbhRZipcDqVe01rmXVc8y93/J2kOa8P+zL7ND9IQamgD/UkW5TYcS93WCrWlmpw0AM+dGQnVJCbHIDP6HgyETTwxfASFBrt4tpju0w/KNmWXoaQIwOCniYqFvnnxGQ1ZhEdP/vara1K+KoRZAOk9BJATt3RzOIORY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767106302; c=relaxed/simple;
	bh=baVOg4O+c6xdL6rETU7MWs/jcMdY9TpgZUCHDLQir2U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=br6W+x4waHXOM3iIgyVloPgpGQMjahOxz65Ktx49Yr3Hek5j6ov/3V6skA00kWsJBqQSljRsqPldx21ng8ph0OdDlIrN9mRw4rLh+fsJjbwA41EFlPZW8Ayal1wkHWPJ8lsWOA0jqbwNUfQ18/KpOyaIMuUYx2XuhjVJX6ZFLfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D8B41A05C3;
	Tue, 30 Dec 2025 14:51:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 9A2DA17;
	Tue, 30 Dec 2025 14:51:35 +0000 (UTC)
Date: Tue, 30 Dec 2025 09:51:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: linux-trace-devel@vger.kernel.org, Douglas Raillard
 <douglas.raillard@arm.com>, Metin Kaya <metin.kaya@arm.com>
Subject: Re: i586: make test: event-parse.c:5643:(.text+0x16e6): undefined
 reference to `_tep_local___stack_chk_fail_local'
Message-ID: <20251230095143.072ba657@gandalf.local.home>
In-Reply-To: <d3ozbooqkmvjf4rnyklwvdvc7h@altlinux.org>
References: <d3ozbooqkmvjf4rnyklwvdvc7h@altlinux.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9A2DA17
X-Stat-Signature: i9kzkwxpu7q5611rm3h4thnnq3cqzk4s
X-Rspamd-Server: rspamout05
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+2uonhbOXCd6bGiO/ZL/nIamwUnPaz1ng=
X-HE-Tag: 1767106295-585547
X-HE-Meta: U2FsdGVkX1/W88WTUF7Aj+rRzKahN7xZh5LIgisVeNBhrJQY6H4XBdfxHluzqUChLBRDM6lyoyAoiOcNJnnTOuQkf5OFJ6XXslsNTkM0jIkTSxX5gVf+RlU7vGdMAqDRbIrWKoHWLhDwb6ihIy2oxytFlZZXtCSK6CMWVlw8+GL7aAqj+20cO84PDvWXle3bBdYT4sy3qMYWwbGDP6/NBEmkWVKx7N3v7aJkKpP7kTHR9kGcpgPiCpqs/J0m1FUveY7OHX/qQtaoV3jJplTj+3Qe1dQ5FkZ92TtSz/Oybp/9wjt7GPnxCk/t+z5kkYEJzk9BJPkAT5P42rn7n8LhQuQTTgNjEbnxX78Z8hfhr2aKNbevHJmGyJoaagIJ+m9B

On Fri, 14 Nov 2025 12:48:42 +0300
Vitaly Chikunov <vt@altlinux.org> wrote:

> Hi,
> 
> libtraceevent-1.8.5 fails to build `make test` on i586 (which is 32-bit
> x86) with

Sorry for the late reply, I just noticed this.

Is this still an issue?

> 
> [00:00:30] ( gcc /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest.o /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/traceevent-utest.o /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a -rdynamic -o /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest   -ldl -lcunit -ldl /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a)
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_ip6c_addr':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:5643:(.text+0x16e6): undefined reference to `_tep_local___stack_chk_fail_local'

This looks like the code that is used to hide internal global functions in
the static library. I'll have to set up a x86_32 VM and see if I can
reproduce it.

-- Steve


> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `arg_num_eval':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2904:(.text+0x1c78): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `arg_eval':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2934:(.text+0x1d3b): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `consolidate_op_arg':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2302:(.text+0x20d8): undefined reference to `_tep_local___udivdi3'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2305:(.text+0x2186): undefined reference to `_tep_local___umoddi3'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `__read_token':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1383:(.text+0x2b50): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `__read_expected':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1528:(.text+0x2ced): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `process_bitmask':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:3452:(.text+0x2e40): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `parse_args':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:6761:(.text+0x37b1): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `parse_header_field':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7755:(.text+0x3bf6): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o):/usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1972: more undefined references to `_tep_local___stack_chk_fail_local' follow
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `eval_num_arg':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:4561:(.text+0xab5b): undefined reference to `_tep_local___udivdi3'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:4564:(.text+0xabdb): undefined reference to `_tep_local___umoddi3'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_parse_data':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:6795:(.text+0xba8a): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_event_info':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7118:(.text+0xca54): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_event':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7327:(.text+0xd809): undefined reference to `_tep_local___udivmoddi4'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_event_time':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7168:(.text+0xdb4c): undefined reference to `_tep_local___udivdi3'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_event':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7340:(.text+0xdb7f): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_parse_header_page':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7798:(.text+0xde45): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_get_field_raw':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8118:(.text+0xdfdf): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_num_field':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8226:(.text+0xe18e): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_func_field':
> [00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8269:(.text+0xe2f4): undefined reference to `_tep_local___stack_chk_fail_local'
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o):/usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8003: more undefined references to `_tep_local___stack_chk_fail_local' follow
> [00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest: hidden symbol `_tep_local___stack_chk_fail_local' isn't defined
> [00:00:30] ld: final link failed: bad value
> [00:00:30] collect2: error: ld returned 1 exit status
> [00:00:30] make[1]: *** [Makefile:22: /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest] Error 1
> [00:00:30] make: *** [Makefile:258: test] Error 2
> 
> Temporary build log: https://git.altlinux.org/tasks/400072/build/100/i586/log
> 
> Build on x86_64 and aarch64 is OK.
> 
> Thanks,

