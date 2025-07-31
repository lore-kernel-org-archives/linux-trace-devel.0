Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E1325DB1D
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Jul 2025 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753993340; cv=none; b=ZqkD+xumIV7qwOGiBNuCFHVtOhYeU67t99zbqBxsv93h6LngG1Rd+Ey7f8KrslIhjBp8An+vKFLt2ptSZpnj0eTePpOoWKCr888Srt0A9sPViV/h4EkrOImaLIM4dZe1tETJTLAfjCmLtP+vH3CcZL1NEx0hDY1VX4N1uHhTWYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753993340; c=relaxed/simple;
	bh=UlbLxLBjYUW3/wHporWu4aFBbJdOniCiYGvPyUldfu0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y4G6Cf+5OVvsXPVDiAPSBP38hA5hZ51Ja6RxNZ9XX3pqfneliYpx4AMbCYM7+2i7DIEUF9aw0wlNcFl50F/E/5PrLfW4SrF2bULfmixhb1zCsNRp6YqZ6rjhgKX+b8y1qInhQJW3c85ez89XJRwTNqR2QpcxGRJuxyhBDzpIii0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C4AC4CEF7;
	Thu, 31 Jul 2025 20:22:20 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1uhZnT-00000006wR6-2kjX;
	Thu, 31 Jul 2025 16:22:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/5] trace-cmd: Use BTF to parse function arguments
Date: Thu, 31 Jul 2025 16:20:33 -0400
Message-ID: <20250731202238.1654368-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If function tracer is recorded with func-args option set, or the
function_graph tracer is recorded with the funcgraph-args option set, then
record the BTF file in a new BTF_FILE section in the trace.dat file.

This is compressed on disk, and when the trace.dat file is read, it is
loaded into memory and sent to the libtraceevent tep_load_btf() function.

This will be used to show arguments of the function tracer:

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

And the same for function graph tracer:

 # trace-cmd record -p function_graph -O funcgraph-args cat /etc/passwd
 # trace-cmd report

                 cat-43792 [006] ..... 147894.472393: funcgraph_entry:                   |  mutex_unlock(lock=0xffffffff831dbbe0) {
                 cat-43792 [006] ..... 147894.472394: funcgraph_entry:        1.005 us   |    __mutex_unlock_slowpath(lock=0xffffffff831dbbe0, ip=0xffffffff812f2e30); (ret=0x0)
                 cat-43792 [006] ..... 147894.472396: funcgraph_exit:         3.581 us   |  } (ret=0x0)
                 cat-43792 [006] ..... 147894.472397: funcgraph_entry:                   |  __f_unlock_pos(f=0xffff8881538df980) {
                 cat-43792 [006] ..... 147894.472397: funcgraph_entry:                   |    mutex_unlock(lock=0xffff8881538dfa10) {
                 cat-43792 [006] ..... 147894.472397: funcgraph_entry:        0.434 us   |      __mutex_unlock_slowpath(lock=0xffff8881538dfa10, ip=0xffffffff812f2e30); (ret=0x0)
                 cat-43792 [006] ..... 147894.472398: funcgraph_exit:         1.216 us   |    } (ret=0x0)
                 cat-43792 [006] ..... 147894.472399: funcgraph_exit:         2.152 us   |  } (ret=0x0)
                 cat-43792 [006] d.... 147894.472399: funcgraph_entry:        0.360 us   |  fpregs_assert_state_consistent(); (ret=0x6)
                 cat-43792 [006] ..... 147894.472403: funcgraph_entry:                   |  __x64_sys_execve(regs=0xffffc900029f3f58) {
                 cat-43792 [006] ..... 147894.472404: funcgraph_entry:                   |    getname_flags(filename=0x7fff4a902080, flags=0) {
                 cat-43792 [006] ..... 147894.472404: funcgraph_entry:                   |      getname_flags.part.0(7fff4a902080, 0, 0, 0, 0, 0) {
                 cat-43792 [006] ..... 147894.472405: funcgraph_entry:                   |        kmem_cache_alloc_noprof(s=0xffff8881001d3800, gfpflags=0xcc0) {
                 cat-43792 [006] ..... 147894.472405: funcgraph_entry:        0.618 us   |          fs_reclaim_acquire(gfp_mask=0xcc0); (ret=0x0)
                 cat-43792 [006] ..... 147894.472406: funcgraph_entry:        0.380 us   |          fs_reclaim_release(gfp_mask=0xcc0); (ret=0x0)
                 cat-43792 [006] ..... 147894.472407: funcgraph_entry:                   |          kmemleak_alloc(ptr=0xffff8881120b0000, size=0x1000, min_count=1, gfp=0xcc0) {
                 cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |            __create_object(ptr=0xffff8881120b0000, size=0x1000, min_count=1, gfp=0xcc0, objflags=0x0) {
                 cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |              __alloc_object(gfp=0xcc0) {
                 cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |                kmem_cache_alloc_noprof(s=0xffff888100045700, gfpflags=0x92cc0) {
                 cat-43792 [006] ..... 147894.472409: funcgraph_entry:        0.570 us   |                  fs_reclaim_acquire(gfp_mask=0x92cc0); (ret=0x0)
                 cat-43792 [006] ..... 147894.472410: funcgraph_entry:        0.370 us   |                  fs_reclaim_release(gfp_mask=0x92cc0); (ret=0x0)
                 cat-43792 [006] ..... 147894.472411: funcgraph_exit:         2.226 us   |                } (ret=0xffff88814bbcf6a8)


Steven Rostedt (Google) (5):
  libtracecmd: Remove "compress" parameter from save_string_section()
  libtracecmd: Remove "compress" parameter from tcmd_out_compress*()
    functions
  libtracecmd: Add write_compress_section_header() for writing compress
    sections
  trace-cmd record / report: Record BTF file if function arguments are
    recorded
  libtracecmd: Add printing of arguments for function graph tracer

 .../include/private/trace-cmd-private.h       |   3 +
 lib/trace-cmd/include/trace-cmd-local.h       |   7 +-
 lib/trace-cmd/trace-compress.c                |  26 ++
 lib/trace-cmd/trace-ftrace.c                  |  41 +++-
 lib/trace-cmd/trace-input.c                   |  57 +++--
 lib/trace-cmd/trace-output.c                  | 228 ++++++++++--------
 tracecmd/trace-record.c                       |  42 +++-
 7 files changed, 271 insertions(+), 133 deletions(-)

-- 
2.47.2

