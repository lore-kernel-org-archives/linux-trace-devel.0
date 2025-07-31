Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD2320CCE3
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Jul 2025 18:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753988142; cv=none; b=Tr3Y9J+nYwrycKztpEJSuP3YuuIo3k2jPMazJeUoTI1Q/S17jbcctNKRETGndHbyhAJlX0lTolX8ymRX5TNW+bpyKsoDdsehRDbcL3yfa7Lvw3s33r0B3zxqRLcfTqXWboJFJqOFYmqjr470Vweg3xqYWJvckURk4ItbSl8oIgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753988142; c=relaxed/simple;
	bh=Tq2/w3RknfU061g0MJtc7jYkYjxn9n+LjbMCBPOzB/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dz9s+qJPmWhI/0rRe+wSEur90tvkJRYdv1nxyT6ZDfegwgffVegew2ybLOw+naf76hXcKO/aEKDSz6TI+rxX4QG3j93qBzDKOPbcZi3Bv3P0sZZxvcTVAr8EHTP9bVLDxnjhPqha4EWqZH71/gLUyOviSdloy+PR79hzb4e6hNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1148FC4CEF8;
	Thu, 31 Jul 2025 18:55:42 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1uhYRd-00000006tyB-0nTL;
	Thu, 31 Jul 2025 14:56:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtraceevent: Add BTF parsing for function arguments
Date: Thu, 31 Jul 2025 14:52:32 -0400
Message-ID: <20250731185559.1644753-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that functions can save the first 6 registers of their args during a
trace, and BTF can be used to decipher those arguments, have libtraceevent
handle this as well.

Add a tep_load_btf() function that loads the content of /sys/kernel/btf/vmlinux
and then uses that to parse it to show the arguments of functions in the trace.

When trace-cmd supports this, it would look like:

 # trace-cmd record -p function -O func-args cat /etc/passwd
 # trace-cmd report
             cat-33501 [005] ..... 136155.767937: function:             mutex_unlock(lock=0xffffffff831dbbe0)
             cat-33501 [005] ..... 136155.767939: function:             __mutex_unlock_slowpath(lock=0xffffffff831dbbe0, ip=0xffffffff814a7154)
             cat-33501 [005] ..... 136155.767940: function:             __f_unlock_pos(f=0xffff8881538de000)
             cat-33501 [005] ..... 136155.767940: function:             mutex_unlock(lock=0xffff8881538de090)
             cat-33501 [005] ..... 136155.767940: function:             __mutex_unlock_slowpath(lock=0xffff8881538de090, ip=0xffffffff816e8ed1)
             cat-33501 [005] ..... 136155.767941: function:             mem_cgroup_handle_over_high(gfp_mask=0xcc0)
             cat-33501 [005] ..... 136155.767941: function:             blkcg_maybe_throttle_current()
             cat-33501 [005] ..... 136155.767942: function:             __rseq_handle_notify_resume(ksig=0x0, regs=0xffffc9000e3eff58)
             cat-33501 [005] d.... 136155.767943: function:             fpregs_assert_state_consistent()
             cat-33501 [005] d.... 136155.767943: function:             switch_fpu_return()
             cat-33501 [005] ..... 136155.767950: function:             __x64_sys_execve(regs=0xffffc9000e3eff58)
             cat-33501 [005] ..... 136155.767951: function:                getname_flags(filename=0x7ffe7d33f3d0, flags=0)
             cat-33501 [005] ..... 136155.767951: function:                getname_flags.part.0(7ffe7d33f3d0, 0, 0, 0, 0, 0)
             cat-33501 [005] ..... 136155.767951: function:                   kmem_cache_alloc_noprof(s=0xffff8881001d3800, gfpflags=0xcc0)
             cat-33501 [005] ..... 136155.767951: function:                      fs_reclaim_acquire(gfp_mask=0xcc0)
             cat-33501 [005] ..... 136155.767952: function:                      fs_reclaim_release(gfp_mask=0xcc0)
             cat-33501 [005] ..... 136155.767953: function:                      kmemleak_alloc(ptr=0xffff8881114a0000, size=0x1000, min_count=1, gfp=0xcc0)
             cat-33501 [005] ..... 136155.767953: function:                      __create_object(ptr=0xffff8881114a0000, size=0x1000, min_count=1, gfp=0xcc0, objflags=0x0)
             cat-33501 [005] ..... 136155.767954: function:                         __alloc_object(gfp=0xcc0)


Steven Rostedt (Google) (2):
  libtraceevent: Add loading of BTF to the tep handle
  libtraceevent: Add man page for the new BTF functions

 Documentation/libtraceevent-btf.txt | 158 ++++++++++
 Documentation/libtraceevent.txt     |   5 +
 include/traceevent/event-parse.h    |   5 +
 plugins/plugin_function.c           |  15 +-
 src/Makefile                        |   1 +
 src/event-parse-local.h             |   6 +
 src/event-parse.c                   |   2 +
 src/trace-btf.c                     | 449 ++++++++++++++++++++++++++++
 8 files changed, 631 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/libtraceevent-btf.txt
 create mode 100644 src/trace-btf.c

-- 
2.47.2

