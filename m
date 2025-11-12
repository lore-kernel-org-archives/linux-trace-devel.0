Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4B52C15B4
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762984157; cv=none; b=SlucsUso5uKjaFd19/GmHGdB8IAbWg3243bTQMLkWO05uhZgw0lXVi/s+mgXXgHBTb7h8AxhpTCUz5aJTmbAZ3V3UwcXJfpUoLhhOrAM1B0CdnrBhRdWemD67/f3QqOtTBwqFY6f1DoTApNQVaGrjCMgUdDwbt+bAlt2EC3JAWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762984157; c=relaxed/simple;
	bh=IcHTF0qt72WhXf5Eg75HuXXTg4RpXQIki9DlnSmx7Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C8nqbL/Ja880PL1Prqnl98k9qmuKjw3zxg/4Hg7+UlIoIXcvWk4/UP7q/AtFlTaq6COYwZZpjap+K8XqaUY/87zSXphIqeiOhL9gRsnGH3oa3yGgMqqyFVS03kRVVucotBxzPjdPxjY1i6XSZvQAVDazpLilLZEpkS8kDCNejok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF72C4AF0B;
	Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vJIiY-00000001DhU-2qeT;
	Wed, 12 Nov 2025 16:49:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 0/4] libtraceevent: Add BTF parsing for function arguments
Date: Wed, 12 Nov 2025 16:42:34 -0500
Message-ID: <20251112214929.290686-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
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

Changes since v2: https://lore.kernel.org/all/20250802024035.1893851-1-rostedt@goodmis.org/

- Removed debug print statement

- Replaced some printf() with tep_warning()

- Added trace-btf.c to meson build

- Added reference to BTF document: https://docs.kernel.org/bpf/btf.html

- Do not free btf->strings as that wasn't allocated.

- Fail to load if BTF endianess is different than the running machine.
  We can add support for that later.

- Make sure the raw data of str_hdr is valid (Douglas Raillard)

- Rename tep_btf_init() and tep_btf_free() to btf_init() and btf_free()
  as they no longer need to be unique as they are not exported.

- Have btf->raw_data allocated and not expect the caller to give up
  ownership of the raw_data. This allows the raw data passed in to simply
  be memory mapped.

- Updated the man page to not state the raw_data will become part of the
  tep handler, as the tep handler will now allocate its own.

- Use mmap() to load the btf kernel file.

- Make the example program a full featured program.

- If function isn't found and has extra characters (like ".isra.0")
  strip the extra characters and try again.

- Add simple unit test.


Steven Rostedt (Google) (4):
  libtraceevent: Add loading of BTF to the tep handle
  libtraceevent: Add man page for the new BTF functions
  libtraceevent: Have BTF find functions with extra characters
  libtraceevent utest: Add simple test to test BTF parsing

 Documentation/libtraceevent-btf.txt | 156 +++++++++
 Documentation/libtraceevent.txt     |   5 +
 include/traceevent/event-parse.h    |   5 +
 plugins/plugin_function.c           |  15 +-
 src/Makefile                        |   1 +
 src/event-parse-local.h             |   6 +
 src/event-parse.c                   |   2 +
 src/meson.build                     |   1 +
 src/trace-btf.c                     | 469 ++++++++++++++++++++++++++++
 utest/traceevent-utest.c            |  39 +++
 10 files changed, 689 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/libtraceevent-btf.txt
 create mode 100644 src/trace-btf.c

-- 
2.51.0

