Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED271A08A3
	for <linux-trace-devel@vger.kernel.org>; Wed, 20 Aug 2025 10:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755686401; cv=none; b=Rg12cj4DgFo/myDlyXOrjnA2X9RktF4Tl+hr5IJebG7kHBhg0Yfl66Xn3ODVxIRVtjo8WSnnF4Khzwor8WJl/Udk4UfAMuD6IUt28ZKqyJaLgC2zA4oqnfgYz3jywJJ74KAa6jtLiiulL0bNgELsyP/u8InHgVaD+8Uems31/s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755686401; c=relaxed/simple;
	bh=kMgsVqtmJ7jG0tA9DcPq36oayh//bw9bW9jlAht2G34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h1SskOGqLp7nCKYfnyeBp+Aovb6Wt33lb9Tez3NJNuooTJIQgIV2d7Zos90tkNu+exPBgh3qtcuT9iVuS8ug9Z5zLspv8aZ48Wja2a6E59HZDWyvJUsFnNeegje+qqBKs26Itl+n5BWVeG8HHrys2z+Z2cyPKypR9L/LXHor/PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CCF1152B;
	Wed, 20 Aug 2025 03:39:49 -0700 (PDT)
Received: from [10.1.33.184] (MetinsMBPArm.cambridge.arm.com [10.1.33.184])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2836F3F63F;
	Wed, 20 Aug 2025 03:39:57 -0700 (PDT)
Message-ID: <72f98feb-6688-42dc-8d3e-50483505432d@arm.com>
Date: Wed, 20 Aug 2025 11:39:55 +0100
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
 <b6a51783-7867-46a7-90ab-7be69c7112a0@arm.com>
 <20250819155617.73f91fd6@gandalf.local.home>
 <20250819160504.3fa6819d@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20250819160504.3fa6819d@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/08/2025 9:05 PM, Steven Rostedt wrote:
> On Tue, 19 Aug 2025 15:56:17 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> Oops, I forgot that trace_seq* and kbuffer_* are also supplied. I made
>> everything that didn't start with 'tep_*' "static". I could add kbuffer_*
>> and trace_seq_* to that list (the easy way out), or I can parse
>> `nm libtraceevent.so` and convert everything that's static in it to static
>> in the static library.
> 
> Actually, this was easier than I though!
> 
> diff --git a/src/Makefile b/src/Makefile
> index a8e9bfadfda5..dcbca123ecca 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -19,7 +19,7 @@ DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
>   $(bdir)/%.o: %.c
>   	$(Q)$(call do_fpic_compile)
>   
> -$(LIBTRACEEVENT_STATIC): $(LIBTRACEEVENT_SHARED)
> +$(LIBTRACEEVENT_STATIC): $(bdir)/libtraceevent.o
>   	$(Q)$(call do_build_static_lib)
>   
>   $(LIBTRACEEVENT_SHARED): $(OBJS)
> @@ -31,6 +31,17 @@ $(LIBTRACEEVENT_SHARED_VERSION): $(LIBTRACEEVENT_SHARED)
>   $(LIBTRACEEVENT_SHARED_SO): $(LIBTRACEEVENT_SHARED_VERSION)
>   	@ln -sf $(<F) $@
>   
> +$(bdir)/libtraceevent-global.o: $(OBJS)
> +	ld -r -o $@ $^
> +
> +# Make static library match dynamic library wrt hidden functions
> +find_local = \
> +	$(shell for f in a `nm ${LIBTRACEEVENT_SHARED} | grep ' t ' | cut -d' ' -f3`;  do \
> +	 if [ "$${f#tep_}" = "$$f" ]; then echo --localize-symbol $$f; fi; done)
> +
> +$(bdir)/libtraceevent.o: ${LIBTRACEEVENT_SHARED} $(bdir)/libtraceevent-global.o
> +	objcopy $(call find_local) $< $@
> +
>   libtraceevent.so: $(LIBTRACEEVENT_SHARED_SO)
>   
>   libtraceevent: $(libtraceevent-y)
> @@ -45,7 +56,7 @@ $(OBJS): | $(bdir)
>   $(DEPS): | $(bdir)
>   
>   clean:
> -	$(Q)$(call do_clean,$(OBJS) $(DEPS))
> +	$(Q)$(call do_clean,$(OBJS) $(DEPS) $(bdir)libtraceevent.o)
>   
>   dep_includes := $(wildcard $(DEPS))
>   
> 
> 
> -- Steve

The last error is new:

   BUILD                  trace-cmd
/usr/bin/ld: /ssd/tracecmd-work/trace-cmd/tracecmd/trace-setup-guest.o: 
in function `trace_setup_guest':
trace-setup-guest.c:(.text+0x5c8): warning: Using 'getgrnam' in 
statically linked applications requires at runtime the shared libraries 
from the glibc version used for linking
/usr/bin/ld: /ssd/tracecmd-work/trace-cmd/tracecmd/trace-record.o: in 
function `record_trace.isra.0':
trace-record.c:(.text+0xe705): warning: Using 'initgroups' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: /ssd/tracecmd-work/trace-cmd/tracecmd/trace-record.o: in 
function `do_getaddrinfo':
trace-record.c:(.text+0x865): warning: Using 'getaddrinfo' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: /ssd/tracecmd-work/trace-cmd/tracecmd/trace-record.o: in 
function `record_trace.isra.0':
trace-record.c:(.text+0xe6ee): warning: Using 'getpwnam' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: attempted static link of dynamic object 
`/ssd/tracecmd-work/out/lib64/libtraceevent.a(libtraceevent.o)'

I've updated your patch. This version works fine:

diff --git a/src/Makefile b/src/Makefile
index 53bb570..3b2d10f 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
  $(bdir)/%.o: %.c
  	$(Q)$(call do_fpic_compile)

-$(LIBTRACEEVENT_STATIC): $(OBJS)
+$(LIBTRACEEVENT_STATIC): $(bdir)/libtraceevent.o
  	$(Q)$(call do_build_static_lib)

  $(LIBTRACEEVENT_SHARED): $(OBJS)
@@ -30,6 +30,20 @@ $(LIBTRACEEVENT_SHARED_VERSION): $(LIBTRACEEVENT_SHARED)
  $(LIBTRACEEVENT_SHARED_SO): $(LIBTRACEEVENT_SHARED_VERSION)
  	@ln -sf $(<F) $@

+$(bdir)/libtraceevent-global.o: $(OBJS)
+	$(Q)ld -r -o $@ $^
+
+# Make static library match dynamic library wrt hidden functions
+find_local = \
+	$(shell for f in a `nm  $(bdir)/libtraceevent-global.o | grep ' t ' | 
cut -d' ' -f3`; do \
+	 if [ "$${f#tep_}" = "$$f" ] && [ "$${f#trace_seq_}" = "$$f" ] && [ 
"$${f#kbuffer_}" = "$$f" ]; then \
+		echo --localize-symbol $$f; \
+	 fi; \
+	 done)
+
+$(bdir)/libtraceevent.o: $(bdir)/libtraceevent-global.o
+	$(Q)objcopy $(call find_local) $< $@
+
  libtraceevent.so: $(LIBTRACEEVENT_SHARED_SO)

  libtraceevent: $(libtraceevent-y)
@@ -44,7 +58,7 @@ $(OBJS): | $(bdir)
  $(DEPS): | $(bdir)

  clean:
-	$(Q)$(call do_clean,$(OBJS) $(DEPS))
+	$(Q)$(call do_clean,$(OBJS) $(DEPS) $(bdir)/libtraceevent-global.o 
$(bdir)/libtraceevent.o)

  dep_includes := $(wildcard $(DEPS))

Note that I also have this change in my stash in addition to reverting 
name change patch:

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

Thanks,
