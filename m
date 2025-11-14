Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF5F3043C6
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Nov 2025 09:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763114272; cv=none; b=CcqlcfogqenuvtbfLC5oIb7OYtl89MB9bqxJBVD1owFYnB94+Uoo7WOIbsYqKcb8C+Lc7SLSCwchOBIEp9jHy43wjhVXo1ias7n39/e3sUaPGCyVOi7fn3hfl9oux8HXGTQumPKVZEgolgVEvIXqsa6yLGqGR2zK99ykZ7Lfz+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763114272; c=relaxed/simple;
	bh=9ZyrSdMXZY4m4J2tAu77z69myJziENPPLR/Wr/1PTXE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PoxOjBc6UswIr0XoUhPtWntVQWDRpEkM25mssujk5boZx7p345AMbVMnqJks3QtK86NFCHPPmkoAKgzxUEYMr07gYHv2kqme9wXyu4z8bCT9T0lVCDZwwDw8ncmG93Zc318VJIxcbPWHlViVL8IQAnqXs9bht/+55ZCQmZE1uu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 01C6472C8CC;
	Fri, 14 Nov 2025 12:48:43 +0300 (MSK)
Received: from altlinux.org (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id EC76636D00D0;
	Fri, 14 Nov 2025 12:48:42 +0300 (MSK)
Date: Fri, 14 Nov 2025 12:48:42 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: linux-trace-devel@vger.kernel.org, 
	Douglas Raillard <douglas.raillard@arm.com>, Metin Kaya <metin.kaya@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>
Subject: i586: make test: event-parse.c:5643:(.text+0x16e6): undefined
 reference to `_tep_local___stack_chk_fail_local'
Message-ID: <d3ozbooqkmvjf4rnyklwvdvc7h@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

Hi,

libtraceevent-1.8.5 fails to build `make test` on i586 (which is 32-bit
x86) with

[00:00:30] ( gcc /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest.o /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/traceevent-utest.o /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a -rdynamic -o /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest   -ldl -lcunit -ldl /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a)
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_ip6c_addr':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:5643:(.text+0x16e6): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `arg_num_eval':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2904:(.text+0x1c78): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `arg_eval':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2934:(.text+0x1d3b): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `consolidate_op_arg':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2302:(.text+0x20d8): undefined reference to `_tep_local___udivdi3'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:2305:(.text+0x2186): undefined reference to `_tep_local___umoddi3'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `__read_token':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1383:(.text+0x2b50): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `__read_expected':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1528:(.text+0x2ced): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `process_bitmask':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:3452:(.text+0x2e40): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `parse_args':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:6761:(.text+0x37b1): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `parse_header_field':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7755:(.text+0x3bf6): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o):/usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:1972: more undefined references to `_tep_local___stack_chk_fail_local' follow
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `eval_num_arg':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:4561:(.text+0xab5b): undefined reference to `_tep_local___udivdi3'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:4564:(.text+0xabdb): undefined reference to `_tep_local___umoddi3'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_parse_data':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:6795:(.text+0xba8a): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_event_info':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7118:(.text+0xca54): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_event':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7327:(.text+0xd809): undefined reference to `_tep_local___udivmoddi4'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `print_event_time':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7168:(.text+0xdb4c): undefined reference to `_tep_local___udivdi3'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_event':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7340:(.text+0xdb7f): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_parse_header_page':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:7798:(.text+0xde45): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_get_field_raw':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8118:(.text+0xdfdf): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_num_field':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8226:(.text+0xe18e): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o): in function `tep_print_func_field':
[00:00:30] /usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8269:(.text+0xe2f4): undefined reference to `_tep_local___stack_chk_fail_local'
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/lib/libtraceevent.a(event-parse.o):/usr/src/RPM/BUILD/libtraceevent-1.8.5/src/event-parse.c:8003: more undefined references to `_tep_local___stack_chk_fail_local' follow
[00:00:30] ld: /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest: hidden symbol `_tep_local___stack_chk_fail_local' isn't defined
[00:00:30] ld: final link failed: bad value
[00:00:30] collect2: error: ld returned 1 exit status
[00:00:30] make[1]: *** [Makefile:22: /usr/src/RPM/BUILD/libtraceevent-1.8.5/utest/trace-utest] Error 1
[00:00:30] make: *** [Makefile:258: test] Error 2

Temporary build log: https://git.altlinux.org/tasks/400072/build/100/i586/log

Build on x86_64 and aarch64 is OK.

Thanks,

