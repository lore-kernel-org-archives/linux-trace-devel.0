Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577EB31A069
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Dec 2025 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767108599; cv=none; b=jtvRgOZYtboAUfsv+oGgQnhaeT4trQIV3YzaT8ZH2THaZH0N9MZaCARWbEDuhNv411F4St+T950Y3LdeiQi7mtshlw/WdtZ1idVI4245gI+6bWQDVxUxGar78Ez4zmLsojeJEcVOKOZLs0d4uQNpEbuxgkLx/C2740ugvhI714s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767108599; c=relaxed/simple;
	bh=+ljfWNsjDTIhlXECYVqHvOfY6Fsd7z1cOuB0JMdy5AM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=UT/DTfYOK0o0R0yoG5/WRfzKGuh9bs/SsX2m1RzBfdOWpmxD/nU6yOdSzVAq32swOWEnwL5fqU/1K9dxQAb+qDrXBK6X/bIWkQJ/MqbC/X5ReFO5UDCZrnwawjvLNEVHQ2GlSfiDhghSV1XJyDuCcrgS6hqTuSx0l89Q6yIMPC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD8D057343;
	Tue, 30 Dec 2025 15:29:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 2AB9320029;
	Tue, 30 Dec 2025 15:29:53 +0000 (UTC)
Date: Tue, 30 Dec 2025 10:30:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Vitaly Chikunov <vt@altlinux.org>, Douglas Raillard
 <douglas.raillard@arm.com>, Metin Kaya <metin.kaya@arm.com>
Subject: [PATCH] libtraceevent: Do not change names of functions not of this
  library
Message-ID: <20251230103000.30be6e94@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xtkdaxffbtd34g1c57xko3qh5ptnax4f
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 2AB9320029
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/9gll6v0kY333GY6wfB72n3WrwEFNnWI0=
X-HE-Tag: 1767108593-83633
X-HE-Meta: U2FsdGVkX19J6LTi8P7sGQP0B0uRO9QBr0OaPZXG8K1IzrayEhy+2fwAghzSfSzITZ8HemMStlMQCF4vQS0JH/wPzh3Acq8VTb6ePTWXD3SjkQDcblEkx2gy+ZXSW5c4KBZcX5ef9FN7pGS/Ejyjg25WcxVD3+0JkPeck2PMdvR/zDdZMPoHenz135irpBHrUcNQhg52l8mOFq6w0VH0MYxVdUWSMD2GQ1QT91fDe5GD03QepSRXPbXoX3GjyFkwjib7+PgdrAa1WShoFDvABTCgWgRqY6GGiPaSK7GORJbYdSdClIDFn1zfSUxBvErIe4E2ZPxlteJ3r34DFEubBC3kUL9rsrKp3XxfuPC9oZV/SqEk9EEQEwyJiueQC75aouwHxZLnx2wf4GKwQlVOz6qe8MwAYcw2WvkvFEIPbuw+Amq8d4oQS+iFvht/aVheIdUZX47wsXICIk8lGNEC8Ow8EFAJvwsp9/s29R1jwto=

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The hidden attribute is used for functions within the library that are
not to be exported. They do not have name space naming which is not a
problem for the shared library, because the hidden attribute hides them
from being linked.

But these functions are not protected by the hidden attribute for the
static library. The build was modified to run 'nm' on the shared library
and any hidden function found that does not start with 'tep_' would have
its name changed to 'tep_local_<name>'.

A problem occurred where on x86_32 systems, gcc adds other functions like:

  __stack_chk_fail_local
  __udivdi3
  __umoddi

and these too were converted. But by doing so, it caused the "make test"
build to fail (make test uses the static library):

  /usr/bin/ld: lib/libtraceevent.a(event-parse.o): in function `consolidate_op_arg':
  src/event-parse.c:2302: undefined reference to `_tep_local___udivdi3'
  /usr/bin/ld: src/event-parse.c:2305: undefined reference to `_tep_local___umoddi3'
  /usr/bin/ld: lib/libtraceevent.a(event-parse.o): in function `eval_num_arg':
  src/event-parse.c:4561: undefined reference to `_tep_local___udivdi3'
  /usr/bin/ld: src/event-parse.c:4564: undefined reference to `_tep_local___umoddi3'
  /usr/bin/ld: lib/libtraceevent.a(event-parse.o): in function `print_event_time':
  src/event-parse.c:7168: undefined reference to `_tep_local___udivdi3'
  /usr/bin/ld: src/event-parse.c:7175: undefined reference to `_tep_local___umoddi3'
  /usr/bin/ld: src/event-parse.c:7175: undefined reference to `_tep_local___udivdi3'
  collect2: error: ld returned 1 exit status
  make[1]: *** [Makefile:22: utest/trace-utest] Error 1
  make: *** [Makefile:258: test] Error 2

Read the 'nm' symbols of the temporary static library and record only the
functions that have an address. As the above gcc functions are still
undefined there. Then this will only convert functions that are defined by
the static library and not added by the compiler.

Also add the missing .gitignore file to hide these temp files.

Reported-by: Vitaly Chikunov <vt@altlinux.org>
Closes: https://lore.kernel.org/all/d3ozbooqkmvjf4rnyklwvdvc7h@altlinux.org/
Fixes: 399f8462ff1b1 ("libtraceevent: Have static library to hide hidden functions")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 scripts/utils.mk | 4 ++--
 src/.gitignore   | 2 ++
 src/Makefile     | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)
 create mode 100644 src/.gitignore

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 7cd7355b811f..381e5430e97e 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -183,5 +183,5 @@ endef
 
 # Make all global functions that do not start with "tep_" have a unique name.
 redefine_local = \
-	$(shell for f in a `nm $(1) 2>/dev/null | grep ' t ' | cut -d' ' -f3 | sort -u`;  do \
-	 if [ "$${f#tep_}" = "$$f" ]; then echo --redefine-sym $$f=_tep_local_$$f; fi; done)
+	$(shell nm $(2) 2>/dev/null | grep '[0-9a-f] t ' > .tmp.func-list; for f in a `nm $(1) 2>/dev/null | grep ' t ' | cut -d' ' -f3 | sort -u`;  do \
+	 if [ "$${f#tep_}" = "$$f" ]; then if grep -q $$f .tmp.func-list; then echo --redefine-sym $$f=_tep_local_$$f; fi; fi; done)
diff --git a/src/.gitignore b/src/.gitignore
new file mode 100644
index 000000000000..f5735328db43
--- /dev/null
+++ b/src/.gitignore
@@ -0,0 +1,2 @@
+.tmp.libtraceevent.a
+.tmp.func-list
diff --git a/src/Makefile b/src/Makefile
index 4f16b81bb989..e6ece616e5d4 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -20,7 +20,7 @@ $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
 $(LIBTRACEEVENT_STATIC): $(bdir)/.tmp.libtraceevent.a $(LIBTRACEEVENT_SHARED)
-	$(Q)objcopy $(call redefine_local,${LIBTRACEEVENT_SHARED}) $< $@
+	$(Q)objcopy $(call redefine_local,${LIBTRACEEVENT_SHARED},$<) $< $@
 
 $(bdir)/.tmp.libtraceevent.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
@@ -49,7 +49,7 @@ $(DEPS): | $(bdir)
 
 clean:
 	$(Q)$(call do_clean,$(OBJS) $(DEPS) $(bdir)/libtraceevent.o \
-	                    $(bdir)/.tmp.libtraceevent.a)
+	                    $(bdir)/.tmp.libtraceevent.a $(bdir)/.tmp.func-list)
 
 dep_includes := $(wildcard $(DEPS))
 
-- 
2.51.0

