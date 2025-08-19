Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782812848AA
	for <linux-trace-devel@vger.kernel.org>; Tue, 19 Aug 2025 20:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755633914; cv=none; b=PG2vK1JEFQFZ2vNs2EDxp5xrfUi4EoTLhCN2wEM1prbmXtPJoWfgT9BcPzQkOEZdPjnK2dr6+JyITfd/5jj1cCE6KzeMsRCGy3bypBLIE/C4j5IB5j8MZjK81U5iU8EtZH+kvRd2sgJ14udYQG3A0Z4RSTiTLed5tFGXwPdvEDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755633914; c=relaxed/simple;
	bh=o7dUFsawiu51q/92tJBl89iv0S/JTFdPdx4QERVmVUo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EtBSjrrHXeyjZvsjeGfzpGppyamCDJVCjHgbJviMbrEI9MrZi9X1vBZxT3Vp0oc+++ppAirtkilRZryyeWFPgs9a7yUcgxyHPxtw31Brgq3wb8dKE5iM5Vlml8zZy5qcstT/9406BpVPkXt+nNAiykhQU9QvfmtoNUKL+zSp3LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93BA1C021A;
	Tue, 19 Aug 2025 20:05:05 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id F222120025;
	Tue, 19 Aug 2025 20:05:03 +0000 (UTC)
Date: Tue, 19 Aug 2025 16:05:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Douglas Raillard
 <douglas.raillard@arm.com>
Subject: Re: [RFC][PATCH] libtraceevent: Fix static library to hide hidden
 functions
Message-ID: <20250819160504.3fa6819d@gandalf.local.home>
In-Reply-To: <20250819155617.73f91fd6@gandalf.local.home>
References: <20250814144710.6c3458d4@gandalf.local.home>
	<c0d09a7e-c3a2-468d-a81d-cdef37f4c575@arm.com>
	<20250815132603.6b347952@gandalf.local.home>
	<b6a51783-7867-46a7-90ab-7be69c7112a0@arm.com>
	<20250819155617.73f91fd6@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wzjnsqgqkptozkz9mqfbhddcrdna999s
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: F222120025
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+8G4htOVxkCuNYDCyZiLnWvr9Rz+1PA04=
X-HE-Tag: 1755633903-301395
X-HE-Meta: U2FsdGVkX18YYC4Ha8dZ76c1wQnpH+iQ8wWZRdwyCNEt6c+kBCs4dfkeqguakArXJ9LoUUgLeLi9Laq2C1wBZxYMuznU9rQTFeLTcgrQ12VgbtlJb+0vAK/LtMIUKjPwE0fyyxtpxhPeWPckpcYMtcR/R+66Be3SS/wea3tMhGJ5GLUgZBjxp5M9PFqwPQgNB4UuJOXAr6G9XJ7jluKAh58/Pobiy1yeqmdHuJUIraKlK+pPF7K1SRpFuOwVm400c6Zv3vfsTdl26TShaH3V3A2mXMu3S3t8TuwBtWvV5RBdzPu3MRGkqQhC8FrD1eok7TW7xipyDiURD2sBQ6mB5HYLilkOsakPqjwyfL8726GCuaW+nzC+Ti9aZKic/owe

On Tue, 19 Aug 2025 15:56:17 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Oops, I forgot that trace_seq* and kbuffer_* are also supplied. I made
> everything that didn't start with 'tep_*' "static". I could add kbuffer_*
> and trace_seq_* to that list (the easy way out), or I can parse
> `nm libtraceevent.so` and convert everything that's static in it to static
> in the static library.

Actually, this was easier than I though!

diff --git a/src/Makefile b/src/Makefile
index a8e9bfadfda5..dcbca123ecca 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -19,7 +19,7 @@ DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-$(LIBTRACEEVENT_STATIC): $(LIBTRACEEVENT_SHARED)
+$(LIBTRACEEVENT_STATIC): $(bdir)/libtraceevent.o
 	$(Q)$(call do_build_static_lib)
 
 $(LIBTRACEEVENT_SHARED): $(OBJS)
@@ -31,6 +31,17 @@ $(LIBTRACEEVENT_SHARED_VERSION): $(LIBTRACEEVENT_SHARED)
 $(LIBTRACEEVENT_SHARED_SO): $(LIBTRACEEVENT_SHARED_VERSION)
 	@ln -sf $(<F) $@
 
+$(bdir)/libtraceevent-global.o: $(OBJS)
+	ld -r -o $@ $^
+
+# Make static library match dynamic library wrt hidden functions
+find_local = \
+	$(shell for f in a `nm ${LIBTRACEEVENT_SHARED} | grep ' t ' | cut -d' ' -f3`;  do \
+	 if [ "$${f#tep_}" = "$$f" ]; then echo --localize-symbol $$f; fi; done)
+
+$(bdir)/libtraceevent.o: ${LIBTRACEEVENT_SHARED} $(bdir)/libtraceevent-global.o
+	objcopy $(call find_local) $< $@
+
 libtraceevent.so: $(LIBTRACEEVENT_SHARED_SO)
 
 libtraceevent: $(libtraceevent-y)
@@ -45,7 +56,7 @@ $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
 clean:
-	$(Q)$(call do_clean,$(OBJS) $(DEPS))
+	$(Q)$(call do_clean,$(OBJS) $(DEPS) $(bdir)libtraceevent.o)
 
 dep_includes := $(wildcard $(DEPS))
 


-- Steve
