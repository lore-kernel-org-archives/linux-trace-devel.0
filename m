Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F33276046
	for <linux-trace-devel@vger.kernel.org>; Tue,  2 Dec 2025 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764692691; cv=none; b=KJm+xO2hIg7KTp6pnA/4ZQeXGyNxIgzV3Ws92zQF3zHUtWHICHNB5UC23DcNHHAweq9CH1E7Ba94GSl5CrJTtSMq3dKKnAxhyzp45AWtTGidC0tZWj3LMIDUyC8QiYicd8SezTdYk9C9Qvp3CvYYTK4HTmCunhrySduPXNwnA8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764692691; c=relaxed/simple;
	bh=Y5gOwBjXYIC9L/OIdhc64XKe6BarvZH75rqTD/HZmeI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X8NHtD8I8BpYJd1FEmx0+FFT6YNiti/FCkl8YAgokzMlLEiahVIizV50A9ROe+3FHBHOsWa5ZW01EPfGZ6nAT2eExhUaEoCWreTqi8q5YbR3V7GdyJtQw2S2bcBCtxsTi4XSSXRDVqpEn4sl7o7luTPiuzHdK7Ky9bWs+e50E18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAA56872F2;
	Tue,  2 Dec 2025 16:24:41 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 2F0D660017;
	Tue,  2 Dec 2025 16:24:40 +0000 (UTC)
Date: Tue, 2 Dec 2025 11:25:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
Cc: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>,
 "Kiszka, Jan" <jan.kiszka@siemens.com>, "Poljakow, Andre"
 <andre.poljakow@siemens.com>
Subject: Re: libtraceevent | API clarifications needed
Message-ID: <20251202112539.1e042264@gandalf.local.home>
In-Reply-To: <7ce07a566354a6d2233e231a6a7bc760447c7547.camel@siemens.com>
References: <7ce07a566354a6d2233e231a6a7bc760447c7547.camel@siemens.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cck9cnhmzphe4ehx3ncgqnt4iubsug4f
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 2F0D660017
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/bXM/fnSH5Otl/O5R4YfgfUSb9hZe2I48=
X-HE-Tag: 1764692680-925209
X-HE-Meta: U2FsdGVkX193Fvdom/Y2bq4r0pS3VsKtRRnSTPMBojBP/DNTtswtuQfkDxRe0NxjQJoMzYd923lif7lndjV4iogcMOclK36lqIqQv7AGfwY9FmpDLJBxV/UF97RBFDDS3FKJ9HGV9FG6od7NRz/xnYZNk4wxMySCAjJOX0U9lXdQLizTrYAnL9fK8KcBoJohzY2hJ+M6/EZfPPnp333z8i767csRxbcMGDDznFcSDv59EB+Eq+6yiEQ8DtF96Ew7ijXTiJdG0mDJ7wYQhnYkG0dRdsqg5GhapTn6heurWZCDE4CPL46c3ISLLcHwCuDyq5rOiVKuN7G7WEBvu3fXmZwHknokDgkK

On Mon, 1 Dec 2025 15:38:32 +0000
"MOESSBAUER, Felix" <felix.moessbauer@siemens.com> wrote:

> Dear tracers,
> 
> while continuing the development of the ftrace-to-ctf converter [1], I
> noticed the following in the traceevent API that needs some
> clarification:
> 
> half-length signed integers
> 
> What is the recommended way to read a field value that is a half-length
> (i.e. 32 bit) or smaller signed integer? Currently, I'm using the
> tep_get_field_val which returns the value as unsigned long long
> (usually 8 byte). This value contains the raw bits (endian-corrected),
> hence a int32_t (-1) is represented as FFFF FFFF. I'm currently
> manually converting this, but I'm wondering if there is a better way of
> doing it.

First I'll say that I absolutely hate the libtraceevent interface.
Unfortunately, it was ported over to perf before it was "sanitized". But oh
well, I have to live with it. I would love to come up with a new interface
that would make all this easier.

Yes, the caller of tep_get_field_val() needs to know the sign and handle
the result. Hmm, I wonder if we did look at the field to determine if it is
signed or not and sign extend if it is, if that would break any
applications :-/



> 
> 
> arrays of integers
> 
> The only API I found to read int[x] types (arrays of integers) is
> tep_get_field_raw. However, this just gives me the raw bytes of the
> trace buffer. Does it mean I need to take care of endian correctness?
> Are trace buffers always little-endian, or is this an implementation
> detail?

Correct, it's simply a pointer to the raw value in the data record. The
caller is responsible for handling endianess. The endianess of the source
can be found with: tep->file_bigendian;

If tep->file_bigendian != tep_is_bigendian() then a swap is needed.

> 
> unbounded arrays
> 
> These arrays have both their size= and arraylen= attributes set to 0.
> How do I know how wide the types are? Especially given that the type
> names (e.g. unsigned long) are platform specific? An example event is
> "funcgraph_entry" with format ... "field:unsigned long args[];    
> offset:24;      size:0; signed:0;"

Note, the unbounded arrays are only for ftrace manually defined events.
They are not available for normal trace events (event created by the
TRACE_EVENT() macro). They do need to be manually handled.

> 
> symbolic fields
> 
> How to get the symbolic representation of fields that are marked
> TEP_FIELD_IS_SYMBOLIC (example: softirq_entry->vec)? I tried
> tep_print_field_content, but this converts the data to a string integer
> instead of the symbolic representation (e.g. I get a "0" instead of a 
> "HI").

This is something I even wanted, but there's not really a good way to do
it. Although, I wanted a generic way, but if a field is marked symbolic, we
could use that. That is, we would need to parse the print_fmt array itself,
and find the:

 "__print_symbolic(REC->vec, { 0, "HI" }, { 1, "TIMER" }, { 2, "NET_TX" }, { 3, "NET_RX" }, { 4, "BLOCK" }, { 5, "IRQ_POLL" }, { 6, "TASKLET" }, { 7, "SCHED" }, { 8, "HRTIMER" }, { 9, "RCU" })"

That is, look for the "__print_symbolic(REC->[FIELD-NAME], ..." and parse that.

Hmm,

-- Steve


