Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBCE45C14
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754310985; cv=none; b=ZiKHevmN8aEgQnGFQIEDoDQ+uw1ex8n5aqmkiwhQPrFRCafaApx+3dCbF1S2zdDpuGA/s/BaQMyXOlT2mtP5QiRNMoEztzPgek3MSr3bvMNa1p9FtxzPGbasCiSRelCPvWiXl+YAI2tDIuiqdqDPbpjev6sB6hXt+6CDcLdt2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754310985; c=relaxed/simple;
	bh=0LpAJaXo1SvImv7qlLAbNcDRIp/oWy7tOY84szCdkzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f+bOQDLAsOtp7C/5IfHCgkGteklSh7eW9Lm5S95EHC0mtR6CIKzpmPmpcDX1KvMgYNkegdJotUU/geKBY3kiRWEznbYgipgLF68Y9J6HQI5D/q15c8RjU00wuA1/A7v71NVdm3wSuIcajVjdOsW2dKgVoPNzuKqXvp5uYyPsnTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53291150C;
	Mon,  4 Aug 2025 05:36:15 -0700 (PDT)
Received: from [192.168.1.127] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F14C83F738;
	Mon,  4 Aug 2025 05:36:21 -0700 (PDT)
Message-ID: <6457bff9-9485-4d2d-82a5-ae436932000a@arm.com>
Date: Mon, 4 Aug 2025 13:36:26 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] trace-cmd: Use BTF to parse function arguments
To: Steven Rostedt <rostedt@goodmis.org>, linux-trace-devel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Takaya Saeki <takayas@google.com>,
 Ian Rogers <irogers@google.com>, aahringo@redhat.com
References: <20250731202238.1654368-1-rostedt@goodmis.org>
Content-Language: en-US
From: Douglas Raillard <douglas.raillard@arm.com>
In-Reply-To: <20250731202238.1654368-1-rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31-07-2025 21:20, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If function tracer is recorded with func-args option set, or the
> function_graph tracer is recorded with the funcgraph-args option set, then
> record the BTF file in a new BTF_FILE section in the trace.dat file.

Would it be possible to also add an explicit CLI flag to collect the BTF blob ?

We may have some use for that downstream that are unrelated to function_graph
tracer. One unrefined idea I had was to use BTF to get the enumerator names
when converting events to parquet. With dict encoding, this would be just as
efficient and much nicer for the end user.

> This is compressed on disk, and when the trace.dat file is read, it is
> loaded into memory and sent to the libtraceevent tep_load_btf() function.
> 
> This will be used to show arguments of the function tracer:
> 
>   # trace-cmd record -p function -O func-args cat /etc/passwd
>   # trace-cmd report
> 
>               cat-33501 [005] ..... 136155.767937: function:             mutex_unlock(lock=0xffffffff831dbbe0)
>               cat-33501 [005] ..... 136155.767939: function:             __mutex_unlock_slowpath(lock=0xffffffff831dbbe0, ip=0xffffffff814a7154)
>               cat-33501 [005] ..... 136155.767940: function:             __f_unlock_pos(f=0xffff8881538de000)
>               cat-33501 [005] ..... 136155.767940: function:             mutex_unlock(lock=0xffff8881538de090)
>               cat-33501 [005] ..... 136155.767940: function:             __mutex_unlock_slowpath(lock=0xffff8881538de090, ip=0xffffffff816e8ed1)
>               cat-33501 [005] ..... 136155.767941: function:             mem_cgroup_handle_over_high(gfp_mask=0xcc0)
>               cat-33501 [005] ..... 136155.767941: function:             blkcg_maybe_throttle_current()
>               cat-33501 [005] ..... 136155.767942: function:             __rseq_handle_notify_resume(ksig=0x0, regs=0xffffc9000e3eff58)
>               cat-33501 [005] d.... 136155.767943: function:             fpregs_assert_state_consistent()
>               cat-33501 [005] d.... 136155.767943: function:             switch_fpu_return()
>               cat-33501 [005] ..... 136155.767950: function:             __x64_sys_execve(regs=0xffffc9000e3eff58)
>               cat-33501 [005] ..... 136155.767951: function:                getname_flags(filename=0x7ffe7d33f3d0, flags=0)
>               cat-33501 [005] ..... 136155.767951: function:                getname_flags.part.0(7ffe7d33f3d0, 0, 0, 0, 0, 0)
>               cat-33501 [005] ..... 136155.767951: function:                   kmem_cache_alloc_noprof(s=0xffff8881001d3800, gfpflags=0xcc0)
> 
> And the same for function graph tracer:
> 
>   # trace-cmd record -p function_graph -O funcgraph-args cat /etc/passwd
>   # trace-cmd report
> 
>                   cat-43792 [006] ..... 147894.472393: funcgraph_entry:                   |  mutex_unlock(lock=0xffffffff831dbbe0) {
>                   cat-43792 [006] ..... 147894.472394: funcgraph_entry:        1.005 us   |    __mutex_unlock_slowpath(lock=0xffffffff831dbbe0, ip=0xffffffff812f2e30); (ret=0x0)
>                   cat-43792 [006] ..... 147894.472396: funcgraph_exit:         3.581 us   |  } (ret=0x0)
>                   cat-43792 [006] ..... 147894.472397: funcgraph_entry:                   |  __f_unlock_pos(f=0xffff8881538df980) {
>                   cat-43792 [006] ..... 147894.472397: funcgraph_entry:                   |    mutex_unlock(lock=0xffff8881538dfa10) {
>                   cat-43792 [006] ..... 147894.472397: funcgraph_entry:        0.434 us   |      __mutex_unlock_slowpath(lock=0xffff8881538dfa10, ip=0xffffffff812f2e30); (ret=0x0)
>                   cat-43792 [006] ..... 147894.472398: funcgraph_exit:         1.216 us   |    } (ret=0x0)
>                   cat-43792 [006] ..... 147894.472399: funcgraph_exit:         2.152 us   |  } (ret=0x0)
>                   cat-43792 [006] d.... 147894.472399: funcgraph_entry:        0.360 us   |  fpregs_assert_state_consistent(); (ret=0x6)
>                   cat-43792 [006] ..... 147894.472403: funcgraph_entry:                   |  __x64_sys_execve(regs=0xffffc900029f3f58) {
>                   cat-43792 [006] ..... 147894.472404: funcgraph_entry:                   |    getname_flags(filename=0x7fff4a902080, flags=0) {
>                   cat-43792 [006] ..... 147894.472404: funcgraph_entry:                   |      getname_flags.part.0(7fff4a902080, 0, 0, 0, 0, 0) {
>                   cat-43792 [006] ..... 147894.472405: funcgraph_entry:                   |        kmem_cache_alloc_noprof(s=0xffff8881001d3800, gfpflags=0xcc0) {
>                   cat-43792 [006] ..... 147894.472405: funcgraph_entry:        0.618 us   |          fs_reclaim_acquire(gfp_mask=0xcc0); (ret=0x0)
>                   cat-43792 [006] ..... 147894.472406: funcgraph_entry:        0.380 us   |          fs_reclaim_release(gfp_mask=0xcc0); (ret=0x0)
>                   cat-43792 [006] ..... 147894.472407: funcgraph_entry:                   |          kmemleak_alloc(ptr=0xffff8881120b0000, size=0x1000, min_count=1, gfp=0xcc0) {
>                   cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |            __create_object(ptr=0xffff8881120b0000, size=0x1000, min_count=1, gfp=0xcc0, objflags=0x0) {
>                   cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |              __alloc_object(gfp=0xcc0) {
>                   cat-43792 [006] ..... 147894.472408: funcgraph_entry:                   |                kmem_cache_alloc_noprof(s=0xffff888100045700, gfpflags=0x92cc0) {
>                   cat-43792 [006] ..... 147894.472409: funcgraph_entry:        0.570 us   |                  fs_reclaim_acquire(gfp_mask=0x92cc0); (ret=0x0)
>                   cat-43792 [006] ..... 147894.472410: funcgraph_entry:        0.370 us   |                  fs_reclaim_release(gfp_mask=0x92cc0); (ret=0x0)
>                   cat-43792 [006] ..... 147894.472411: funcgraph_exit:         2.226 us   |                } (ret=0xffff88814bbcf6a8)
> 
> 
> Steven Rostedt (Google) (5):
>    libtracecmd: Remove "compress" parameter from save_string_section()
>    libtracecmd: Remove "compress" parameter from tcmd_out_compress*()
>      functions
>    libtracecmd: Add write_compress_section_header() for writing compress
>      sections
>    trace-cmd record / report: Record BTF file if function arguments are
>      recorded
>    libtracecmd: Add printing of arguments for function graph tracer
> 
>   .../include/private/trace-cmd-private.h       |   3 +
>   lib/trace-cmd/include/trace-cmd-local.h       |   7 +-
>   lib/trace-cmd/trace-compress.c                |  26 ++
>   lib/trace-cmd/trace-ftrace.c                  |  41 +++-
>   lib/trace-cmd/trace-input.c                   |  57 +++--
>   lib/trace-cmd/trace-output.c                  | 228 ++++++++++--------
>   tracecmd/trace-record.c                       |  42 +++-
>   7 files changed, 271 insertions(+), 133 deletions(-)
> 

--
Douglas
