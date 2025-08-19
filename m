Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22651FC7C5
	for <linux-trace-devel@vger.kernel.org>; Tue, 19 Aug 2025 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755612278; cv=none; b=OdvoJu8pHiI6ZBp8rdm5hY2Yu1RDpDdrMUd/1cigHwx89yhUEy9OfGuEN0b85jmBjCKvg6JncA4W/Nkn2rxZvEegGviqOPc1VMRqC1quKalTUFm4hO23EuquPK2nrfScs17kZ2ZTIU8SfS+1ZtW2pPnzfueiAT7cPMmDQIO4/ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755612278; c=relaxed/simple;
	bh=O/zIxb/LtS7f3pFioN3VNhzJ+ETV1lF+yqMMEWbQR2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SLxS54w1DDmgBulvpI11v0ecJ5W5gE+1Qf9lLaPT3V7d3TWbEljDznXPEpHE2qtwkZGxy6vIbHR+chKCJQiszbhopfXQlA33pPRKczsrhn8BQprwu8aZoszvnq7UYwYQIUKIBlUT7AYTl9kH49cAFOj2yPl0f4rye2FDJwXXmIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B3C816A3;
	Tue, 19 Aug 2025 07:04:26 -0700 (PDT)
Received: from [10.1.38.140] (unknown [10.1.38.140])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 185BB3F63F;
	Tue, 19 Aug 2025 07:04:33 -0700 (PDT)
Message-ID: <b6a51783-7867-46a7-90ab-7be69c7112a0@arm.com>
Date: Tue, 19 Aug 2025 15:04:32 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH] libtraceevent: Fix static library to hide hidden
 functions
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
 Douglas Raillard <douglas.raillard@arm.com>
References: <20250814144710.6c3458d4@gandalf.local.home>
 <c0d09a7e-c3a2-468d-a81d-cdef37f4c575@arm.com>
 <20250815132603.6b347952@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20250815132603.6b347952@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/08/2025 6:26 PM, Steven Rostedt wrote:
> On Fri, 15 Aug 2025 10:25:52 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
>>>     Care to test this?
>>
>> Hi Steven,
>>
>> I tried cherry-picking this patch on my stash (my HEAD is "b3f5849 -
>> libtraceevent: Save missed events in kbuffer_read_buffer()"), but it failed:
>>
>> error: patch failed: src/event-parse-local.h:111
>> error: src/event-parse-local.h: patch does not apply
>> error: patch failed: src/event-parse.c:8724
>> error: src/event-parse.c: patch does not apply
> 
> Doh!
> 
> 
>> BTW, this is how I build trace-cmd statically:
>>
>> TRACECMD_INSTALL_PATH="..."
>> export LDFLAGS="-static" NO_AUDIT=yes NO_PYTHON=yes CFLAGS="-O3"
>> make prefix=${TRACECMD_INSTALL_PATH}
>>
>> Reverting the changes in libtraceevent/src/Makefile resolves this build
>> failure, but I guess it's the whole point of this patch?
> 
> Right. I see the issue. So back to getting to my hack that appears to work.
> I decided to link all the objects together into a single object:
> 
>    ld -r -o libtraceevent-global.o $(OBJS)
> 
> And then use objcopy to make any functions that do not start with tep_ into
> a static function.
> 
> Can you test this? I only included the change to the Make file. To make
> sure it works, you still need to do the revert of your name change patch.
> 
> Thanks!
> 
> -- Steve
> 
> diff --git a/src/Makefile b/src/Makefile
> index 1ff669ce8deb..f8bea4520f58 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -19,7 +19,7 @@ DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
>   $(bdir)/%.o: %.c
>   	$(Q)$(call do_fpic_compile)
>   
> -$(LIBTRACEEVENT_STATIC): $(OBJS)
> +$(LIBTRACEEVENT_STATIC): $(bdir)/libtraceevent.o
>   	$(Q)$(call do_build_static_lib)
>   
>   $(LIBTRACEEVENT_SHARED): $(OBJS)
> @@ -31,6 +31,19 @@ $(LIBTRACEEVENT_SHARED_VERSION): $(LIBTRACEEVENT_SHARED)
>   $(LIBTRACEEVENT_SHARED_SO): $(LIBTRACEEVENT_SHARED_VERSION)
>   	@ln -sf $(<F) $@
>   
> +$(bdir)/libtraceevent-global.o: $(OBJS)
> +	ld -r -o $@ $^
> +
> +# Make all functions that do not start with tep_ to static
> +find_local = \
> +	 $(shell for f in a `nm $^ | grep ' T ' | cut -d' ' -f3`;  do \
> +	  if [ "$${f#tep_}" = "$$f" ]; then echo --localize-symbol $$f; fi; done)
> +
> +$(bdir)/libtraceevent.o: $(bdir)/libtraceevent-global.o
> +	objcopy $(call find_local) $< $@
> +
> +
> +
>   libtraceevent.so: $(LIBTRACEEVENT_SHARED_SO)
>   
>   libtraceevent: $(libtraceevent-y)

Reverted my name change patch and applied the hunk above to 
src/Makefile, but had to make the modifications below (the same change 
set I mentioned in my previous email) in libtraceevent to fix 
"/usr/bin/ld: /out/lib64/libtraceevent.so: undefined reference to 
`tep_{free,read}_token'" error during libtracefs build:

diff --git a/src/event-parse.c b/src/event-parse.c
index 9232f11..8daf91d 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3184,7 +3184,7 @@ process_int_dynamic_array(struct tep_event *event, 
struct tep_print_arg *arg, ch
  	 * The first item within the parenthesis is another field that holds
  	 * the index into where the array starts.
  	 */
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
  	if (type != TEP_EVENT_ITEM)
  		return TEP_EVENT_ERROR;

@@ -3213,7 +3213,7 @@ process_int_dynamic_array(struct tep_event *event, 
struct tep_print_arg *arg, ch

  	return read_token_item(event->tep, tok);
  out:
-	tep_free_token(token);
+	free_token(token);
  	*tok = NULL;
  	return TEP_EVENT_ERROR;
  }
@@ -3720,7 +3720,7 @@ process_function(struct tep_event *event, struct 
tep_print_arg *arg,
  		return process_int_array(event, arg, tok);
  	}
  	if (strcmp(token, "__print_dynamic_array") == 0) {
-		tep_free_token(token);
+		free_token(token);
  		return process_int_dynamic_array(event, arg, tok);
  	}
  	if (strcmp(token, "__get_str") == 0 ||


Now this is what I get when I try to build trace-cmd:

   BUILD                  trace-cmd
/usr/bin/ld: /out/lib64/libtraceevent.a(libtraceevent.o): in function 
`load_plugin':
/libtraceevent/src/event-plugin.c:459:(.text+0x1458c): warning: Using 
'dlopen' in statically linked applications requires at runtime the 
shared libraries from the glibc version used for linking
/usr/bin/ld: /trace-cmd/tracecmd/trace-setup-guest.o: in function 
`trace_setup_guest':
trace-setup-guest.c:(.text+0x5c8): warning: Using 'getgrnam' in 
statically linked applications requires at runtime the shared libraries 
from the glibc version used for linking
/usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
`record_trace.isra.0':
trace-record.c:(.text+0xe705): warning: Using 'initgroups' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
`do_getaddrinfo':
trace-record.c:(.text+0x865): warning: Using 'getaddrinfo' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
`record_trace.isra.0':
trace-record.c:(.text+0xe6ee): warning: Using 'getpwnam' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
`tracecmd_stat_cpu_instance':
trace-record.c:(.text+0x12ec): undefined reference to `trace_seq_printf'
/usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function `record_stats':
trace-record.c:(.text+0x1419): undefined reference to `trace_seq_init'
/usr/bin/ld: trace-record.c:(.text+0x1421): undefined reference to 
`trace_seq_init'
/usr/bin/ld: trace-record.c:(.text+0x1435): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x14c2): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x14e1): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x14ee): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-record.c:(.text+0x150e): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x1531): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x1569): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x15a1): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function `record_data':
trace-record.c:(.text+0x35e7): undefined reference to `trace_seq_init'
/usr/bin/ld: trace-record.c:(.text+0x3600): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x3623): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: trace-record.c:(.text+0x36cf): undefined reference to 
`trace_seq_do_printf'
/usr/bin/ld: trace-record.c:(.text+0x370b): undefined reference to 
`trace_seq_init'
/usr/bin/ld: trace-record.c:(.text+0x3744): undefined reference to 
`trace_seq_reset'
/usr/bin/ld: trace-record.c:(.text+0x3761): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x3794): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-record.c:(.text+0x37a2): undefined reference to 
`trace_seq_terminate'
/usr/bin/ld: trace-record.c:(.text+0x37d3): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: trace-record.c:(.text+0x3924): undefined reference to 
`trace_seq_do_printf'
/usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
`record_trace.isra.0':
trace-record.c:(.text+0xdf65): undefined reference to `trace_seq_do_printf'
/usr/bin/ld: trace-record.c:(.text+0xe02f): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: trace-record.c:(.text+0xe03e): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function 
`trace_extract':
trace-record.c:(.text+0x104b6): undefined reference to `trace_seq_destroy'
/usr/bin/ld: trace-record.c:(.text+0x104c5): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: /trace-cmd/tracecmd/trace-sqlhist.o: in function 
`trace_sqlhist':
trace-sqlhist.c:(.text+0x2e5): undefined reference to `trace_seq_init'
/usr/bin/ld: trace-sqlhist.c:(.text+0x3ae): undefined reference to 
`trace_seq_do_printf'
/usr/bin/ld: trace-sqlhist.c:(.text+0x3b6): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `update_page_info':
trace-input.c:(.text+0x15d7): undefined reference to 
`kbuffer_load_subbuffer'
/usr/bin/ld: trace-input.c:(.text+0x15df): undefined reference to 
`kbuffer_subbuffer_size'
/usr/bin/ld: trace-input.c:(.text+0x15ec): undefined reference to 
`kbuffer_timestamp'
/usr/bin/ld: trace-input.c:(.text+0x1639): undefined reference to 
`kbuffer_subbuffer_size'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `init_cpu_data':
trace-input.c:(.text+0x1c3a): undefined reference to `kbuffer_alloc'
/usr/bin/ld: trace-input.c:(.text+0x1c6b): undefined reference to 
`kbuffer_set_old_format'
/usr/bin/ld: trace-input.c:(.text+0x1ce9): undefined reference to 
`kbuffer_free'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_refresh_record':
trace-input.c:(.text+0x3bdb): undefined reference to 
`kbuffer_read_at_offset'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_get_cursor':
trace-input.c:(.text+0x41cd): undefined reference to `kbuffer_curr_offset'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_translate_data':
trace-input.c:(.text+0x425c): undefined reference to 
`kbuffer_translate_data'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_peek_data':
trace-input.c:(.text+0x437c): undefined reference to `kbuffer_read_event'
/usr/bin/ld: trace-input.c:(.text+0x4567): undefined reference to 
`kbuffer_curr_offset'
/usr/bin/ld: trace-input.c:(.text+0x459c): undefined reference to 
`kbuffer_event_size'
/usr/bin/ld: trace-input.c:(.text+0x45c9): undefined reference to 
`kbuffer_missed_events'
/usr/bin/ld: trace-input.c:(.text+0x45ee): undefined reference to 
`kbuffer_curr_size'
/usr/bin/ld: trace-input.c:(.text+0x4604): undefined reference to 
`kbuffer_next_event'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_make_pipe':
trace-input.c:(.text+0x5790): undefined reference to `kbuffer_alloc'
/usr/bin/ld: trace-input.c:(.text+0x582d): undefined reference to 
`kbuffer_set_old_format'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_close':
trace-input.c:(.text+0x626a): undefined reference to `kbuffer_free'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_record_at_buffer_start':
trace-input.c:(.text+0x69a6): undefined reference to `kbuffer_start_of_data'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_page_ts':
trace-input.c:(.text+0x69f2): undefined reference to 
`kbuffer_subbuf_timestamp'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in 
function `tracecmd_record_ts_delta':
trace-input.c:(.text+0x6a4c): undefined reference to `kbuffer_ptr_delta'
/usr/bin/ld: /trace-cmd/tracecmd/trace-read.o: in function `show_event_ts':
trace-read.c:(.text+0x4de): undefined reference to `trace_seq_init'
/usr/bin/ld: trace-read.c:(.text+0x516): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: /trace-cmd/tracecmd/trace-read.o: in function 
`trace_show_data':
trace-read.c:(.text+0x6fd): undefined reference to `trace_seq_init'
/usr/bin/ld: trace-read.c:(.text+0x816): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0x83c): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0x8a1): undefined reference to 
`trace_seq_do_printf'
/usr/bin/ld: trace-read.c:(.text+0x8a9): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: trace-read.c:(.text+0x930): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0x971): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0x9ca): undefined reference to 
`kbuffer_raw_get'
/usr/bin/ld: trace-read.c:(.text+0x9ea): undefined reference to 
`kbuffer_raw_get'
/usr/bin/ld: trace-read.c:(.text+0xa32): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xa62): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xa84): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xaa1): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xac0): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xad6): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-read.c:(.text+0xaf5): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xb32): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xb4d): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xb72): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-read.c:(.text+0xb8d): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: 
/trace-cmd/tracecmd/trace-read.o:trace-read.c:(.text+0xbad): more 
undefined references to `trace_seq_printf' follow
/usr/bin/ld: /trace-cmd/tracecmd/trace-profile.o: in function 
`sched_switch_print':
trace-profile.c:(.text+0xaa1): undefined reference to `trace_seq_putc'
/usr/bin/ld: trace-profile.c:(.text+0xab9): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-profile.c:(.text+0xad9): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-profile.c:(.text+0xaf1): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-profile.c:(.text+0xb09): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: 
/trace-cmd/tracecmd/trace-profile.o:trace-profile.c:(.text+0xb21): more 
undefined references to `trace_seq_putc' follow
/usr/bin/ld: /trace-cmd/tracecmd/trace-profile.o: in function 
`output_event':
trace-profile.c:(.text+0x2cb4): undefined reference to `trace_seq_init'
/usr/bin/ld: trace-profile.c:(.text+0x2cd2): undefined reference to 
`trace_seq_terminate'
/usr/bin/ld: trace-profile.c:(.text+0x2cf9): undefined reference to 
`trace_seq_destroy'
/usr/bin/ld: trace-profile.c:(.text+0x4f84): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-profile.c:(.text+0x50d9): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-profile.c:(.text+0x5284): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: /trace-cmd/tracecmd/trace-profile.o: in function 
`syscall_print':
trace-profile.c:(.text+0x1dd): undefined reference to `trace_seq_printf'
/usr/bin/ld: /trace-cmd/tracecmd/trace-profile.o: in function 
`softirq_print':
trace-profile.c:(.text+0x222): undefined reference to `trace_seq_printf'
/usr/bin/ld: 
/trace-cmd/tracecmd/trace-profile.o:trace-profile.c:(.text+0x23a): more 
undefined references to `trace_seq_printf' follow
/usr/bin/ld: /trace-cmd/tracecmd/trace-profile.o: in function 
`sched_switch_print':
trace-profile.c:(.text+0xa8f): undefined reference to `trace_seq_putc'
/usr/bin/ld: /trace-cmd/tracecmd/trace-profile.o: in function `func_print':
trace-profile.c:(.text+0xbcf): undefined reference to `trace_seq_printf'
/usr/bin/ld: trace-profile.c:(.text+0xbef): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: /trace-cmd/tracecmd/trace-list.o: in function `trace_option':
trace-list.c:(.text+0x1115): undefined reference to `trace_seq_init'
/usr/bin/ld: trace-list.c:(.text+0x1132): undefined reference to 
`trace_seq_do_printf'
/usr/bin/ld: /trace-cmd/tracecmd/trace-list.o: in function `trace_list':
trace-list.c:(.text+0x1792): undefined reference to `trace_seq_init'
/usr/bin/ld: trace-list.c:(.text+0x17af): undefined reference to 
`trace_seq_do_printf'
/usr/bin/ld: trace-list.c:(.text+0x17ed): undefined reference to 
`trace_seq_init'
/usr/bin/ld: trace-list.c:(.text+0x181b): undefined reference to 
`trace_seq_do_printf'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-ftrace.o): in 
function `function_handler':
trace-ftrace.c:(.text+0x73): undefined reference to `trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0xbc): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0xd1): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0x111): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x131): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-ftrace.o): in 
function `print_graph_duration':
trace-ftrace.c:(.text+0x1b0): undefined reference to `trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x211): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x226): undefined reference to 
`trace_seq_puts'
/usr/bin/ld: trace-ftrace.c:(.text+0x23c): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0x250): undefined reference to 
`trace_seq_puts'
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-ftrace.o): in 
function `fgraph_ent_handler':
trace-ftrace.c:(.text+0x383): undefined reference to `trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x392): undefined reference to 
`trace_seq_puts'
/usr/bin/ld: trace-ftrace.c:(.text+0x3dd): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0x440): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x46b): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x481): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0x4f9): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0x6ec): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x73d): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0x79c): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x80a): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x835): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x849): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0x866): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x881): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x897): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x8ad): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0x8c3): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: 
/trace-cmd/lib/trace-cmd/libtracecmd.a(trace-ftrace.o):trace-ftrace.c:(.text+0x8de): 
more undefined references to `trace_seq_printf' follow
/usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-ftrace.o): in 
function `fgraph_ret_handler':
trace-ftrace.c:(.text+0xa7d): undefined reference to `trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0xa95): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0xb05): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0xb19): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: trace-ftrace.c:(.text+0xbdc): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0xbfa): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0xc15): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0xc2d): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: trace-ftrace.c:(.text+0xc4d): undefined reference to 
`trace_seq_printf'
/usr/bin/ld: 
/trace-cmd/lib/trace-cmd/libtracecmd.a(trace-ftrace.o):trace-ftrace.c:(.text+0xc6d): 
more undefined references to `trace_seq_printf' follow
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-instance.o): in function 
`tracefs_instance_set_affinity_set':
/libtracefs/src/tracefs-instance.c:954:(.text+0x183d): undefined 
reference to `trace_seq_init'
/usr/bin/ld: /libtracefs/src/tracefs-instance.c:995:(.text+0x1a49): 
undefined reference to `trace_seq_printf'
/usr/bin/ld: /libtracefs/src/tracefs-instance.c:999:(.text+0x1a7b): 
undefined reference to `trace_seq_putc'
/usr/bin/ld: /libtracefs/src/tracefs-instance.c:1006:(.text+0x1ab1): 
undefined reference to `trace_seq_terminate'
/usr/bin/ld: /libtracefs/src/tracefs-instance.c:1009:(.text+0x1adc): 
undefined reference to `trace_seq_destroy'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-events.o): in function 
`read_kbuf_record':
/libtracefs/src/tracefs-events.c:44:(.text+0x50): undefined reference to 
`kbuffer_read_event'
/usr/bin/ld: /libtracefs/src/tracefs-events.c:50:(.text+0x9b): undefined 
reference to `kbuffer_event_size'
/usr/bin/ld: /libtracefs/src/tracefs-events.c:51:(.text+0xb2): undefined 
reference to `kbuffer_curr_size'
/usr/bin/ld: /libtracefs/src/tracefs-events.c:52:(.text+0xc9): undefined 
reference to `kbuffer_missed_events'
/usr/bin/ld: /libtracefs/src/tracefs-events.c:57:(.text+0x10e): 
undefined reference to `kbuffer_next_event'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-hist.o): in function 
`add_list':
/libtracefs/src/tracefs-hist.c:83:(.text+0x93): undefined reference to 
`trace_seq_puts'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:86:(.text+0xb3): undefined 
reference to `trace_seq_putc'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:87:(.text+0xd9): undefined 
reference to `trace_seq_puts'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-hist.o): in function 
`add_hist_commands':
/libtracefs/src/tracefs-hist.c:95:(.text+0x12b): undefined reference to 
`trace_seq_putc'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:106:(.text+0x1cc): undefined 
reference to `trace_seq_printf'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:110:(.text+0x208): undefined 
reference to `trace_seq_puts'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:111:(.text+0x220): undefined 
reference to `trace_seq_puts'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:112:(.text+0x238): undefined 
reference to `trace_seq_puts'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:117:(.text+0x26e): undefined 
reference to `trace_seq_printf'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:120:(.text+0x29e): undefined 
reference to `trace_seq_printf'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-hist.o): in function 
`tracefs_hist_echo_cmd':
/libtracefs/src/tracefs-hist.c:153:(.text+0x339): undefined reference to 
`trace_seq_puts'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:157:(.text+0x36e): undefined 
reference to `trace_seq_printf'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-hist.o): in function 
`tracefs_hist_command':
/libtracefs/src/tracefs-hist.c:190:(.text+0x419): undefined reference to 
`trace_seq_init'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:194:(.text+0x440): undefined 
reference to `trace_seq_putc'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:195:(.text+0x44c): undefined 
reference to `trace_seq_terminate'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:202:(.text+0x48b): undefined 
reference to `trace_seq_destroy'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-hist.o): in function 
`tracefs_synth_raw_fmt':
/libtracefs/src/tracefs-hist.c:2112:(.text+0x3cfb): undefined reference 
to `trace_seq_printf'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:2113:(.text+0x3d21): 
undefined reference to `trace_seq_printf'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:2114:(.text+0x3d47): 
undefined reference to `trace_seq_printf'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-hist.o): in function 
`tracefs_synth_echo_cmd':
/libtracefs/src/tracefs-hist.c:2473:(.text+0x4746): undefined reference 
to `trace_seq_printf'
/usr/bin/ld: /libtracefs/src/tracefs-hist.c:2488:(.text+0x47ff): 
undefined reference to `trace_seq_printf'
/usr/bin/ld: 
/out/lib64/libtracefs.a(tracefs-hist.o):/libtracefs/src/tracefs-hist.c:2498: 
more undefined references to `trace_seq_printf' follow
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-record.o): in function 
`tracefs_cpu_free_fd':
/libtracefs/src/tracefs-record.c:280:(.text+0x4f1): undefined reference 
to `kbuffer_free'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-record.o): in function 
`tracefs_cpu_read_buf':
/libtracefs/src/tracefs-record.c:539:(.text+0xc41): undefined reference 
to `kbuffer_load_subbuffer'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-record.o): in function 
`tracefs_cpu_buffered_read_buf':
/libtracefs/src/tracefs-record.c:680:(.text+0xfb9): undefined reference 
to `kbuffer_load_subbuffer'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-record.o): in function 
`tracefs_cpu_flush_buf':
/libtracefs/src/tracefs-record.c:799:(.text+0x1253): undefined reference 
to `kbuffer_load_subbuffer'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-mmap.o): in function 
`tfs_mmap':
/libtracefs/src/tracefs-mmap.c:92:(.text+0xa9): undefined reference to 
`kbuffer_dup'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:108:(.text+0x176): undefined 
reference to `kbuffer_free'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:123:(.text+0x23e): undefined 
reference to `kbuffer_free'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:131:(.text+0x29f): undefined 
reference to `kbuffer_load_subbuffer'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:138:(.text+0x2c3): undefined 
reference to `kbuffer_start_of_data'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:140:(.text+0x373): undefined 
reference to `kbuffer_read_buffer'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-mmap.o): in function 
`tfs_unmap':
/libtracefs/src/tracefs-mmap.c:155:(.text+0x3fc): undefined reference to 
`kbuffer_free'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-mmap.o): in function 
`tfs_mmap_load_subbuf':
/libtracefs/src/tracefs-mmap.c:180:(.text+0x4ae): undefined reference to 
`kbuffer_subbuffer'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:181:(.text+0x4cb): undefined 
reference to `kbuffer_load_subbuffer'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:183:(.text+0x4db): undefined 
reference to `kbuffer_curr_index'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:184:(.text+0x4f9): undefined 
reference to `kbuffer_curr_offset'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:186:(.text+0x59b): undefined 
reference to `kbuffer_read_buffer'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:195:(.text+0x5b4): undefined 
reference to `kbuffer_refresh'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:198:(.text+0x5c0): undefined 
reference to `kbuffer_curr_size'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:200:(.text+0x5d0): undefined 
reference to `kbuffer_curr_offset'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:200:(.text+0x5de): undefined 
reference to `kbuffer_curr_size'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:218:(.text+0x65f): undefined 
reference to `kbuffer_subbuffer'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:221:(.text+0x67f): undefined 
reference to `kbuffer_load_subbuffer'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-mmap.o): in function 
`tfs_mmap_read':
/libtracefs/src/tracefs-mmap.c:242:(.text+0x714): undefined reference to 
`kbuffer_read_buffer'
/usr/bin/ld: /libtracefs/src/tracefs-mmap.c:247:(.text+0x72e): undefined 
reference to `kbuffer_start_of_data'
/usr/bin/ld: /out/lib64/libtracefs.a(tracefs-sqlhist.o): in function 
`tfs_sql_parse_error':
/libtracefs/src/tracefs-sqlhist.c:151:(.text+0x133): undefined reference 
to `trace_seq_init'
/usr/bin/ld: /libtracefs/src/tracefs-sqlhist.c:162:(.text+0x1b7): 
undefined reference to `trace_seq_putc'
/usr/bin/ld: /libtracefs/src/tracefs-sqlhist.c:163:(.text+0x1f4): 
undefined reference to `trace_seq_putc'
/usr/bin/ld: /libtracefs/src/tracefs-sqlhist.c:165:(.text+0x20d): 
undefined reference to `trace_seq_putc'
/usr/bin/ld: /libtracefs/src/tracefs-sqlhist.c:166:(.text+0x22d): 
undefined reference to `trace_seq_puts'
/usr/bin/ld: /libtracefs/src/tracefs-sqlhist.c:167:(.text+0x24c): 
undefined reference to `trace_seq_printf'
/usr/bin/ld: /libtracefs/src/tracefs-sqlhist.c:168:(.text+0x263): 
undefined reference to `trace_seq_vprintf'
/usr/bin/ld: /libtracefs/src/tracefs-sqlhist.c:170:(.text+0x26f): 
undefined reference to `trace_seq_terminate'
/usr/bin/ld: /libtracefs/src/tracefs-sqlhist.c:173:(.text+0x292): 
undefined reference to `trace_seq_destroy'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:76: /trace-cmd/tracecmd/trace-cmd] Error 1
make: *** [Makefile:405: trace-cmd] Error 2

