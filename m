Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC89A30F54F
	for <linux-trace-devel@vger.kernel.org>; Fri, 15 Aug 2025 17:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755278716; cv=none; b=R25yoaVc95Ldgir8K+o/Rc173/lwLwogacCWUZZ/3G0BilO0FTAmdVSTvH2O1emUA1qBNieE3ePtmq/gtYuzMMFO1k1JDJj00CYdO4xetV/WkStD63KZ7qjcv8iY0+dOw/gGYEJZhRpcH/ifQ3u0kEY3SeA/xiFC1Fp6Kw9otyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755278716; c=relaxed/simple;
	bh=zceEBXm4E7Js38VkXG2qo3JX16fXJpJtYRNzINLLQI0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WiE5YD86Hwauu6Y3pzWuUnCYSjoiaTmDTxftqgivXA8fg+Gk44+yDpIZy/37Tlyw+o5U5ru7aMflrAe3lJVBxjpr9SiDllqOYFvEtM5eg0FNTrF7WQ+TJQ3NPdSJhzv7ZdR+tXTlNbqjHruT0XMUF4rh1KvWfc+HP8AEeIhO4EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5BD71A022F;
	Fri, 15 Aug 2025 17:25:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 47D7217;
	Fri, 15 Aug 2025 17:25:11 +0000 (UTC)
Date: Fri, 15 Aug 2025 13:26:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Douglas Raillard
 <douglas.raillard@arm.com>
Subject: Re: [RFC][PATCH] libtraceevent: Fix static library to hide hidden
 functions
Message-ID: <20250815132603.6b347952@gandalf.local.home>
In-Reply-To: <c0d09a7e-c3a2-468d-a81d-cdef37f4c575@arm.com>
References: <20250814144710.6c3458d4@gandalf.local.home>
	<c0d09a7e-c3a2-468d-a81d-cdef37f4c575@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 47D7217
X-Stat-Signature: adamszxwx5hkbdj76s7cwko6wypxz7p1
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX183hJWLE/2C5eglLK3JGbznUAhmeJFtpGE=
X-HE-Tag: 1755278711-731742
X-HE-Meta: U2FsdGVkX19k93mEZvl61X6O6gGXeVKzIVF1qSLc+icsJenPkL1bCTtt1tfY6/dtGCu+NELe1wBq+gwtwBOVFXZFKQ20lgTn4BiBRnP9HhYEAnn1+zyFcmQUwTKTuwERS9ZdGr/K7vIAvsj3cUuFHr06vRVWJPOpaAqHAJ5O3AT1j6FhGZ5SIfbSsZz0lpRhRLL2Z0eqsmZQr7iApO3chseTOZZNNN4qEA4cVtF708f99N5hXbvdk7rSohYxybcGN5XfhPHvzqmbOI/64LCeGgoLVW8LWh2W3R39oxcF6HY369/vYnDTKS0wbNnelJ9UZUdeDtPY1DPWVO5d948G0KCh272rDobKITt6W3ILbNaq1fl4uXeDhcL6lqCVEWm6

On Fri, 15 Aug 2025 10:25:52 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> >    Care to test this?  
> 
> Hi Steven,
> 
> I tried cherry-picking this patch on my stash (my HEAD is "b3f5849 - 
> libtraceevent: Save missed events in kbuffer_read_buffer()"), but it failed:
> 
> error: patch failed: src/event-parse-local.h:111
> error: src/event-parse-local.h: patch does not apply
> error: patch failed: src/event-parse.c:8724
> error: src/event-parse.c: patch does not apply

Doh!


> BTW, this is how I build trace-cmd statically:
> 
> TRACECMD_INSTALL_PATH="..."
> export LDFLAGS="-static" NO_AUDIT=yes NO_PYTHON=yes CFLAGS="-O3"
> make prefix=${TRACECMD_INSTALL_PATH}
> 
> Reverting the changes in libtraceevent/src/Makefile resolves this build 
> failure, but I guess it's the whole point of this patch?

Right. I see the issue. So back to getting to my hack that appears to work.
I decided to link all the objects together into a single object:

  ld -r -o libtraceevent-global.o $(OBJS)

And then use objcopy to make any functions that do not start with tep_ into
a static function.

Can you test this? I only included the change to the Make file. To make
sure it works, you still need to do the revert of your name change patch.

Thanks!

-- Steve

diff --git a/src/Makefile b/src/Makefile
index 1ff669ce8deb..f8bea4520f58 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -19,7 +19,7 @@ DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-$(LIBTRACEEVENT_STATIC): $(OBJS)
+$(LIBTRACEEVENT_STATIC): $(bdir)/libtraceevent.o
 	$(Q)$(call do_build_static_lib)
 
 $(LIBTRACEEVENT_SHARED): $(OBJS)
@@ -31,6 +31,19 @@ $(LIBTRACEEVENT_SHARED_VERSION): $(LIBTRACEEVENT_SHARED)
 $(LIBTRACEEVENT_SHARED_SO): $(LIBTRACEEVENT_SHARED_VERSION)
 	@ln -sf $(<F) $@
 
+$(bdir)/libtraceevent-global.o: $(OBJS)
+	ld -r -o $@ $^
+
+# Make all functions that do not start with tep_ to static
+find_local = \
+	 $(shell for f in a `nm $^ | grep ' T ' | cut -d' ' -f3`;  do \
+	  if [ "$${f#tep_}" = "$$f" ]; then echo --localize-symbol $$f; fi; done)
+
+$(bdir)/libtraceevent.o: $(bdir)/libtraceevent-global.o
+	objcopy $(call find_local) $< $@
+
+
+
 libtraceevent.so: $(LIBTRACEEVENT_SHARED_SO)
 
 libtraceevent: $(libtraceevent-y)
