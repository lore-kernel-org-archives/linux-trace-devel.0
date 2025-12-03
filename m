Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3F8303A28
	for <linux-trace-devel@vger.kernel.org>; Wed,  3 Dec 2025 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777968; cv=none; b=WcWW5qAO0JvLxfBCVPPMVW9i9yEjloKLg1Hjx0DX8fkt/boJOoubohfuZRY7h062K3aOg+MkB4FiBp4/tK5WJ4yBJ2oXN25b7tgWF+/MVtooGYRKc3vMcv3A7CZNPejoEB0GLbTsBx2/KZHAG/pAVsJTji7eEVNCBtmQ+ZOKFwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777968; c=relaxed/simple;
	bh=fvZ93GHz+imD/t1YnkoDcmPVFpbVFCRW/whRnsHlgE0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ub+RJbUyNZRIPYZqoE5sS/poITFk7tic5sCI6ULoXXF3krN/8nocYkU15pWB98qIJ4HDf2HkG3rL4XtNO7Uj+5mG2APj4MuEHVy6l9sR2okq0uA9LBU5FA11vdc8pJzGYOh54J+vO9ePvh23XMZwxTDaIMnQYBScUFxgqIRX79Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1683B9A6C;
	Wed,  3 Dec 2025 16:06:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id F0F362002C;
	Wed,  3 Dec 2025 16:06:02 +0000 (UTC)
Date: Wed, 3 Dec 2025 11:07:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
Cc: "Kiszka, Jan" <jan.kiszka@siemens.com>, "Poljakow, Andre"
 <andre.poljakow@siemens.com>, "linux-trace-devel@vger.kernel.org"
 <linux-trace-devel@vger.kernel.org>
Subject: Re: libtraceevent | API clarifications needed
Message-ID: <20251203110705.714daa5e@gandalf.local.home>
In-Reply-To: <a22fa13aad752c43c927ab42b71d8e9caf7bf573.camel@siemens.com>
References: <7ce07a566354a6d2233e231a6a7bc760447c7547.camel@siemens.com>
	<20251202112539.1e042264@gandalf.local.home>
	<a22fa13aad752c43c927ab42b71d8e9caf7bf573.camel@siemens.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wj3afmx7iyosstk684c9rf44agyrnkej
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: F0F362002C
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/gXYPSiCxFGnxyNWLsOKGRrQjtDsKtLyE=
X-HE-Tag: 1764777962-94950
X-HE-Meta: U2FsdGVkX1/qYgVOKSmBX5EGNoDdr1ft32NM9irP1LWbuy5MmpsX+U12FNpTXB/wOQ3CPYWoF/mPqKwgDIfkMPVnzOXVORBovFo63CI9O12nLLdks5BeE5wSh+5SnlcKUVRa7PN8f7qCYdRw7B4A525bTMZ/g0JdH/nRUk00fiZanGGVEbQ5Sqo9YtMGA2qaLd17GqYrvda7DzuByeYFankxntmZeDjmppogfYQsqcrhmunj7Gn3L+arTGClsxq851M8azoLBDpX1B3aGwp/ISXejtUXIelTFCwlLZ5IaFADfTqvNYB5KFUMoEF0Mbn9va+trT0KwpmSDDaIMc77hd4mmdq7aOca

On Wed, 3 Dec 2025 11:20:34 +0000
"MOESSBAUER, Felix" <felix.moessbauer@siemens.com> wrote:

> > First I'll say that I absolutely hate the libtraceevent interface.
> > Unfortunately, it was ported over to perf before it was "sanitized". But oh
> > well, I have to live with it. I would love to come up with a new interface
> > that would make all this easier.  
> 
> No need for excuses. The library is great and tremendously simplifies
> working with trace events. Thank you!

Not an excuse. I curse the API all the time ;-)

I wrote it, but I still need to reference the man pages to figure out how
to use it. If the author can't use their own API without referencing a
manual, that's a sure sign that the API sucks!


> > If tep->file_bigendian != tep_is_bigendian() then a swap is needed.  
> 
> Ok, but I just found the tep_read_number() interface which I'm now
> using as following:
> 
> data_raw=tep_get_field_raw(NULL, trace_event, field->name, rec, &len,
> 0);
> item_size=len / field->arraylen;
> val=tep_read_number(field->event->tep, &data_raw[i * item_size], len);
> 
> This should also do the job, as tep_read_number() takes care of the
> endianess handling.

Great!


> > > 
> > > symbolic fields
> > > 
> > > How to get the symbolic representation of fields that are marked
> > > TEP_FIELD_IS_SYMBOLIC (example: softirq_entry->vec)? I tried
> > > tep_print_field_content, but this converts the data to a string integer
> > > instead of the symbolic representation (e.g. I get a "0" instead of a 
> > > "HI").  
> > 
> > This is something I even wanted, but there's not really a good way to do
> > it. Although, I wanted a generic way, but if a field is marked symbolic, we
> > could use that. That is, we would need to parse the print_fmt array itself,
> > and find the:
> > 
> >  "__print_symbolic(REC->vec, { 0, "HI" }, { 1, "TIMER" }, { 2, "NET_TX" }, { 3, "NET_RX" }, { 4, "BLOCK" }, { 5, "IRQ_POLL" }, { 6, "TASKLET" }, { 7, "SCHED" }, { 8, "HRTIMER" }, { 9, "RCU" })"
> > 
> > That is, look for the "__print_symbolic(REC->[FIELD-NAME], ..." and parse that.  
> 
> The trace-cmd report seems to be able to symbolize this, as well as
> symbolizing instruction pointers (e.g. the caller field of the ftrace
> kernel_stack). Not that I currently need this, but I'm wondering how
> trace-cmd is able to do this. Probably need to check the sources.
> 

Probably due to plugins. Run: trace-cmd report -N

If it still shows things properly, then it did do something special.
Otherwise a plugin took over. They are in libtraceevent, in the plugins
directory. There are several plugins that override how an event is read and
it does the work manually.

-- Steve
